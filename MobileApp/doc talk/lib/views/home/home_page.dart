import 'package:flutter/material.dart';
import 'widgets/chatbot_card.dart';
import 'widgets/doctor_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DocTalk Home'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16.0),
              Text(
                'Welcome to DocTalk!',
                style: Theme.of(context)
                    .textTheme
                    .displayLarge, // Adapts to light/dark mode
              ),
              const SizedBox(height: 24.0),
              // Chatbot Card
              ChatbotCard(),
              const SizedBox(height: 16.0),
              // Doctor Card
              DoctorCard(),
            ],
          ),
        ),
      ),
    );
  }
}
