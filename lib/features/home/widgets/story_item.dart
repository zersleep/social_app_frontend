import 'package:flutter/material.dart';

import '../../../shared/widgets/story_avatar.dart';
import '../../story/screens/create_story_screen.dart';
import '../../story/screens/story_viewer_screen.dart';
import '../../story/story_data.dart';

class StoryItem extends StatelessWidget {
  final String  username;
  final String? image;
  final bool    hasStory;
  final bool    isViewed;
  final bool    isCurrentUser;

  const StoryItem({
    super.key,
    required this.username,
    this.image,
    this.hasStory      = false,
    this.isCurrentUser = false,
    this.isViewed      = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _handleTap(context),
      child: Padding(
        padding: const EdgeInsets.only(right: 12),
        child: Column(
          children: [
            StoryAvatar(
              imagePath:    image,
              username:     username,
              radius:       30,
              hasRing:      hasStory,
              isViewed:     isViewed,
              showAddBadge: isCurrentUser && !hasStory,
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: 72,
              child: Text(
                isCurrentUser ? 'Your story' : username,
                textAlign: TextAlign.center,
                overflow:  TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize:   12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleTap(BuildContext context) {
    if (isCurrentUser) {
      if (hasStory) {
        _openViewer(context);
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CreateStoryScreen()),
        );
      }
    } else {
      _openViewer(context);
    }
  }

  void _openViewer(BuildContext context) {
    final int idx = storyUsers.indexWhere((u) => u.username == username);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StoryViewerScreen(
          users:            storyUsers,
          initialUserIndex: idx == -1 ? 0 : idx,
        ),
      ),
    );
  }
}
