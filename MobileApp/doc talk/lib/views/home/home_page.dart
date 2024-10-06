import 'package:flutter/material.dart';
import 'widgets/chatbot_card.dart';
import 'widgets/doctor_card.dart';
import './widgets/bottomNav.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: const Text('DocTalk Home'),
        title: const Row(
          children: [
            SizedBox(width: 5),
            CircleAvatar(
              backgroundImage: AssetImage("assets/logo.jpg"),
            ),
            SizedBox(width: 5),
            Text('DocTalk Home'),
          ],
        ),

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
              const SizedBox(height: 16.0),
              Image.asset("assets/doctalk1.jpeg"),
              const SizedBox(height: 16.0),
              const Text(
                "Articles >",
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                height: 180,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(14)),
                  child: ListView(
                    // This next line does the trick.
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(14)),
                        child: Container(
                          width: 100,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(width: 10),
                      ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(14)),
                        child: Container(
                          width: 100,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(width: 10),
                      ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(14)),
                        child: Container(
                          width: 100,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(width: 10),
                      ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(14)),
                        child: Container(
                          width: 100,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(width: 10),
                      ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(14)),
                        child: Container(
                          width: 100,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(width: 10),
                      ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(14)),
                        child: Container(
                          width: 100,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                ),
              ),
              const Text(
                "Medical Journels >",
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                height: 180,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(14)),
                  child: ListView(
                    // This next line does the trick.
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(14)),
                        child: Container(
                          width: 100,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(width: 10),
                      ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(14)),
                        child: Container(
                          width: 100,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(width: 10),
                      ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(14)),
                        child: Container(
                          width: 100,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(width: 10),
                      ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(14)),
                        child: Container(
                          width: 100,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(width: 10),
                      ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(14)),
                        child: Container(
                          width: 100,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(width: 10),
                      ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(14)),
                        child: Container(
                          width: 100,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
