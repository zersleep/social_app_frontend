import 'package:flutter/material.dart';

import 'story_item.dart';

class StorySection extends StatelessWidget {
  const StorySection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,

      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),

        children: const [

          StoryItem(
            image: 'assets/images/story1.jpg',
            username: 'ice_scream',
          ),

          StoryItem(
            image: 'assets/images/story2.jpg',
            username: 'cuifenn',
          ),

          StoryItem(
            image: 'assets/images/story3.jpg',
            username: '_.brainn',
          ),

          StoryItem(
            image: 'assets/images/story4.jpg',
            username: 'm.a.a.m',
          ),

          StoryItem(
            image: 'assets/images/story5.jpg',
            username: 'Lemon_juice',
          ),
        ],
      ),
    );
  }
}