import 'dart:io';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../data/models/conversation.dart';
import '../data/models/conversation_model.dart';
import '../data/service/chatbotservice.dart';
import '../data/service/conversation_service.dart';
class ChatController extends GetxController {
  var uuid = Uuid();

  var conversations = <Conversation>[].obs;
  late Box<Conversation> conversationBox;
  Rx<ConversationModel> activeConversation =ConversationModel(id: '', title: 'New Chat', messages: [], conversationStage:'', lastMessageTimestamp: DateTime.now()).obs;

  @override
  void onInit() {
    super.onInit();
    // conversationBox = StorageService.conversationBox;
    // loadConversations();
  }

  // void loadConversations() {
  //   conversations.addAll(conversationBox.values);
  // }

  // void startNewConversation(String initialMessage) {
  //   var newConversation = Conversation(
  //     title: initialMessage,  // Use the first message as the title initially
  //     history: [ChatMessage(
  //       message: initialMessage,
  //       isUserMessage: true,
  //       timestamp: DateTime.now(),
  //     )],
  //     state: 'initial',
  //     lastUpdated: DateTime.now(),
  //   );
  //
  //   conversationBox.add(newConversation);
  //   conversations.add(newConversation);
  //   activeConversation = newConversation;
  //
  //   // Optionally, sync with Firebase
  //   // syncConversationToFirebase(newConversation);
  // }
  //
  // void continueConversation(Conversation conversation) {
  //   activeConversation = conversation;
  // }
  //
  // void addMessage(String message, bool isUserMessage) {
  //   if (activeConversation != null) {
  //     final newMessage = ChatMessage(
  //       message: message,
  //       isUserMessage: isUserMessage,
  //       timestamp: DateTime.now(),
  //     );
  //
  //     activeConversation!.history.add(newMessage);
  //     activeConversation!.lastUpdated = DateTime.now();
  //
  //     // Save updates to the local database
  //     conversationBox.putAt(conversations.indexOf(activeConversation!), activeConversation!);
  //     conversations.refresh();
  //
  //     // Sync with Firebase
  //     // syncMessageToFirebase(activeConversation!, newMessage);
  //   }
  // }
  //
  // void renameConversation(String newTitle) {
  //   if (activeConversation != null) {
  //     activeConversation!.title = newTitle;
  //     conversationBox.putAt(conversations.indexOf(activeConversation!), activeConversation!);
  //     conversations.refresh();
  //   }
  // }

  var conversationStage = 'initial'.obs;
  var messages = <Map<String, String>>[].obs;
  var uploadedImage = Rx<File?>(null);


