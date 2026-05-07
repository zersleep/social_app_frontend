import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          /// LOGO TEXT
          const Text(
            "Social",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          /// RIGHT ICONS
          Row(
            children: [

              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.favorite_border),
              ),

              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.chat_bubble_outline),
              ),
            ],
          ),
        ],
      ),
    );
  }
}