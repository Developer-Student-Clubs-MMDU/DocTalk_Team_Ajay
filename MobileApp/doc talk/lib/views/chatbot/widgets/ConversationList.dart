import 'package:doc_talk/controllers/chatController.dart';
import 'package:doc_talk/views/chatbot/chatbot_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/conversation_model.dart';
import '../../../data/service/conversation_service.dart';
import 'package:uuid/uuid.dart';

class ConversationList extends GetView<ChatController> {
  const ConversationList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('History'),actions: [
        IconButton(onPressed: (){ ConversationModel newConversation = ConversationModel(
    id: const Uuid().v1(),
    title: "New Chat",
    messages: [],
    conversationStage: 'initial',
    lastMessageTimestamp: DateTime.now());
    controller.activeConversation.value = newConversation;
    controller.activeConversation.refresh();
    }, icon: Icon(Icons.add))
      ],),
      body: Column(
        children: [
          StreamBuilder<List<ConversationModel>>(
            stream: ConversationService.getAllConversations(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                print(snapshot.error);
                return Center(
                    child:
                        Text('Error loading conversations ${snapshot.error}'));
              }
              final conversations = snapshot.data ?? [];
              return Expanded(
                child: ListView.builder(
                  itemCount: conversations.length,
                  itemBuilder: (context, index) {
                    final conversation = conversations[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Card(
                        child: ListTile(
                          title: Text(conversation.title),
                          onTap: () {
                            controller.activeConversation.value = conversation;
                            controller.activeConversation.refresh();
                            Get.back();
                          },
                          titleAlignment: ListTileTitleAlignment.center,
                          onLongPress: () {
                            Get.defaultDialog(
                                title: 'Delete',
                                content: Text('Sure you want to delete'),
                                actions: [
                                  TextButton.icon(
                                    onPressed: () {ConversationService.deleteConversation(conversation.id);},
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    label: const Text("Delete",style: TextStyle(color: Colors.white70),),
                                  ),
                                  TextButton.icon(
                                    onPressed: () {Get.back();},
                                    icon: const Icon(
                                      Icons.cancel,
                                      color: Colors.white38,
                                    ),
                                    label: const Text("Cancel",style: TextStyle(color: Colors.white70)),
                                  )
                                ]);
                          },
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