  Future<void> handleUserInput(String userInput , RxBool isTyping, File? image) async {
    String prompt = "";
    String conversationHistory = messages.map((message) =>
    "User: ${message['isUserMessage'] == 'true' ? message['message'] : ''}\n"
        "Bot: ${message['isUserMessage'] == 'false' ? message['message'] : ''}"
    ).join("\n");
    // Check for greetings
    if (RegExp(r'^(hi|hello|hey|good morning|good afternoon|good evening)', caseSensitive: false).hasMatch(userInput.trim())) {
      prompt = """
      Hello! I am DocTalk, your medical assistant. How can I help you today? 
      Please describe your symptoms or upload an image if you need a visual diagnosis.
      """;
      Future.delayed(const Duration(seconds: 2));
      activeConversation.value.conversationStage = 'initial'; // Reset to initial stage for greetings
      activeConversation.value.messages.add(MessageModel(message: prompt, isUser: false, timestamp: DateTime.now()));
      activeConversation.refresh();
      ConversationService.updateConversation(activeConversation.value).then((value) => isTyping.value = false);

      return;
    }

    if (!RegExp(r"""^[a-zA-Z0-9\s.,!?\'\"-]+$""").hasMatch(userInput.trim())) {
      prompt = """
      It seems like you're not typing real words. Please describe your issue or ask a question related to your health so I can assist you better.
      """;
      activeConversation.value.messages.add(MessageModel(message: prompt, isUser: false, timestamp: DateTime.now()));
      activeConversation.refresh();
      ConversationService.updateConversation(activeConversation.value).then((value) =>   isTyping.value = false);
      return;
    }
    // Conversation stage logic
    if (conversationStage.value == 'initial') {
      prompt = """
      You are a medical chatbot. The user has described their initial symptoms or uploaded an image. 
      Ask 2-3 follow-up questions to gather more information. Focus on key symptoms, duration, severity, and any relevant medical history. 
      If an image is provided, analyze it for visual symptoms. Do not provide a diagnosis yet.
      
      Current conversation:
      $conversationHistory
      User: $userInput
      Bot:
      """;
      var res = await ChatbotService().sendChatbotRequest(prompt: prompt,imageFile: image);
      if(!res['bot_response'].toString().contains('Error generating response from AI model')){
        activeConversation.value.messages.add(MessageModel(message: res['bot_response'].replaceFirst("bot:", "").trim(), isUser: false, timestamp: DateTime.now()));
        activeConversation.refresh();
        conversationStage.value = 'follow_up';
        ConversationService.updateConversation(activeConversation.value);
      }else{
        print(res['bot_response']);
      }

    } else if (conversationStage.value == 'follow_up') {
      if (messages.length < 5) { // Continue asking follow-up questions
        prompt = """
        Based on the information provided so far, ask 1-2 more specific follow-up questions to clarify the user's condition. 
        If an image was provided, say that the image is not valid if the user
        provides any other image instead of the health related issues ,include questions about it. Do not provide a diagnosis yet.
        
        Current conversation:
        $conversationHistory
        User: $userInput
        Bot:
        """;
        var res = await ChatbotService().sendChatbotRequest(prompt: prompt,imageFile: image);
        if(!res['bot_response'].toString().contains('Error generating response from AI model')){
          activeConversation.value.messages.add(MessageModel(message: res['bot_response'].replaceFirst("bot:", "").trim(), isUser: false, timestamp: DateTime.now()));
          activeConversation.refresh();
          ConversationService.updateConversation(activeConversation.value);
        }
      } else { // Provide final response
        prompt = """
        You are a highly specialized medical chatbot. Based on the conversation history, symptoms described, and any images provided, 
        provide a detailed analysis of the most likely conditions, taking into account common and rare possibilities. 
        Suggest appropriate medical specialists for further consultation and provide specific treatment options, lifestyle changes, and potential risks.
        
        Current conversation:
        $conversationHistory
        User: $userInput
        Bot:
        """;
        conversationStage.value = 'final';
        var res = await ChatbotService().sendChatbotRequest(prompt: prompt,imageFile: image);
        if(!res['bot_response'].toString().contains('Error generating response from AI model')){
          activeConversation.value.messages.add(MessageModel(message: res['bot_response'].replaceFirst("bot:", "").trim(), isUser: false, timestamp: DateTime.now()));
          activeConversation.refresh();
          ConversationService.updateConversation(activeConversation.value);
        }else{
          print(res['bot_response']);
        }
      }
    }


  }


// Future<void> syncMessageToFirebase(Conversation conversation, ChatMessage message) async {
//   // Sync message to Firebase
//   final user = FirebaseAuth.instance.currentUser;
//   if (user != null) {
//     await FirebaseFirestore.instance
//         .collection('chats')
//         .doc(user.uid)
//         .collection('conversations')
//         .doc(conversation.title)
//         .collection('messages')
//         .add({
//       'message': message.message,
//       'isUserMessage': message.isUserMessage,
//       'timestamp': message.timestamp,
//     });
//   }
// }

// Future<void> syncConversationToFirebase(Conversation conversation) async {
//   // Sync entire conversation to Firebase
//   final user = FirebaseAuth.instance.currentUser;
//   if (user != null) {
//     await FirebaseFirestore.instance
//         .collection('chats')
//         .doc(user.uid)
//         .collection('conversations')
//         .doc(conversation.title)
//         .set({
//       'state': conversation.state,
//       'lastUpdated': conversation.lastUpdated,
//     });
//
//     for (var message in conversation.history) {
//       await syncMessageToFirebase(conversation, message);
//     }
//   }
// }

// Future<void> syncFromFirebase() async {
//   // Sync conversations from Firebase
//   final user = FirebaseAuth.instance.currentUser;
//   if (user != null) {
//     var querySnapshot = await FirebaseFirestore.instance
//         .collection('chats')
//         .doc(user.uid)
//         .collection('conversations')
//         .get();
//
//     for (var doc in querySnapshot.docs) {
//       var data = doc.data();
//       var conversationTitle = doc.id;
//       var state = data['state'];
//       var lastUpdated = (data['lastUpdated'] as Timestamp).toDate();
//
//       var conversation = Conversation(
//         title: conversationTitle,
//         history: [],  // Load messages later
//         state: state,
//         lastUpdated: lastUpdated,
//       );
//
//       var messagesSnapshot = await FirebaseFirestore.instance
//           .collection('chats')
//           .doc(user.uid)
//           .collection('conversations')
//           .doc(conversationTitle)
//           .collection('messages')
//           .get();
//
//       for (var messageDoc in messagesSnapshot.docs) {
//         var messageData = messageDoc.data();
//         ChatMessage message = ChatMessage(
//           message: messageData['message'],
//           isUserMessage: messageData['isUserMessage'],
//           timestamp: (messageData['timestamp'] as Timestamp).toDate(),
//         );
//         conversation.history.add(message);
//       }
//
//       // Add to local database if not already present
//       if (!conversationBox.values.contains(conversation)) {
//         conversationBox.add(conversation);
//         conversations.add(conversation);
//       }
//     }
//   }
// }



}
