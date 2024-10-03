import 'package:doc_talk/views/chatbot/widgets/markdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isUserMessage;
  final RxBool isSomeoneTyping;

  const MessageBubble(
      {required this.isSomeoneTyping,
      required this.message,
      required this.isUserMessage});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    return Align(
      alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: isUserMessage
            ? const EdgeInsets.all(12.0)
            : const EdgeInsets.all(0),
        decoration: BoxDecoration(
          color: isUserMessage
              ? Theme.of(context).primaryColor
              : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: isUserMessage
            ? Text(
                message,
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Markdown(
                    shrinkWrap: true,
                    styleSheet: MarkdownStyleSheet(
                        p: TextStyle(
                            color:
                                Theme.of(context).textTheme.bodyLarge?.color),
                        listBullet: TextStyle(
                            color:
                                Theme.of(context).textTheme.bodyLarge?.color)),
                    physics: const NeverScrollableScrollPhysics(),
                    data: message,
                  ),
                ],
              ),
      ),
    );
  }
}
