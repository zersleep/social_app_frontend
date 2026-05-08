import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ReelItem extends StatefulWidget {
  final String video;
  final String username;
  final String caption;
  final String profileImage;

  const ReelItem({
    super.key,
    required this.video,
    required this.username,
    required this.caption,
    required this.profileImage,
  });

  @override
  State<ReelItem> createState() => _ReelItemState();
}

class _ReelItemState extends State<ReelItem> {
  late VideoPlayerController controller;

  @override
  void initState() {
    super.initState();

    controller = VideoPlayerController.asset(widget.video)
      ..initialize().then((_) {
        setState(() {});

        controller.play();
        controller.setLooping(true);
      });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,

      onTap: () {
        if (controller.value.isPlaying) {
          controller.pause();
        } else {
          controller.play();
        }

        setState(() {});
      },

      child: Stack(
        children: [

          /// VIDEO
          SizedBox.expand(
            child: controller.value.isInitialized
                ? FittedBox(
              fit: controller.value.aspectRatio > 1
                  ? BoxFit.contain
                  : BoxFit.cover,

              child: SizedBox(
                width: controller.value.size.width,
                height: controller.value.size.height,

                child: VideoPlayer(controller),
              ),
            )
                : const Center(
              child: CircularProgressIndicator(),
            ),
          ),

          /// PLAY ICON
          if (!controller.value.isPlaying)

            const Center(
              child: Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 80,
              ),
            ),

          /// DARK OVERLAY
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,

                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.4),
                ],
              ),
            ),
          ),

          /// TOP BAR
          Positioned(
            top: 50,
            left: 16,
            right: 16,

            child: Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,

              children: [

                /// LEFT ICON
                const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 28,
                ),

                /// CENTER TABS
                Row(
                  children: [

                    /// REELS
                    const Text(
                      "Reels",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(width: 16),

                    /// FRIENDS
                    Text(
                      "Friends",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),

                /// RIGHT ICON
                const Icon(
                  Icons.tune,
                  color: Colors.white,
                  size: 26,
                ),
              ],
            ),
          ),

          /// RIGHT ACTION BUTTONS
          Positioned(
            right: 10,
            bottom: 120,

            child: Column(
              children: [

                /// LIKE
                const Icon(
                  Icons.favorite_border,
                  color: Colors.white,
                  size: 30,
                ),

                const SizedBox(height: 4),

                const Text(
                  "5000",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),

                const SizedBox(height: 16),

                /// COMMENT
                const Icon(
                  Icons.chat_bubble_outline,
                  color: Colors.white,
                  size: 30,
                ),

                const SizedBox(height: 4),

                const Text(
                  "6000",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),

                const SizedBox(height: 16),

                /// REPOST
                const Icon(
                  Icons.repeat,
                  color: Colors.white,
                  size: 30,
                ),

                const SizedBox(height: 4),

                const Text(
                  "200",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),

                const SizedBox(height: 16),

                /// SHARE
                const Icon(
                  Icons.send,
                  color: Colors.white,
                  size: 30,
                ),

                const SizedBox(height: 4),

                const Text(
                  "7000",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),

                const SizedBox(height: 16),

                /// PROFILE
                CircleAvatar(
                  radius: 18,
                  backgroundImage:
                  AssetImage(widget.profileImage),
                ),
              ],
            ),
          ),

          /// BOTTOM INFO
          Positioned(
            left: 16,
            bottom: 40,
            right: 90,

            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                /// USER ROW
                Row(
                  children: [

                    CircleAvatar(
                      radius: 18,
                      backgroundImage:
                      AssetImage(widget.profileImage),
                    ),

                    const SizedBox(width: 10),

                    Text(
                      widget.username,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(width: 10),

                    /// FOLLOW BUTTON
                    Container(
                      padding:
                      const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),

                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white,
                        ),

                        borderRadius:
                        BorderRadius.circular(10),
                      ),

                      child: const Text(
                        "Follow",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                /// CAPTION
                Text(
                  widget.caption,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 14),

                /// MUSIC + FRIENDS
                Row(
                  children: [

                    /// MUSIC
                    Expanded(
                      child: Container(
                        padding:
                        const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),

                        decoration: BoxDecoration(
                          color: Colors.black45,

                          borderRadius:
                          BorderRadius.circular(30),
                        ),

                        child: const Row(
                          children: [

                            Icon(
                              Icons.music_note,
                              color: Colors.white,
                              size: 18,
                            ),

                            SizedBox(width: 6),

                            Expanded(
                              child: Text(
                                "Original audio...",
                                style: TextStyle(
                                  color: Colors.white,
                                ),

                                overflow:
                                TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    /// FRIENDS
                    Container(
                      padding:
                      const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),

                      decoration: BoxDecoration(
                        color: Colors.black45,

                        borderRadius:
                        BorderRadius.circular(30),
                      ),

                      child: const Row(
                        children: [

                          Icon(
                            Icons.group,
                            color: Colors.white,
                            size: 18,
                          ),

                          SizedBox(width: 6),

                          Text(
                            "55 users",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}