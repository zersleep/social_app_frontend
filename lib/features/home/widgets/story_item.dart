import 'package:flutter/material.dart';
import '../../story/screens/story_viewer_screen.dart';
import '../../story/story_data.dart';
import '../../story/screens/create_story_screen.dart';

class StoryItem extends StatelessWidget {

  final String username;
  final String? image;

  final bool hasStory;
  final bool isViewed;
  final bool isCurrentUser;

  const StoryItem({
    super.key,
    required this.username,
    this.image,
    this.hasStory = false,
    this.isCurrentUser = false,
    this.isViewed = false,
  });

  @override
  Widget build(BuildContext context) {

    final String firstLetter =
    username[0].toUpperCase();

    return GestureDetector(

      onTap: () {

        /// CURRENT USER
        if (isCurrentUser) {

          /// HAS STORY
          if (hasStory) {

            final int userIndex =
            storyUsers.indexWhere(

                  (user) =>
              user.username == username,
            );

            Navigator.push(
              context,

              MaterialPageRoute(
                builder: (_) =>
                    StoryViewerScreen(

                      users: storyUsers,

                      initialUserIndex:
                      userIndex == -1
                          ? 0
                          : userIndex,
                    ),
              ),
            );
          }

          /// NO STORY
          else {

            Navigator.push(
              context,

              MaterialPageRoute(
                builder: (_) =>
                const CreateStoryScreen(),
              ),
            );
          }
        }

        /// OTHER USERS
        else {

          final int userIndex =
          storyUsers.indexWhere(

                (user) =>
            user.username == username,
          );

          Navigator.push(
            context,

            MaterialPageRoute(
              builder: (_) =>
                  StoryViewerScreen(

                    users: storyUsers,

                    initialUserIndex:
                    userIndex == -1
                        ? 0
                        : userIndex,
                  ),
            ),
          );
        }
      },

      child: Padding(
        padding: const EdgeInsets.only(right: 12),

        child: Column(
          children: [

            /// STORY AVATAR
            Stack(
              children: [

                /// STORY RING
                Container(
                  padding: const EdgeInsets.all(3),

                  decoration: BoxDecoration(

                    shape: BoxShape.circle,

                    gradient: hasStory

                        ? LinearGradient(

                      colors:

                      isViewed

                          ? [
                        Colors.grey,
                        Colors.grey,
                      ]

                          : const [

                        Color(0xFFFF5F6D),

                        Color(0xFFFF9966),

                        Color(0xFFFFC371),
                      ],
                    )

                        : null,
                  ),

                  child: Container(
                    padding: const EdgeInsets.all(2),

                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),

                    child: CircleAvatar(
                      radius: 30,

                      backgroundColor:
                      const Color(0xFFD8B4A0),

                      backgroundImage:
                      image != null
                          ? AssetImage(image!)
                          : null,

                      child: image == null

                          ? Text(
                        firstLetter,

                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight:
                          FontWeight.w300,

                          fontStyle:
                          FontStyle.italic,
                        ),
                      )

                          : null,
                    ),
                  ),
                ),

                /// PLUS BUTTON
                if (isCurrentUser && !hasStory)

                  Positioned(
                    bottom: 2,
                    right: 2,

                    child: Container(
                      width: 24,
                      height: 24,

                      decoration: BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,

                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),

                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                          ),
                        ],
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

            /// USERNAME
            SizedBox(
              width: 72,

              child: Text(

                isCurrentUser
                    ? "Your story"
                    : username,

                textAlign: TextAlign.center,

                overflow: TextOverflow.ellipsis,

                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}