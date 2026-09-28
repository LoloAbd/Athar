import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// User-authored messages are stored separately from system content.
class RandomMessageService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Random _random = Random();

  User? get currentUser => _auth.currentUser;
  String get currentUserId {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception('User is not logged in.');
    return uid;
  }

  CollectionReference<Map<String, dynamic>> get _messages =>
      _firestore.collection('user_messages');

  Future<Map<String, dynamic>> getCurrentUserData() async {
    final snapshot = await _firestore.collection('user').doc(currentUserId).get();
    if (!snapshot.exists) throw Exception('User data not found.');
    return snapshot.data() ?? {};
  }

  Future<String> getCurrentUsername() async =>
      (await getCurrentUserData())['username']?.toString() ?? '';

  Future<String> scheduleMessageToSelf({
    required String message,
    required DateTime scheduledAt,
  }) async {
    _validateMessage(message);
    if (scheduledAt.isBefore(DateTime.now())) {
      throw Exception('Scheduled time must be in the future.');
    }
    final uid = currentUserId;
    final username = await getCurrentUsername();
    final ref = _messages.doc();
    await ref.set({
      'messageId': ref.id,
      'message': message.trim(),
      'textAr': message.trim(),
      'textEn': message.trim(),
      'type': 'self_scheduled',
      'senderId': uid,
      'senderUsername': username,
      'receiverId': uid,
      'receiverUsername': username,
      'scheduledAt': Timestamp.fromDate(scheduledAt),
      'createdAt': FieldValue.serverTimestamp(),
      'isRead': false,
      'status': 'scheduled',
    });
    await _firestore
        .collection('user')
        .doc(uid)
        .collection('notifications')
        .doc(ref.id)
        .set({
          'messageId': ref.id,
          'type': 'scheduled_user_message',
          'senderId': uid,
          'receiverId': uid,
          'scheduledAt': Timestamp.fromDate(scheduledAt),
          'createdAt': FieldValue.serverTimestamp(),
          'isRead': false,
        });
    return ref.id;
  }

  Future<Map<String, dynamic>> scheduleMessageToSelfAtRandomTime({
    required String message,
    Duration minimumDelay = const Duration(hours: 1),
    Duration maximumDelay = const Duration(days: 7),
  }) async {
    final now = DateTime.now();
    if (maximumDelay <= minimumDelay) throw Exception('Invalid delay range.');
    final span = maximumDelay.inSeconds - minimumDelay.inSeconds;
    final at = now.add(Duration(seconds: minimumDelay.inSeconds + _random.nextInt(span)));
    final id = await scheduleMessageToSelf(message: message, scheduledAt: at);
    return {'messageId': id, 'scheduledAt': at};
  }

  Future<Map<String, dynamic>?> getRandomUser({String? excludeUserId}) async {
    final snapshot = await _firestore.collection('user').get();
    final users = snapshot.docs.where((doc) {
      if (doc.id == currentUserId || doc.id == excludeUserId) return false;
      return (doc.data()['username']?.toString().trim().isNotEmpty ?? false);
    }).toList();
    if (users.isEmpty) return null;
    final selected = users[_random.nextInt(users.length)];
    final data = selected.data();
    return {'uid': selected.id, 'username': data['username'] ?? '', 'name': data['name'] ?? ''};
  }

  Future<String> sendMessageToRandomUser({required String message, String? excludeUserId}) async {
    _validateMessage(message);
    final recipient = await getRandomUser(excludeUserId: excludeUserId);
    if (recipient == null) throw Exception('No other users available.');
    return sendMessageToUser(
      message: message,
      receiverId: recipient['uid'] as String,
      receiverUsername: recipient['username'] as String,
    );
  }

  Future<String> sendMessageToUser({
    required String message,
    required String receiverId,
    required String receiverUsername,
  }) async {
    _validateMessage(message);
    final senderId = currentUserId;
    if (receiverId == senderId) throw Exception('Use self scheduling for personal messages.');
    final senderUsername = await getCurrentUsername();
    final ref = _messages.doc();
    await ref.set({
      'messageId': ref.id,
      'message': message.trim(),
      'textAr': message.trim(),
      'textEn': message.trim(),
      'type': 'random',
      'senderId': senderId,
      'senderUsername': senderUsername,
      'receiverId': receiverId,
      'receiverUsername': receiverUsername,
      'createdAt': FieldValue.serverTimestamp(),
      'isRead': false,
      'status': 'pending',
    });
    // In-app notification record, scoped to the selected recipient only.
    await _firestore.collection('user').doc(receiverId).collection('notifications').doc(ref.id).set({
      'messageId': ref.id,
      'type': 'user_message',
      'senderId': senderId,
      'receiverId': receiverId,
      'createdAt': FieldValue.serverTimestamp(),
      'isRead': false,
    });
    return ref.id;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getInbox() => _messages
      .where('receiverId', isEqualTo: currentUserId)
      .snapshots();

  Stream<QuerySnapshot<Map<String, dynamic>>> getNotifications() => _firestore
      .collection('user').doc(currentUserId).collection('notifications')
      .orderBy('createdAt', descending: true).snapshots();

  Stream<QuerySnapshot<Map<String, dynamic>>> getUnreadNotifications() => _firestore
      .collection('user').doc(currentUserId).collection('notifications')
      .where('isRead', isEqualTo: false).snapshots();

  Future<void> markRead(String messageId) async {
    final uid = currentUserId;
    final batch = _firestore.batch();
    batch.update(_messages.doc(messageId), {'isRead': true});
    batch.set(_firestore.collection('user').doc(uid).collection('notifications').doc(messageId), {'isRead': true}, SetOptions(merge: true));
    await batch.commit();
  }

  Future<void> respondToMessage(String messageId, {required bool accept}) async {
    final uid = currentUserId;
    final ref = _messages.doc(messageId);
    final snap = await ref.get();
    if (!snap.exists || snap.data()?['receiverId'] != uid) throw Exception('Message not found.');
    final status = snap.data()?['status'];
    if (status != 'pending') return;
    final notificationRef = _firestore
        .collection('user')
        .doc(uid)
        .collection('notifications')
        .doc(messageId);
    final batch = _firestore.batch();
    batch.update(ref, {
      'status': accept ? 'accepted' : 'rejected',
      'isRead': true,
      'respondedAt': FieldValue.serverTimestamp(),
    });
    if (accept) {
      batch.set(notificationRef, {'isRead': true}, SetOptions(merge: true));
    } else {
      batch.delete(notificationRef);
    }
    await batch.commit();
  }

  Future<Map<String, dynamic>?> getMessage(String messageId) async {
    final snapshot = await _messages.doc(messageId).get();
    return snapshot.data();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getUserHistory() => getInbox();

  Stream<QuerySnapshot<Map<String, dynamic>>> getScheduledMessages() => _messages
      .where('receiverId', isEqualTo: currentUserId).where('status', isEqualTo: 'scheduled')
      .orderBy('scheduledAt').snapshots();

  Future<void> cancelScheduledMessage(String messageId) async {
    final ref = _messages.doc(messageId);
    final snap = await ref.get();
    if (!snap.exists || snap.data()?['receiverId'] != currentUserId || snap.data()?['senderId'] != currentUserId || snap.data()?['status'] != 'scheduled') {
      throw Exception('This message cannot be cancelled.');
    }
    await ref.update({'status': 'cancelled'});
  }

  Future<void> deleteMessage(String messageId) async {
    final ref = _messages.doc(messageId);
    final snap = await ref.get();
    if (snap.exists && snap.data()?['receiverId'] == currentUserId) await ref.delete();
  }

  void _validateMessage(String message) {
    if (message.trim().isEmpty) throw Exception('Message is empty.');
    if (message.trim().length > 500) throw Exception('Message is too long.');
  }
}
