import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

/// Downloads system messages from the remote JSON file
/// and synchronizes them with Firestore.
///
/// System messages are stored separately from user_messages.
class MessageSyncService {
  MessageSyncService({FirebaseFirestore? firestore, http.Client? client})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _client = client ?? http.Client();

  final FirebaseFirestore _firestore;
  final http.Client _client;

  // Replace this with the RAW GitHub URL of your messages.json file.
  static const String messagesUrl =
      'https://raw.githubusercontent.com/LoloAbd/Athar/refs/heads/main/messages.json';

  /// Downloads messages.json and creates/updates the documents
  /// in the Firestore "message" collection.
  ///
  /// Returns the number of synchronized messages.
  Future<int> syncMessages() async {
    final response = await _client.get(Uri.parse(messagesUrl));

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to download messages.json. '
        'HTTP status: ${response.statusCode}',
      );
    }

    final decoded = jsonDecode(response.body);

    if (decoded is! List) {
      throw const FormatException('messages.json must contain a JSON array.');
    }

    final messages = decoded.map<Map<String, dynamic>>((item) {
      if (item is! Map) {
        throw const FormatException('Every message must be a JSON object.');
      }

      return Map<String, dynamic>.from(item);
    }).toList();

    if (messages.isEmpty) {
      return 0;
    }

    final batch = _firestore.batch();
    final collection = _firestore.collection('messages');

    for (final message in messages) {
      final messageId = message['id'];

      if (messageId is! String || messageId.trim().isEmpty) {
        throw const FormatException(
          'Every message must have a non-empty string "id".',
        );
      }

      // The ID from JSON is also the Firestore Document ID.
      final document = collection.doc(messageId);

      batch.set(document, message);
    }

    await batch.commit();

    return messages.length;
  }

  void dispose() {
    _client.close();
  }
}
