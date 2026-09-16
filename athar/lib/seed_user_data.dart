
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> seedUserData() async {
  final firestore = FirebaseFirestore.instance;

  // ==========================================
  // USERS INITIAL DATA
  // ==========================================

  final usersData = [
    {
      'email': 'aabdalqader@staff.alqauds.edu',

      'favorites': [
        'msg_002',
        'msg_005',
        'msg_012',
        'msg_015',
      ],

      'history': [
        'msg_001',
        'msg_002',
        'msg_004',
        'msg_005',
        'msg_008',
        'msg_012',
      ],
    },

    {
      'email': 'alaa.alqader@student.alquds.edu',

      'favorites': [
        'msg_003',
        'msg_006',
        'msg_009',
        'msg_016',
      ],

      'history': [
        'msg_003',
        'msg_006',
        'msg_007',
        'msg_009',
        'msg_013',
        'msg_016',
      ],
    },

    {
      'email': 'eng.alaa.abdalqader@gmail.com',

      'favorites': [
        'msg_004',
        'msg_010',
        'msg_014',
        'msg_019',
      ],

      'history': [
        'msg_004',
        'msg_010',
        'msg_011',
        'msg_014',
        'msg_017',
        'msg_019',
      ],
    },
  ];

  // ==========================================
  // PROCESS EACH USER
  // ==========================================

  for (final userData in usersData) {
    final email = userData['email'] as String;

    // Find the existing user by email
    final userQuery = await firestore
        .collection('user')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    // User does not exist
    if (userQuery.docs.isEmpty) {
      print('❌ User not found: $email');
      continue;
    }

    // Existing user's document ID
    final userDoc = userQuery.docs.first;
    final userId = userDoc.id;

    print('');
    print('================================');
    print('👤 User: $email');
    print('🆔 User ID: $userId');
    print('================================');

    final batch = firestore.batch();

    // ==========================================
    // FAVORITES
    // ==========================================

    final favorites = userData['favorites'] as List<String>;

    for (final messageId in favorites) {
      final favoriteRef = firestore
          .collection('user')
          .doc(userId)
          .collection('favorites')
          .doc(messageId);

      batch.set(favoriteRef, {
        'messageId': messageId,
        'addedAt': FieldValue.serverTimestamp(),
      });
    }

    // ==========================================
    // HISTORY
    // ==========================================

    final history = userData['history'] as List<String>;

    for (final messageId in history) {
      final historyRef = firestore
          .collection('user')
          .doc(userId)
          .collection('history')
          .doc(messageId);

      batch.set(historyRef, {
        'messageId': messageId,
        'viewedAt': FieldValue.serverTimestamp(),
      });
    }

    // ==========================================
    // SAVE EVERYTHING
    // ==========================================

    await batch.commit();

    print('✅ Data added successfully for $email');
  }

  print('');
  print('================================');
  print('✅ USER SEED COMPLETED');
  print('================================');
}

