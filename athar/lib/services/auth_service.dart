// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:math';

class GoogleAuthResult {
  final UserCredential? credential;
  final bool emailAlreadyExists;
  final bool accountNotFound;
  final String? message;

  GoogleAuthResult({
    this.credential,
    this.emailAlreadyExists = false,
    this.accountNotFound = false,
    this.message,
  });
}

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  // ============================================================
  // SIGN UP (Email & Password)
  // ============================================================
  Future<User?> signUp({
    required String name,
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      final User? user = userCredential.user;

      if (user != null) {
        await _firestore.collection('user').doc(user.uid).set({
          'name': name,
          'username': username,
          'email': email,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        // print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        // print('The account already exists for that email.');
      } else {
        // print('Firebase Auth Error: ${e.message}');
      }
      rethrow;
    } catch (e) {
      // print('An unexpected error occurred: $e');
      rethrow;
    }
  }

  // ============================================================
  // LOGIN (Email & Password)
  // ============================================================
  Future<UserCredential> login({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // ============================================================
  // LOGOUT
  // ============================================================
  Future<void> logout() async {
    try {
      await _googleSignIn.signOut();
    } catch (_) {
      // مش مشكلة لو مستخدم ما سجل دخول بجوجل أصلاً
    }
    await _auth.signOut();
  }

  // =============================================================
  // Reset Password
  // =============================================================
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      print('Password reset error: ${e.code}');
      print('Message: ${e.message}');
      rethrow;
    }
  }

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<GoogleAuthResult> signInWithGoogle({required bool isSignUp}) async {
    String step = 'start';

    String fmt(String type, Object e, {String? code, String? msg}) {
      return 'الخطوة: $step\n'
          'النوع: $type\n'
          '${code != null ? 'code: $code\n' : ''}'
          '${msg != null ? 'message: $msg\n' : ''}'
          'raw: $e';
    }

    try {
      step = '1-authenticate';
      final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();

      step = '2-get-idToken';
      final googleAuth = googleUser.authentication;
      if (googleAuth.idToken == null) {
        return GoogleAuthResult(
          message:
              'الخطوة: $step\nidToken = null\n'
              'غالباً serverClientId ناقص أو مش Web client ID',
        );
      }

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      step = '3-firebase-signIn';
      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      final User? user = userCredential.user;
      final bool isNewUser =
          userCredential.additionalUserInfo?.isNewUser ?? false;

      step = '4-check-signup-or-login';
      if (isSignUp && !isNewUser) {
        await _auth.signOut();
        await _googleSignIn.signOut();
        return GoogleAuthResult(emailAlreadyExists: true);
      }

      if (!isSignUp && isNewUser) {
        try {
          await user?.delete();
        } catch (_) {}
        await _auth.signOut();
        await _googleSignIn.signOut();
        return GoogleAuthResult(accountNotFound: true);
      }

      step = '5-firestore-write';
      if (user != null) {
        await _createOrUpdateGoogleUser(user);
      }

      return GoogleAuthResult(credential: userCredential);
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        return GoogleAuthResult(
          message: fmt(
            'GoogleSignInException',
            e,
            code: 'canceled',
            msg: e.description,
          ),
        );
      }
      return GoogleAuthResult(
        message: fmt(
          'GoogleSignInException',
          e,
          code: e.code.name,
          msg: e.description,
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        return GoogleAuthResult(emailAlreadyExists: true);
      }
      return GoogleAuthResult(
        message: fmt('FirebaseAuthException', e, code: e.code, msg: e.message),
      );
    } on FirebaseException catch (e) {
      return GoogleAuthResult(
        message: fmt(
          'FirebaseException (${e.plugin})',
          e,
          code: e.code,
          msg: e.message,
        ),
      );
    } catch (e) {
      return GoogleAuthResult(message: fmt(e.runtimeType.toString(), e));
    }
  }

  // ============================================================
  // إنشاء أو تحديث مستند المستخدم بعد تسجيل الدخول بجوجل
  // ============================================================
  Future<void> _createOrUpdateGoogleUser(User user) async {
    final userRef = _firestore.collection('user').doc(user.uid);

    final userDoc = await userRef.get();

    if (!userDoc.exists) {
      final String email = user.email ?? '';
      final String name = user.displayName ?? '';
      final String username = email.isNotEmpty ? email.split('@').first : '';

      await userRef.set({
        'name': name,
        'username': username,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });

      print('New Google user created');
    } else {
      print('Existing user - keeping existing Firestore data');
    }
  }

  // ============================================================
  // GET USER DATA
  // ============================================================
  Future<Map<String, dynamic>?> getUserData() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    try {
      final userDoc = await _firestore.collection('user').doc(user.uid).get();
      if (!userDoc.exists) return null;
      return userDoc.data();
    } catch (e) {
      print('Error getting user data: $e');
      return null;
    }
  }

  // ============================================================
  // GET USER NAME
  // ============================================================
  Future<String?> getUserName() async {
    final userData = await getUserData();
    return userData?['name'] as String?;
  }

  // ============================================================
  // GET USER EMAIL
  // ============================================================
  String? getUserEmail() {
    return _auth.currentUser?.email;
  }

  // ============================================================
  // USER DATA STREAM
  // ============================================================
  Stream<Map<String, dynamic>?> userDataStream() {
    final user = _auth.currentUser;
    if (user == null) return Stream.value(null);

    return _firestore
        .collection('user')
        .doc(user.uid)
        .snapshots()
        .map((doc) => doc.data());
  }

  // ============================================================
  // IS USERNAME TAKEN
  // بيتجاهل اسم المستخدم الحالي حتى ما يمنع المستخدم من حفظ نفس اسمه
  // ============================================================
  Future<bool> isUsernameTaken(String username) async {
    final user = _auth.currentUser;
    final String value = username.trim().toLowerCase();
    if (value.isEmpty) return false;

    try {
      final snapshot = await _firestore
          .collection('user')
          .where('username'.trim().toLowerCase(), isEqualTo: value)
          .limit(2)
          .get();

      return snapshot.docs.any((doc) => doc.id != user?.uid);
    } catch (e) {
      print('Error checking username: $e');
      return false;
    }
  }

  // ============================================================
  // GET FAVORITES COUNT
  // ============================================================
  Future<int> getFavoritesCount() async {
    final user = _auth.currentUser;
    if (user == null) return 0;

    try {
      final snapshot = await _firestore
          .collection('user')
          .doc(user.uid)
          .collection('favorites')
          .get();

      print('Favorites count: ${snapshot.docs.length}');
      return snapshot.docs.length;
    } catch (e) {
      print('Error getting favorites count: $e');
      return 0;
    }
  }

  // ============================================================
  // GET HISTORY COUNT
  // ============================================================
  Future<int> getReceivedMessagesCount() async {
    final user = _auth.currentUser;
    if (user == null) return 0;

    try {
      final snapshot = await _firestore
          .collection('user')
          .doc(user.uid)
          .collection('history')
          .get();

      print('History count: ${snapshot.docs.length}');
      return snapshot.docs.length;
    } catch (e) {
      print('Error getting received messages count: $e');
      return 0;
    }
  }

  // ============================================================
  // GET JOIN DATE
  // ============================================================
  Future<DateTime?> getJoinDate() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    try {
      final userDoc = await _firestore.collection('user').doc(user.uid).get();
      if (!userDoc.exists) return null;

      final data = userDoc.data();
      if (data == null) return null;

      final timestamp = data['createdAt'];
      if (timestamp is Timestamp) {
        return timestamp.toDate();
      }
      return null;
    } catch (e) {
      print('Error getting join date: $e');
      return null;
    }
  }

  // ============================================================
  // FORMAT DATE
  // ============================================================
  String _formatDate(Timestamp? timestamp) {
    if (timestamp == null) return '';
    final date = timestamp.toDate();
    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month]} ${date.day}, ${date.year}';
  }

  // ============================================================
  // FORMAT TIME
  // ============================================================
  String _formatTime(Timestamp? timestamp) {
    if (timestamp == null) return '';
    final date = timestamp.toDate();
    int hour = date.hour;
    final minute = date.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    if (hour == 0) {
      hour = 12;
    } else if (hour > 12) {
      hour -= 12;
    }
    return '$hour:$minute $period';
  }

  // ============================================================
  // GET HISTORY MESSAGES
  // ============================================================
  Future<List<Map<String, dynamic>>> getHistoryMessages() async {
    final user = _auth.currentUser;
    if (user == null) return [];

    try {
      final historySnapshot = await _firestore
          .collection('user')
          .doc(user.uid)
          .collection('history')
          .get();

      final List<Map<String, dynamic>> messages = [];

      for (final historyDoc in historySnapshot.docs) {
        final messageId = historyDoc.id;

        final messageDoc = await _firestore
            .collection('messages')
            .doc(messageId)
            .get();
        if (!messageDoc.exists) {
          print('Message not found: $messageId');
          continue;
        }
        final messageData = messageDoc.data();
        if (messageData == null) continue;
        // History is reserved for system messages. Older app versions copied
        // user-authored messages here, so filter those legacy records out.
        if (messageData.containsKey('senderId') ||
            messageData.containsKey('receiverId')) {
          continue;
        }

        final historyData = historyDoc.data();
        final Timestamp? viewedAt = historyData['viewedAt'] is Timestamp
            ? historyData['viewedAt'] as Timestamp
            : null;

        messages.add({
          'textAr': messageData['textAr'] ?? '',
          'textEn': messageData['textEn'] ?? '',
          'type': messageData['type'] ?? '',
          'messageId': messageId,
          'viewedAt': viewedAt,
          'date': _formatDate(viewedAt),
          'time': _formatTime(viewedAt),
        });
      }

      messages.sort((a, b) {
        final Timestamp? dateA = a['viewedAt'];
        final Timestamp? dateB = b['viewedAt'];
        if (dateA == null) return 1;
        if (dateB == null) return -1;
        return dateB.compareTo(dateA);
      });

      return messages;
    } catch (e) {
      print('Error getting history messages: $e');
      return [];
    }
  }

  // ============================================================
  // GET FAVORITE MESSAGES
  // ============================================================
  Future<List<Map<String, dynamic>>> getFavoriteMessages() async {
    final user = _auth.currentUser;
    if (user == null) return [];

    try {
      final favoritesSnapshot = await _firestore
          .collection('user')
          .doc(user.uid)
          .collection('favorites')
          .get();

      final List<Map<String, dynamic>> messages = [];

      for (final favoriteDoc in favoritesSnapshot.docs) {
        final messageId = favoriteDoc.id;

        final messageDoc = await _firestore
            .collection('messages')
            .doc(messageId)
            .get();
        if (!messageDoc.exists) continue;

        final messageData = messageDoc.data();
        if (messageData == null) continue;
        if (messageData.containsKey('senderId') ||
            messageData.containsKey('receiverId')) {
          continue;
        }

        final favoriteData = favoriteDoc.data();
        final Timestamp? addedAt = favoriteData['addedAt'] is Timestamp
            ? favoriteData['addedAt'] as Timestamp
            : null;

        messages.add({
          'textAr': messageData['textAr'] ?? '',
          'textEn': messageData['textEn'] ?? '',
          'type': messageData['type'] ?? '',
          'messageId': messageId,
          'addedAt': addedAt,
          'date': _formatDate(addedAt),
          'time': _formatTime(addedAt),
        });
      }

      messages.sort((a, b) {
        final Timestamp? dateA = a['addedAt'];
        final Timestamp? dateB = b['addedAt'];
        if (dateA == null) return 1;
        if (dateB == null) return -1;
        return dateB.compareTo(dateA);
      });

      return messages;
    } catch (e) {
      print('Error getting favorite messages: $e');
      return [];
    }
  }

  // ============================================================
  // ADD TO FAVORITES
  // ============================================================
  Future<void> addFavoriteMessage(
    String messageId,
    Map<String, dynamic> message,
  ) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User is not logged in');
    }

    await _firestore
        .collection('user')
        .doc(user.uid)
        .collection('favorites')
        .doc(messageId)
        .set({'messageId': messageId, 'addedAt': Timestamp.now()});
  }

  // ============================================================
  // IS FAVORITE
  // ============================================================
  Future<bool> isFavorite(String messageId) async {
    final user = _auth.currentUser;
    if (user == null) return false;

    final favoriteDoc = await _firestore
        .collection('user')
        .doc(user.uid)
        .collection('favorites')
        .doc(messageId)
        .get();

    return favoriteDoc.exists;
  }

  // ============================================================
  // REMOVE FROM FAVORITES
  // ============================================================
  Future<void> removeFavoriteMessage(String messageId) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User is not logged in');
    }

    await _firestore
        .collection('user')
        .doc(user.uid)
        .collection('favorites')
        .doc(messageId)
        .delete();
  }

  // ============================================================
  // GET RANDOM MESSAGE
  // ============================================================
  Future<Map<String, dynamic>?> getRandomMessage() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User is not logged in');
    }

    final messagesSnapshot = await _firestore.collection('messages').get();
    if (messagesSnapshot.docs.isEmpty) return null;

    final historySnapshot = await _firestore
        .collection('user')
        .doc(user.uid)
        .collection('history')
        .get();

    final viewedMessageIds = historySnapshot.docs.map((doc) => doc.id).toSet();

    final availableMessages = messagesSnapshot.docs
        .where(
          (doc) =>
              !viewedMessageIds.contains(doc.id) &&
              !doc.data().containsKey('senderId') &&
              !doc.data().containsKey('receiverId'),
        )
        .toList();

    if (availableMessages.isEmpty) return null;

    final random = Random();
    final selectedMessage =
        availableMessages[random.nextInt(availableMessages.length)];

    final viewedAt = DateTime.now();
    final randomHours = 7 + random.nextInt(6);
    final nextAvailableAt = viewedAt.add(Duration(hours: randomHours));

    await _firestore
        .collection('user')
        .doc(user.uid)
        .collection('history')
        .doc(selectedMessage.id)
        .set({
          'messageId': selectedMessage.id,
          'viewedAt': Timestamp.fromDate(viewedAt),
          'nextAvailableAt': Timestamp.fromDate(nextAvailableAt),
        });

    return {
      'messageId': selectedMessage.id,
      ...selectedMessage.data(),
      'viewedAt': viewedAt,
      'nextAvailableAt': nextAvailableAt,
    };
  }

  // ============================================================
  // GET LATEST HISTORY MESSAGE
  // ============================================================
  Future<Map<String, dynamic>?> getLatestHistoryMessage() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    try {
      final historySnapshot = await _firestore
          .collection('user')
          .doc(user.uid)
          .collection('history')
          .orderBy('viewedAt', descending: true)
          .limit(1)
          .get();

      if (historySnapshot.docs.isEmpty) return null;

      final historyDoc = historySnapshot.docs.first;
      final historyData = historyDoc.data();
      final messageId = historyDoc.id;

      final messageDoc = await _firestore
          .collection('messages')
          .doc(messageId)
          .get();
      if (!messageDoc.exists) return null;

      final messageData = messageDoc.data();
      if (messageData == null) return null;
      if (messageData.containsKey('senderId') ||
          messageData.containsKey('receiverId')) {
        return null;
      }

      final Timestamp? viewedAt = historyData['viewedAt'] is Timestamp
          ? historyData['viewedAt'] as Timestamp
          : null;

      final Timestamp? nextAvailableAt =
          historyData['nextAvailableAt'] is Timestamp
          ? historyData['nextAvailableAt'] as Timestamp
          : null;

      return {
        'messageId': messageId,
        ...messageData,
        'viewedAt': viewedAt,
        'nextAvailableAt': nextAvailableAt,
        'date': _formatDate(viewedAt),
        'time': _formatTime(viewedAt),
      };
    } catch (e) {
      print('Error getting latest history message: $e');
      return null;
    }
  }

  // ============================================================
  // GET RANDOM MESSAGE
  // ============================================================
  Future<Map<String, dynamic>?> getReminderMessage() async {
    final remindersSnapshot = await _firestore.collection('reminders').get();
    if (remindersSnapshot.docs.isEmpty) {
      return null;
    }
    final random = Random();
    final selectedDoc =
        remindersSnapshot.docs[random.nextInt(remindersSnapshot.docs.length)];
    final messageData = selectedDoc.data();
    return {...messageData};
  }
}
