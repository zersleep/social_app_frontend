import 'package:flutter/material.dart';

import '../widgets/home_appbar.dart';
import '../widgets/story_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [

            /// APPBAR
            const HomeAppBar(),

            /// STORIES
            const StorySection(),
          ],
        ),
      ),
    );
  }
}