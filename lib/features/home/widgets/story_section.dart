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

          /// YOUR STORY
          StoryItem(
            username: 'You',
            image: 'assets/images/story1.jpg',

            isCurrentUser: true,
            hasStory: false,
          ),

          /// USERS
          StoryItem(
            username: 'iko',
            image: 'assets/images/story2.jpg',
            hasStory: true,
          ),

          StoryItem(
            username: 'mara.s',
            hasStory: true,
          ),

          StoryItem(
            username: 'jules.h',
            image: 'assets/images/story3.jpg',
            hasStory: true,
          ),

          StoryItem(
            username: 'ona',
            hasStory: true,
          ),
        ],
      ),
    );
  }
}