import 'package:flutter/material.dart';

import '../widgets/home_appbar.dart';
import '../widgets/post_card.dart';
import '../widgets/story_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor:
      const Color(0xFFFFFBF7),

      body: SafeArea(
        child: ListView(
          children: [

            /// TOP BAR
            const HomeAppBar(),

            /// STORIES
            const StorySection(),

            Container(
              width: double.infinity,
              height: 1.2,

              color: const Color(
                0xFFE5E5E5,
              ),
            ),

            /// POSTS
            const PostCard(

              profileImage:
              'assets/images/story2.jpg',

              username: 'iko',

              subtitle: 'Cap Ferret',

              hasStory: true,

              postImages: [

                'assets/images/post1.jpg',
                'assets/images/post2.jpg',
                'assets/images/post3.jpg',
              ],

              caption:
              'Drove the old coastal road. Three rolls of film, no plan, kept getting lost on purpose.',
            ),

            const PostCard(

              profileImage:
              'assets/images/story3.jpg',

              username: 'jules.h',

              subtitle: 'Paris',

              hasStory: true,

              postImages: [

                'assets/images/post4.jpg',
                'assets/images/post5.jpg',
              ],

              caption:
              'Somewhere between coffee shops, old books, and rainy streets.',
            ),

            const PostCard(

              profileImage:
              'assets/images/post5.jpg',

              username: 'lev.p',

              subtitle: 'Tokyo',

              hasStory: false,

              postImages: [

                'assets/images/post6.jpg',
                'assets/images/post7.jpg',
                'assets/images/post8.jpg',
              ],

              caption:
              'Late nights, city lights, and quiet moments in between.',
            ),
          ],
        ),
      ),
    );
  }
}