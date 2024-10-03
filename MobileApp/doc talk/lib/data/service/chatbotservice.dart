import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ChatbotService {
  final String apiUrl = 'https://aj3322.pythonanywhere.com/chatbot/';  // Replace with your actual endpoint

  // Method to send chatbot request with optional image
  Future<Map<String, dynamic>> sendChatbotRequest({
    required String prompt,
    File? imageFile, // Optional image file
  }) async {
    try {
      // Create the multipart request
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl),);
      print(prompt) ;
      // Add text prompt
      request.fields['prompt']= prompt;

      // If an image is provided, attach it to the request
      if (imageFile != null) {
        request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));
      }

      // Send the request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        print(response.statusCode);
        print(response.body);
        // Parse the JSON response
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Failed to get response from chatbot');
      }
    } catch (e) {
      print('Error sending chatbot request: $e');
      throw Exception('Failed to communicate with the chatbot');
    }
  }
}
