
import 'package:doc_talk/controllers/chatController.dart';
import 'package:doc_talk/views/UserView/profile.dart';
import 'package:doc_talk/views/chatbot/widgets/ConversationList.dart';
import 'package:doc_talk/views/chatbot/widgets/chat_input.dart';
import 'package:doc_talk/views/chatbot/widgets/message_bubble.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/conversation_model.dart';
import 'dart:io';
import '../../data/service/conversation_service.dart';
import '../../test.dart';
class ChatScreen extends StatelessWidget {
  ConversationModel conversation;
  ChatScreen({Key? key, required this.conversation,}) : super(key: key);
  ChatController controller = Get.put(ChatController());
  RxBool _isSomeoneTyping = false.obs;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    controller.activeConversation.value = conversation;
    File? imageFile;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(controller.activeConversation.value.title),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              _editChatTitle(context);
            },
          ),
          InkWell(onTap: (){ _scaffoldKey.currentState!.openEndDrawer();},child: const CircleAvatar(radius: 20,)),
          SizedBox(width: 10,)
        ],
      ),
      endDrawer: Drawer(child: UserView(),),

      drawer: const Drawer(child: ConversationList()),
      body: Column(
        children: [
         Obx(() =>  Expanded(
           child: StreamBuilder<List<MessageModel>>(
             stream: ConversationService.getMessagesInConversation(controller.activeConversation.value.id),
             builder: (context, snapshot) {
               if (snapshot.connectionState == ConnectionState.waiting) {
                 return Center(child: CircularProgressIndicator());
               }
               if (snapshot.hasError) {
                 return const Center(child: Text('Error loading Message'));
               }
               if(snapshot.data.isNull){
                 return Container();
               }
               final message = snapshot.data;
               return ListView.builder(
                 reverse: true,
                 padding: const EdgeInsets.all(16.0),
                 itemCount: snapshot.data?.length,
                 itemBuilder: (context, index) {
                   final message =snapshot.data![snapshot.data!.length - index - 1];
                   return Row(
                     mainAxisAlignment: message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                     children: [
                       SizedBox(
                         width: MediaQuery.sizeOf(context).width*0.75,
                         child: MessageBubble(
                           message: message.message,
                           isUserMessage: message.isUser,
                             isSomeoneTyping: _isSomeoneTyping,
                         ),
                       ),
                     ],
                   );
                 },
               );
             },
           ),
         )),
          Obx(() =>  TypingIndicator(
            showIndicator: _isSomeoneTyping.value,
          ),),
          ChatInput(
            onSend: (message) {
              _handleUserInput(message,imageFile);
            },
            onImageSend: (imageFile) {
              print("Image sent: ${imageFile.path}");
              imageFile=imageFile;
            },
          ),
        ],
      ),
    );
  }

  void _handleUserInput(String message,File? image){
    if(controller.activeConversation.value.messages.isEmpty){
      controller.activeConversation.value.messages.add(MessageModel(message: message, isUser: true, timestamp: DateTime.now()));
      _isSomeoneTyping.value = true;
      controller.handleUserInput(message,_isSomeoneTyping,image);
      ConversationService.addConversation(controller.activeConversation.value).then((value) => _isSomeoneTyping.value = false);
    }else{
      _isSomeoneTyping.value = true;
      controller.activeConversation.value.messages.add(MessageModel(message: message, isUser: true, timestamp: DateTime.now()));
      ConversationService.updateConversation(controller.activeConversation.value);
      controller.handleUserInput(message,_isSomeoneTyping,image).then((value) => _isSomeoneTyping.value = false);
    }
  }

  void _editChatTitle(BuildContext context) {
    TextEditingController titleController = TextEditingController(text: controller.activeConversation.value.title);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Chat Title'),
          content: TextField(
            controller: titleController,
            decoration: const InputDecoration(hintText: 'Enter new chat title'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                controller.activeConversation.value.title = titleController.text;
                ConversationService.updateConversation(controller.activeConversation.value);
                Get.back();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
