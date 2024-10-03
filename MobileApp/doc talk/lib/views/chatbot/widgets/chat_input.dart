import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ChatInput extends StatefulWidget {
  final Function(String) onSend;
  final Function(File) onImageSend; // Add a callback to send the image file

  ChatInput({required this.onSend, required this.onImageSend});

  @override
  _ChatInputState createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final TextEditingController _controller = TextEditingController();
  final ImagePicker _picker = ImagePicker(); // Initialize the ImagePicker

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;
    widget.onSend(_controller.text.trim());
    _controller.clear();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery); // Pick an image from the gallery
    if (image != null) {
      File imageFile = File(image.path); // Convert XFile to File
      widget.onImageSend(imageFile); // Call the onImageSend callback to send the image file
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
              ),
              margin: EdgeInsets.all(5),
              clipBehavior: Clip.hardEdge,
              child: TextField(
                autocorrect: true,
                controller: _controller,
                minLines: 1,
                maxLines: null,
                decoration: InputDecoration(
                  prefixIcon: IconButton(
                    onPressed: _pickImage, // Call the _pickImage method when icon is pressed
                    icon: const Icon(Icons.image_outlined),
                  ),
                  hintText: 'Type your message...',
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                  constraints: const BoxConstraints(maxHeight: 180),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send, size: 30),
            onPressed: _sendMessage,
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }
}
