import 'dart:io';
import 'package:doc_talk/data/models/conversation.dart';
import 'package:get/get.dart';

class ChatbotController extends GetxController {
  var conversationStage = 'initial'.obs;
  var messages = <Map<String, String>>[].obs;
  var uploadedImage = Rx<File?>(null);
  Rx<Conversation>? conversation;

  void addMessage(String message, {bool isUserMessage = true}) {
    messages.add({
      'message': message,
      'isUserMessage': isUserMessage.toString(),
    });
  }

  void handleUserInput(String userInput, File? image, Conversation conversation) {
    String prompt = "";
    String conversationHistory = messages.map((message) =>
    "User: ${message['isUserMessage'] == 'true' ? message['message'] : ''}\n"
        "Bot: ${message['isUserMessage'] == 'false' ? message['message'] : ''}"
    ).join("\n");

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
      conversationStage.value = 'follow_up';
      
    } else if (conversationStage.value == 'follow_up') {
      if (messages.length < 5) { // Continue asking follow-up questions
        prompt = """
        Based on the information provided so far, ask 1-2 more specific follow-up questions to clarify the user's condition. 
        If an image was provided, include questions about it. Do not provide a diagnosis yet.
        
        Current conversation:
        $conversationHistory
        User: $userInput
        Bot:
        """;
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
      }
    }

    // Simulate a chatbot response based on the prompt
    Future.delayed(const Duration(seconds: 2), () {
      String botResponse = _getBotResponse(prompt);  // This should simulate or call a chatbot model API
      addMessage(botResponse, isUserMessage: false);

      // In the final stage, suggest doctors
      if (conversationStage.value == 'final') {
        _suggestDoctors(botResponse);
      }
    });
  }

  String _getBotResponse(String prompt) {
    // Simulated chatbot response
    if (conversationStage.value == 'initial') {
      return "Please describe the duration and severity of your symptoms.";
    } else if (conversationStage.value == 'follow_up') {
      return "Have you experienced any other related symptoms?";
    } else {
      return "Based on your symptoms, it could be X or Y. I recommend consulting a general physician or specialist.";
    }
  }

  void _suggestDoctors(String responseText) {
    // Simulate doctor suggestions based on the bot's response
    List<String> possibleSpecialties = ["General Physician", "Dermatologist", "Cardiologist"];
    List<String> recommendedDoctors = [];

    for (var specialty in possibleSpecialties) {
      if (responseText.toLowerCase().contains(specialty.toLowerCase())) {
        recommendedDoctors.add("$specialty - Dr. Smith");
      }
    }

    if (recommendedDoctors.isNotEmpty) {
      addMessage("Recommended doctors based on your symptoms:\n${recommendedDoctors.join("\n")}", isUserMessage: false);
    } else {
      addMessage("No specific doctor suggestions based on the symptoms provided.", isUserMessage: false);
    }
  }
}
