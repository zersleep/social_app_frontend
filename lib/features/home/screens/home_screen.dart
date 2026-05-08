import 'package:flutter/material.dart';

import '../widgets/home_appbar.dart';
import '../widgets/post_card.dart';
import '../widgets/story_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [

            /// TOP BAR
            const HomeAppBar(),

            /// STORIES
            const StorySection(),

            /// POSTS
            const PostCard(
              profileImage: 'assets/images/story1.jpg',
              username: 'Marvel Universe',
              postImage: 'assets/images/post1.jpg',
              caption: 'Welcome to Loki season 2 🔥',
            ),

            const PostCard(
              profileImage: 'assets/images/story2.jpg',
              username: 'Old Structure',
              postImage: 'assets/images/post2.jpg',
              caption: 'Beautiful architecture 🏜️',
            ),

            const PostCard(
              profileImage: 'assets/images/story3.jpg',
              username: '_.brainn',
              postImage: 'assets/images/post3.jpg',
              caption: 'Beach vibes ⚽',
            ),
          ],
        ),
      ),
    );
  }
}