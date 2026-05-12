import 'package:flutter/material.dart';

import '../../../shared/widgets/animated_nav_bar.dart';
import '../../chat/screens/chat_screen.dart';
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

  final List<Widget> pages = const [
    HomeScreen(),
    ReelsScreen(),
    SearchScreen(),
    ChatScreen(),
    ProfileScreen(),
  ];

  static const List<NavItem> _navItems = [
    NavItem(icon: Icons.home_rounded, label: 'Home'),
    NavItem(icon: Icons.movie_rounded, label: 'Reels'),
    NavItem(icon: Icons.search_rounded, label: 'Search'),
    NavItem(icon: Icons.chat_bubble_rounded, label: 'Chats'),
    NavItem(icon: Icons.person_rounded, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {

    final bool isReelsPage = currentIndex == 1;

    return Scaffold(
      extendBody: true,
      backgroundColor:
      isReelsPage
          ? Colors.black
          : Colors.white,

      body: pages[currentIndex],

      bottomNavigationBar: AnimatedNavBar(
        items: _navItems,
        selectedIndex: currentIndex,
        onChanged: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}
