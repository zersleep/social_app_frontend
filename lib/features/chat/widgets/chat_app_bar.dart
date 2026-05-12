import 'package:flutter/material.dart';

class ChatAppBar extends StatelessWidget {
  final String avatar;

  const ChatAppBar({
    super.key,
    this.avatar = 'assets/images/story3.jpg',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage(avatar),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Chats',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: Colors.black,
                letterSpacing: -0.5,
              ),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.photo_camera_outlined,
              color: Colors.black,
              size: 26,
            ),
            splashRadius: 22,
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.edit_square,
              color: Colors.black,
              size: 24,
            ),
            splashRadius: 22,
          ),
        ],
      ),
    );
  }
}
