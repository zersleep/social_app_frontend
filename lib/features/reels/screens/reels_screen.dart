import 'package:flutter/material.dart';

import '../widgets/reel_item.dart';

class ReelsScreen extends StatelessWidget {
  const ReelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: PageView(
        scrollDirection: Axis.vertical,

        children: const [

          ReelItem(
            video: 'assets/videos/reel1.mp4',
            username: 'm.a.a.m.e',
            caption:
            'Lorem metus porttitor purus enim...',
            profileImage:
            'assets/images/story4.jpg',
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
            username: 'unstoper',
            caption:
            'Beautiful sunset vibes 🌅',
            profileImage:
            'assets/images/story5.jpg',
          ),
        ],
      ),
    );
  }
}