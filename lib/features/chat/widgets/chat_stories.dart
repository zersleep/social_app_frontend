import 'package:flutter/material.dart';

import '../../../features/story/screens/create_story_screen.dart';
import '../../../features/story/screens/story_viewer_screen.dart';
import '../../../features/story/story_model.dart';
import '../../../features/story/story_user_model.dart';
import '../../../shared/widgets/story_avatar.dart';
import '../chat_models.dart';

class ChatStoriesSection extends StatelessWidget {
  final List<ChatStory> stories;

  const ChatStoriesSection({
    super.key,
    required this.stories,
  });

  @override
  Widget build(BuildContext context) {
    final viewable   = stories.where((s) => !s.isYourStory).toList();
    final userModels = viewable
        .map((s) => StoryUserModel(
              username:     s.name,
              profileImage: s.avatar,
              stories: [StoryModel(type: StoryType.image, media: s.avatar, time: 'now')],
            ))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Text(
            'Stories',
            style: TextStyle(
              fontSize:      20,
              fontWeight:    FontWeight.w800,
              color:         Colors.black,
              letterSpacing: -0.3,
            ),
          ),
        ),
        SizedBox(
          height: 110,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding:         const EdgeInsets.symmetric(horizontal: 16),
            itemCount:       stories.length,
            itemBuilder: (context, index) {
              final story = stories[index];
              return GestureDetector(
                onTap: () {
                  if (story.isYourStory) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CreateStoryScreen()),
                    );
                  } else {
                    final idx = viewable.indexWhere((s) => s.name == story.name);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => StoryViewerScreen(
                          users:            userModels,
                          initialUserIndex: idx == -1 ? 0 : idx,
                        ),
                      ),
                    );
                  }
                },
                child: _ChatStoryItem(story: story),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ─── Private item widget ──────────────────────────────────────────────────────

class _ChatStoryItem extends StatelessWidget {
  final ChatStory story;
  const _ChatStoryItem({required this.story});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          StoryAvatar(
            imagePath:    story.avatar,
            username:     story.name,
            radius:       30,
            hasRing:      !story.isYourStory,
            showAddBadge: story.isYourStory,
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 72,
            child: Text(
              story.isYourStory ? 'Your story' : story.name,
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
    );
  }
}
