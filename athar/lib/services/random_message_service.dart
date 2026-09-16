import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RandomMessageService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final Random _random = Random();

  // =====================================================
  // Current User
  // =====================================================

  User? get currentUser => _auth.currentUser;

  String get currentUserId {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User is not logged in.');
    }

    return user.uid;
  }

  // =====================================================
  // Get Current User Data
  // =====================================================

  Future<Map<String, dynamic>> getCurrentUserData() async {
    final uid = currentUserId;

    final snapshot = await _firestore.collection('user').doc(uid).get();

    if (!snapshot.exists) {
      throw Exception('User data not found.');
    }

    return snapshot.data() ?? {};
  }

  // =====================================================
  // Get Current Username
  // =====================================================

  Future<String> getCurrentUsername() async {
    final data = await getCurrentUserData();

    return data['username'] ?? '';
  }

  // =====================================================
  // 1. Schedule Message To Self
  // User chooses date and time
  // =====================================================

  Future<String> scheduleMessageToSelf({
    required String message,
    required DateTime scheduledAt,
  }) async {
    final uid = currentUserId;

    _validateMessage(message);

    if (scheduledAt.isBefore(DateTime.now())) {
      throw Exception('Scheduled time must be in the future.');
    }

    final username = await getCurrentUsername();

    final messageRef = _firestore.collection('messages').doc();

    final messageData = {
      'messageId': messageRef.id,

      'message': message.trim(),

      'type': 'self_scheduled',

      'senderId': uid,
      'senderUsername': username,

      'receiverId': uid,
      'receiverUsername': username,

      'scheduledAt': Timestamp.fromDate(scheduledAt),

      'createdAt': FieldValue.serverTimestamp(),

      'isDelivered': false,

      'isRead': false,

      'status': 'scheduled',
    };

    await messageRef.set(messageData);

    // Add to user's history
    await _firestore
        .collection('user')
        .doc(uid)
        .collection('history')
        .doc(messageRef.id)
        .set(messageData);

    return messageRef.id;
  }

  // =====================================================
  // 2. Schedule Message To Self
  // System chooses a random future time
  // =====================================================

  Future<Map<String, dynamic>> scheduleMessageToSelfAtRandomTime({
    required String message,
    Duration minimumDelay = const Duration(hours: 1),
    Duration maximumDelay = const Duration(days: 7),
  }) async {
    final now = DateTime.now();

    _validateMessage(message);

    if (maximumDelay <= minimumDelay) {
      throw Exception('Maximum delay must be greater than minimum delay.');
    }

    final difference = maximumDelay.inSeconds - minimumDelay.inSeconds;

    final randomSeconds = minimumDelay.inSeconds + _random.nextInt(difference);

    final scheduledAt = now.add(Duration(seconds: randomSeconds));

    final messageId = await scheduleMessageToSelf(
      message: message,
      scheduledAt: scheduledAt,
    );

    return {'messageId': messageId, 'scheduledAt': scheduledAt};
  }

  // =====================================================
  // 3. Get Random User
  // =====================================================

  Future<Map<String, dynamic>?> getRandomUser({String? excludeUserId}) async {
    final currentUid = currentUserId;

    final snapshot = await _firestore.collection('user').get();

    final users = snapshot.docs.where((doc) {
      // Never select current user
      if (doc.id == currentUid) {
        return false;
      }

      // Optional additional exclusion
      if (excludeUserId != null && doc.id == excludeUserId) {
        return false;
      }

      final data = doc.data();

      final username = data['username'];

      // User must have username
      if (username == null || username.toString().trim().isEmpty) {
        return false;
      }

      return true;
    }).toList();

    if (users.isEmpty) {
      return null;
    }

    final randomIndex = _random.nextInt(users.length);

    final selectedUser = users[randomIndex];

    final data = selectedUser.data();

    return {
      'uid': selectedUser.id,

      'username': data['username'] ?? '',

      'name': data['name'] ?? '',
    };
  }

  // =====================================================
  // 4. Send Message To Random User
  // =====================================================

  Future<String> sendMessageToRandomUser({
    required String message,
    String? excludeUserId,
  }) async {
    _validateMessage(message);

    final randomUser = await getRandomUser(excludeUserId: excludeUserId);

    if (randomUser == null) {
      throw Exception('No other users available.');
    }

    final receiverId = randomUser['uid'] as String;

    final receiverUsername = randomUser['username'] as String;

    return sendMessageToUser(
      message: message,
      receiverId: receiverId,
      receiverUsername: receiverUsername,
    );
  }

  // =====================================================
  // 5. Send Message To Specific User
  // =====================================================

  Future<String> sendMessageToUser({
    required String message,
    required String receiverId,
    required String receiverUsername,
  }) async {
    final senderId = currentUserId;

    _validateMessage(message);

    final senderUsername = await getCurrentUsername();

    final messageRef = _firestore.collection('messages').doc();

    final messageData = {
      'messageId': messageRef.id,

      'message': message.trim(),

      'type': 'random',

      'senderId': senderId,

      'senderUsername': senderUsername,

      'receiverId': receiverId,

      'receiverUsername': receiverUsername,

      'createdAt': FieldValue.serverTimestamp(),

      'isDelivered': true,

      'isRead': false,

      'status': 'sent',
    };

    // ===================================================
    // Save everything as one batch
    // ===================================================

    final batch = _firestore.batch();

    // Main messages collection
    batch.set(messageRef, messageData);

    // Receiver history
    final receiverHistoryRef = _firestore
        .collection('user')
        .doc(receiverId)
        .collection('history')
        .doc(messageRef.id);

    batch.set(receiverHistoryRef, messageData);

    // Sender history
    final senderHistoryRef = _firestore
        .collection('user')
        .doc(senderId)
        .collection('history')
        .doc(messageRef.id);

    batch.set(senderHistoryRef, {...messageData, 'direction': 'sent'});

    await batch.commit();

    return messageRef.id;
  }

  // =====================================================
  // 6. Get Message By ID
  // =====================================================

  Future<Map<String, dynamic>?> getMessage(String messageId) async {
    final snapshot = await _firestore
        .collection('messages')
        .doc(messageId)
        .get();

    if (!snapshot.exists) {
      return null;
    }

    return snapshot.data();
  }

  // =====================================================
  // 7. Get User History
  // =====================================================

  Stream<QuerySnapshot<Map<String, dynamic>>> getUserHistory() {
    final uid = currentUserId;

    return _firestore
        .collection('user')
        .doc(uid)
        .collection('history')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  // =====================================================
  // 8. Get Scheduled Messages
  // =====================================================

  Stream<QuerySnapshot<Map<String, dynamic>>> getScheduledMessages() {
    final uid = currentUserId;

    return _firestore
        .collection('messages')
        .where('receiverId', isEqualTo: uid)
        .where('status', isEqualTo: 'scheduled')
        .orderBy('scheduledAt', descending: false)
        .snapshots();
  }

  // =====================================================
  // 9. Cancel Scheduled Message
  // =====================================================

  Future<void> cancelScheduledMessage(String messageId) async {
    final uid = currentUserId;

    final messageRef = _firestore.collection('messages').doc(messageId);

    final messageSnapshot = await messageRef.get();

    if (!messageSnapshot.exists) {
      throw Exception('Message not found.');
    }

    final data = messageSnapshot.data()!;

    // Make sure this message belongs
    // to the current user
    if (data['receiverId'] != uid || data['senderId'] != uid) {
      throw Exception('You cannot cancel this message.');
    }

    if (data['status'] != 'scheduled') {
      throw Exception('This message is not scheduled.');
    }

    final batch = _firestore.batch();

    batch.update(messageRef, {'status': 'cancelled'});

    final historyRef = _firestore
        .collection('user')
        .doc(uid)
        .collection('history')
        .doc(messageId);

    batch.update(historyRef, {'status': 'cancelled'});

    await batch.commit();
  }

  // =====================================================
  // 10. Delete Message
  // =====================================================

  Future<void> deleteMessage(String messageId) async {
    final uid = currentUserId;

    final messageRef = _firestore.collection('messages').doc(messageId);

    final historyRef = _firestore
        .collection('user')
        .doc(uid)
        .collection('history')
        .doc(messageId);

    final batch = _firestore.batch();

    batch.delete(historyRef);

    batch.delete(messageRef);

    await batch.commit();
  }

  // =====================================================
  // Validation
  // =====================================================

  void _validateMessage(String message) {
    if (message.trim().isEmpty) {
      throw Exception('Message is empty.');
    }

    if (message.trim().length > 500) {
      throw Exception('Message is too long.');
    }
  }
}
