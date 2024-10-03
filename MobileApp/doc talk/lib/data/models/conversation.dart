import 'package:hive/hive.dart';
import 'chat_message.dart';

part 'conversation.g.dart';

@HiveType(typeId: 1)
class Conversation {
  @HiveField(0)
  String title;
  @HiveField(1)
  List<ChatMessage> history;
  @HiveField(2)
  String state;  // initial, follow-up, final
  @HiveField(3)
  DateTime lastUpdated;

  Conversation({
    required this.title,
    required this.history,
    required this.state,
    required this.lastUpdated,
  });
}
