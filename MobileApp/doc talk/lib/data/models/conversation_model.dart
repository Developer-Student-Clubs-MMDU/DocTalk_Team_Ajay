import 'package:cloud_firestore/cloud_firestore.dart';

class ConversationModel {
  String id;
  String title;
  final List<MessageModel> messages;
  String conversationStage;
  DateTime lastMessageTimestamp;

  ConversationModel({
    required this.id,
    required this.title,
    required this.messages,
    required this.conversationStage,
    required this.lastMessageTimestamp
  });

  // Converts a Firestore document or map to a ConversationModel object
  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      messages: (json['messages'] as List<dynamic>)
          .map((message) => MessageModel.fromJson(message as Map<String, dynamic>))
          .toList(),
      conversationStage: json['conversationStage'] ?? '',
      lastMessageTimestamp: json['lastMessageTimestamp'].toDate()??DateTime.now()
    );
  }


  // Converts the ConversationModel object to a map that can be stored in Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id??'',
      'title': title??'',
      'messages': messages.map((message) => message.toJson()).toList()??[],
      'conversationStage': conversationStage??'',
      'lastMessageTimestamp':lastMessageTimestamp
    };
  }
}


class MessageModel {
  final String message;
  final bool isUser;
  final DateTime timestamp;

  MessageModel({
    required this.message,
    required this.isUser,
    required this.timestamp,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      message: json['message'],
      isUser: json['isUser']??true,
      timestamp: json['timestamp'].toDate()??DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'message': message,
        'isUser': isUser,
        'timestamp': timestamp,
      };
}
