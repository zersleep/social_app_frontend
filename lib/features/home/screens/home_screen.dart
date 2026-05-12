import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../models/post_model.dart';
import '../widgets/home_appbar.dart';
import '../widgets/post_card.dart';
import '../widgets/story_section.dart';

// Mock data — replace with GetX controller call later.
const List<PostModel> _mockPosts = [
  PostModel(
    id:           'post_1',
    username:     'iko',
    profileImage: 'assets/images/story2.jpg',
    subtitle:     'Cap Ferret',
    images: [
      'assets/images/post1.jpg',
      'assets/images/post2.jpg',
      'assets/images/post3.jpg',
    ],
    caption:      'Drove the old coastal road. Three rolls of film, no plan, kept getting lost on purpose.',
    likeCount:    1284,
    commentCount: 3,
    timeAgo:      '2H AGO',
    hasStory:     true,
  ),
  PostModel(
    id:           'post_2',
    username:     'jules.h',
    profileImage: 'assets/images/story3.jpg',
    subtitle:     'Paris',
    images: [
      'assets/images/post4.jpg',
      'assets/images/post5.jpg',
    ],
    caption:      'Somewhere between coffee shops, old books, and rainy streets.',
    likeCount:    892,
    commentCount: 7,
    timeAgo:      '4H AGO',
    hasStory:     true,
  ),
  PostModel(
    id:           'post_3',
    username:     'lev.p',
    profileImage: 'assets/images/post5.jpg',
    subtitle:     'Tokyo',
    images: [
      'assets/images/post6.jpg',
      'assets/images/post7.jpg',
      'assets/images/post8.jpg',
    ],
    caption:      'Late nights, city lights, and quiet moments in between.',
    likeCount:    534,
    commentCount: 2,
    timeAgo:      '6H AGO',
    hasStory:     false,
  ),
];

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.feedBackground,
      body: SafeArea(
        child: ListView(
          children: [
            const HomeAppBar(),
            const StorySection(),
            const Divider(height: 1.2, thickness: 1.2, color: AppColors.divider),
            ..._mockPosts.map((post) => PostCard(post: post)),
          ],
        ),
      ),
    );
  }
}
