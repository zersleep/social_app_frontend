import 'package:flutter/material.dart';

import '../widgets/reel_item.dart';

class ReelsScreen extends StatelessWidget {
  const ReelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.black,

      body: Container(

        color: Colors.black,

        child: PageView(
          scrollDirection: Axis.vertical,

          children: const [

            ReelItem(
              video: 'assets/videos/reel1.mp4',
              username: 'm.a.a.m.e',
              caption:
              'Lorem metus porttitor purus enim...',
              profileImage:
              'assets/images/story1.jpg',
            ),

            ReelItem(
              video: 'assets/videos/reel2.mp4',
              username: 'travel',
              caption:
              'Beautiful sunset vibes 🌅',
              profileImage:
              'assets/images/story2.jpg',
            ),

            ReelItem(
              video: 'assets/videos/reel3.mp4',
              username: 'football',
              caption:
              'Beach vibes ⚽',
              profileImage:
              'assets/images/story3.jpg',
            ),
          ],
        ),
      ),
    );
  }
}