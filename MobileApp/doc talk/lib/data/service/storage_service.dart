import 'package:doc_talk/data/models/conversation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;


class StorageService {
  static late Box<Conversation> _conversationBox;
  static Future<void> init() async {
    final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
    Hive.registerAdapter(ConversationAdapter());
    _conversationBox = await Hive.openBox<Conversation>('conversationBox');
  }
  static Box<Conversation> get conversationBox => _conversationBox;
}
