import 'package:hive/hive.dart';

part 'chat_message.g.dart';

@HiveType(typeId: 0)
class ChatMessage {
  @HiveField(0)
  final String message;
  @HiveField(1)
  final bool isUserMessage;
  @HiveField(2)
  final DateTime timestamp;

  ChatMessage({required this.message, required this.isUserMessage, required this.timestamp});
}
