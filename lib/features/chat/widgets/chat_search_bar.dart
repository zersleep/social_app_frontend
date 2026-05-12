import 'package:flutter/material.dart';

class ChatSearchBar extends StatelessWidget {
  const ChatSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 8),
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFEFF1F4),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Row(
          children: const [
            Icon(
              Icons.search,
              color: Color(0xFF8E939A),
              size: 22,
            ),
            SizedBox(width: 10),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  isCollapsed: true,
                  border: InputBorder.none,
                  hintText: 'Messages or people...',
                  hintStyle: TextStyle(
                    color: Color(0xFF8E939A),
                    fontSize: 15,
                  ),
                ),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
