import 'package:flutter/material.dart';

import '../models/chat_models.dart';

class ChatStoriesSection extends StatelessWidget {
  final List<ChatStory> stories;

  const ChatStoriesSection({
    super.key,
    required this.stories,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Text(
            'Stories',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Colors.black,
              letterSpacing: -0.3,
            ),
          ),
        ),
        SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: stories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              return _StoryAvatar(story: stories[index]);
            },
          ),
        ),
      ],
    );
  }
}

class _StoryAvatar extends StatelessWidget {
  final ChatStory story;

  const _StoryAvatar({required this.story});

  @override
  Widget build(BuildContext context) {
    const ringColor = Color(0xFF3B82F6);

    return SizedBox(
      width: 64,
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 62,
                height: 62,
                padding: const EdgeInsets.all(2.5),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: ringColor,
                ),
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.all(2),
                  child: ClipOval(
                    child: Image.asset(
                      story.avatar,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              if (story.isYourStory)
                Positioned(
                  right: -2,
                  bottom: -2,
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: ringColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            story.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
