import 'package:doc_talk/views/home/home_page.dart';
import 'package:doc_talk/views/home/widgets/chatbot_card.dart';
import 'package:doc_talk/views/home/widgets/doctor_card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class BottomNavCard extends StatefulWidget {
  const BottomNavCard({super.key});

  @override
  State<BottomNavCard> createState() => _BottomNavCardState();
}

class _BottomNavCardState extends State<BottomNavCard> {
  int _selectedIndex = 0;
  List<Widget> options = <Widget>[
    HomePage(),
    ChatbotCard(),
    DoctorCard(),
    Text("page 4"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: options.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: GNav(
        gap: 8,
        backgroundColor: Colors.white,
        color: Colors.black,
        activeColor: Colors.white,
        padding: const EdgeInsets.all(15.0),
        tabMargin: const EdgeInsets.all(10.0),
        tabBackgroundColor: Colors.purpleAccent,
        duration: const Duration(milliseconds: 400),
        tabs: const [
          GButton(
            icon: Icons.home,
            text: "Home",
          ),
          GButton(
            icon: Icons.chat,
            text: "Chat",
          ),
          GButton(
            icon: Icons.search,
            text: "Doctor",
          ),
          GButton(
            icon: Icons.settings,
            text: "Settings",
          )
        ],
        selectedIndex: _selectedIndex,
        onTabChange: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
