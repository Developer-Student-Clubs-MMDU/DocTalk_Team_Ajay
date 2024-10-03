import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/conversation_model.dart';


class ConversationService {
  static final  _db = FirebaseFirestore.instance.collection('users').doc('Ajay');

  // Add a new conversation to Firestore
  static Future<void> addConversation(ConversationModel conversation) async {
    await _db.collection('conversations').doc(conversation.id).set(conversation.toJson());
  }

  // Retrieve a conversation by its ID
  static Future<ConversationModel?> getConversation(String id) async {
    DocumentSnapshot doc = await _db.collection('conversations').doc(id).get();

    if (doc.exists) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      return ConversationModel.fromJson(data);
    }

    return null;
  }

  // Update an existing conversation
  static Future<void> updateConversation(ConversationModel conversation) async {
                         conversation.lastMessageTimestamp=DateTime.now();
    await _db.collection('conversations').doc(conversation.id).update(conversation.toJson());
  }

  // Delete a conversation by its ID
  static Future<void> deleteConversation(String id) async {
    await _db.collection('conversations').doc(id).delete();
  }

  // Retrieve all conversations as a stream for real-time updates
  static Stream<List<ConversationModel>> getAllConversations() {
    return _db.collection('conversations').orderBy('lastMessageTimestamp', descending: true)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        return ConversationModel.fromJson(data);
      }).toList();
    });
  }
  // Retrieve messages in a conversation as a stream for real-time updates
  static Stream<List<MessageModel>> getMessagesInConversation(String conversationId) {
    return _db
        .collection('conversations')
        .doc(conversationId)
        .snapshots()
        .map((documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
        if (data.containsKey('messages')) {
          return (data['messages'] as List<dynamic>).map((messageData) {
            return MessageModel.fromJson(messageData as Map<String, dynamic>);
          }).toList();
        }
      }
      return [];
    });
  }
}
