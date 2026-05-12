import 'package:flutter/material.dart';

import '../mock_chats.dart';
import '../widgets/chat_app_bar.dart';
import '../widgets/chat_message_tile.dart';
import '../widgets/chat_search_bar.dart';
import '../widgets/chat_stories.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(child: ChatAppBar()),
            const SliverToBoxAdapter(child: ChatSearchBar()),
            SliverToBoxAdapter(
              child: ChatStoriesSection(stories: mockStories),
            ),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 14, 20, 6),
                child: Text(
                  'Messages',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                    letterSpacing: -0.3,
                  ),
                ),
              ),
            ),
            SliverList.builder(
              itemCount: mockMessages.length,
              itemBuilder: (context, index) {
                return ChatMessageTile(message: mockMessages[index]);
              },
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 12)),
          ],
        ),
      ),
    );
  }
}
