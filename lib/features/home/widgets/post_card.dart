import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {
  final String profileImage;
  final String username;
  final String postImage;
  final String caption;

  const PostCard({
    super.key,
    required this.profileImage,
    required this.username,
    required this.postImage,
    required this.caption,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        /// TOP USER INFO
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
          child: Row(
            children: [

              /// PROFILE IMAGE
              CircleAvatar(
                radius: 18,
                backgroundImage: AssetImage(profileImage),
              ),

              const SizedBox(width: 10),

              /// USERNAME
              Expanded(
                child: Text(
                  username,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),

              /// MORE BUTTON
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.more_horiz),
              ),
            ],
          ),
        ),

        /// POST IMAGE
        Image.asset(
          postImage,
          width: double.infinity,
          height: 350,
          fit: BoxFit.cover,
        ),

        /// ACTION BUTTONS
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
          child: Row(
            children: [

              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.favorite_border),
              ),

              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.chat_bubble_outline),
              ),

              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.send_outlined),
              ),

              const Spacer(),

              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.bookmark_border),
              ),
            ],
          ),
        ),

        /// LIKES
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "1.3k likes",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        const SizedBox(height: 4),

        /// CAPTION
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.black),
              children: [

                TextSpan(
                  text: "$username ",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                TextSpan(
                  text: caption,
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),
      ],
    );
  }
}