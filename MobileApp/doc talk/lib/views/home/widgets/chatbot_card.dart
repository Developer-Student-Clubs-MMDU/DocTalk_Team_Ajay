import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:get/get.dart';
import '../../../data/models/conversation_model.dart';
import '../../chatbot/chatbot_page.dart';

class ChatbotCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Theme.of(context).cardColor, // Adapts to light/dark mode
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Chat with our Health Assistant!',
              style: Theme.of(context).textTheme.titleLarge, // Adaptable
            ),
            SizedBox(height: 8.0),
            Text(
              'Get instant medical advice and health insights.',
              style: Theme.of(context).textTheme.bodyLarge, // Adaptable
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Get.to(ChatScreen(
                    conversation: ConversationModel(
                        id: const Uuid().v1(),
                        title: "New Chat",
                        messages: [],
                        conversationStage: 'initial',
                        lastMessageTimestamp: DateTime.now())));
              },
              child: const Text('Start Chat'),
            ),
          ],
        ),
      ),
    );
  }
}
