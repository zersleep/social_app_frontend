import 'package:flutter/material.dart';

import '../../placeholder/chat_screen.dart';
import '../../placeholder/profile_screen.dart';
import '../../placeholder/search_screen.dart';
import '../../reels/screens/reels_screen.dart';
import 'home_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() =>
      _MainNavigationScreenState();
}

class _MainNavigationScreenState
    extends State<MainNavigationScreen> {

  int currentIndex = 0;

  final List<Widget> pages = [

    /// HOME
    const HomeScreen(),

    /// REELS
    const ReelsScreen(),

    /// SEARCH
    const SearchScreen(),

    /// CHAT
    const ChatScreen(),

    /// PROFILE
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {

    final bool isReelsPage = currentIndex == 1;

    return Scaffold(

      backgroundColor:
      isReelsPage
          ? Colors.black
          : Colors.white,

      body: pages[currentIndex],

      bottomNavigationBar: BottomNavigationBar(

        currentIndex: currentIndex,

        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },

        type: BottomNavigationBarType.fixed,

        elevation: 0,

        backgroundColor:
        isReelsPage
            ? Colors.black
            : Colors.white,

        selectedItemColor:
        isReelsPage
            ? Colors.white
            : Colors.black,

        unselectedItemColor:
        isReelsPage
            ? Colors.white70
            : Colors.black54,

        showSelectedLabels: false,
        showUnselectedLabels: false,

        items: const [

          /// HOME
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: '',
          ),

          /// REELS
          BottomNavigationBarItem(
            icon: Icon(Icons.video_library_outlined),
            label: '',
          ),

          /// SEARCH
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: '',
          ),

          /// CHAT
          BottomNavigationBarItem(
            icon: Icon(Icons.send_outlined),
            label: '',
          ),

          /// PROFILE
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: '',
          ),
        ],
      ),
    );
  }
}