import 'package:flutter/material.dart';

class StoryItem extends StatelessWidget {
  final String image;
  final String username;

  const StoryItem({
    super.key,
    required this.image,
    required this.username,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(

      onTap: () {

        /// open story later

      },

      child: Padding(
        padding: const EdgeInsets.only(right: 12),
        child: Column(
          children: [

            /// STORY IMAGE
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [
                    Colors.pink,
                    Colors.purple,
                  ],
                ),
              ),
              child: CircleAvatar(
                radius: 34,
                backgroundImage: AssetImage(image),
              ),
            ),

            const SizedBox(height: 6),

            /// USERNAME
            Text(
              username,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}