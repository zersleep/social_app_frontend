import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../models/story_model.dart';
import '../models/story_user_model.dart';

class StoryViewerScreen extends StatefulWidget {

  final List<StoryUserModel> users;

  final int initialUserIndex;

  const StoryViewerScreen({
    super.key,
    required this.users,
    required this.initialUserIndex,
  });

  @override
  State<StoryViewerScreen> createState() =>
      _StoryViewerScreenState();
}

class _StoryViewerScreenState
    extends State<StoryViewerScreen> {

  late int currentUserIndex;

  int currentStoryIndex = 0;

  Timer? timer;

  bool isPaused = false;

  bool showHeart = false;

  double progress = 0;

  double dragOffset = 0;

  VideoPlayerController? videoController;

  StoryUserModel get currentUser =>
      widget.users[currentUserIndex];

  StoryModel get currentStory =>
      currentUser.stories[currentStoryIndex];

  @override
  void initState() {
    super.initState();

    currentUserIndex =
        widget.initialUserIndex;

    _loadStory();
  }

  void _loadStory() async {

    timer?.cancel();

    videoController?.dispose();

    final story = currentStory;
    progress = 0;

    if (story.type == StoryType.video) {

      videoController =
          VideoPlayerController.asset(
            story.media,
          );

      await videoController!
          .initialize();

      videoController!
        ..play()
        ..setLooping(false);

      setState(() {});

      timer = Timer.periodic(
        const Duration(milliseconds: 50),

            (timer) {

          if (!mounted ||
              videoController == null) {
            return;
          }

          final position =
              videoController!
                  .value
                  .position
                  .inMilliseconds;

          final duration =
              videoController!
                  .value
                  .duration
                  .inMilliseconds;

          if (duration > 0) {

            setState(() {

              progress =
                  position / duration;
            });
          }
        },
      );

      videoController!
          .addListener(() {

        if (videoController!
            .value.position >=
            videoController!
                .value.duration) {

          _nextStory();
        }
      });

    } else {

      timer = Timer.periodic(
        const Duration(milliseconds: 50),

            (timer) {

          if (!mounted) return;

          setState(() {

            progress += 0.01;
          });

          if (progress >= 1) {

            timer.cancel();

            _nextStory();
          }
        },
      );
    }
  }

  void _nextStory() {

    if (currentStoryIndex <
        currentUser.stories.length - 1) {

      setState(() {
        currentStoryIndex++;
      });

      _loadStory();

    } else {

      if (currentUserIndex <
          widget.users.length - 1) {

        setState(() {

          currentUserIndex++;

          currentStoryIndex = 0;
        });

        _loadStory();

      } else {

        timer?.cancel();

        videoController?.dispose();

        Future.microtask(() {

          if (mounted) {

            Navigator.of(context).pop();
          }
        });
      }
    }
  }

  void _previousStory() {

    if (currentStoryIndex > 0) {

      setState(() {
        currentStoryIndex--;
      });

      _loadStory();

    } else {

      if (currentUserIndex > 0) {

        setState(() {

          currentUserIndex--;

          currentStoryIndex =
              currentUser
                  .stories
                  .length - 1;
        });

        _loadStory();
      }
    }
  }

  void _pauseStory() {

    isPaused = true;

    timer?.cancel();

    videoController?.pause();
  }

  void _resumeStory() {

    isPaused = false;

    if (currentStory.type ==
        StoryType.image) {

      timer = Timer.periodic(
        const Duration(milliseconds: 50),

            (timer) {

          if (!mounted) return;

          setState(() {

            progress += 0.01;
          });

          if (progress >= 1) {

            timer.cancel();

            _nextStory();
          }
        },
      );

    } else {

      videoController?.play();

      timer = Timer.periodic(
        const Duration(milliseconds: 50),

            (timer) {

          if (!mounted ||
              videoController == null) {
            return;
          }

          final position =
              videoController!
                  .value
                  .position
                  .inMilliseconds;

          final duration =
              videoController!
                  .value
                  .duration
                  .inMilliseconds;

          if (duration > 0) {

            setState(() {

              progress =
                  position / duration;
            });
          }
        },
      );
    }
  }

  @override
  void dispose() {

    timer?.cancel();

    videoController?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(

      onHorizontalDragEnd: (details) {

        if (details.primaryVelocity == null) {
          return;
        }

        /// SWIPE LEFT
        if (details.primaryVelocity! < 0) {

          if (currentStoryIndex <
              currentUser.stories.length - 1) {

            _nextStory();

          } else {

            if (currentUserIndex <
                widget.users.length - 1) {

              setState(() {

                currentUserIndex++;

                currentStoryIndex = 0;
              });

              _loadStory();
            }
          }
        }

        /// SWIPE RIGHT
        else if (details.primaryVelocity! > 0) {

          if (currentStoryIndex > 0) {

            _previousStory();

          } else {

            if (currentUserIndex > 0) {

              setState(() {

                currentUserIndex--;

                currentStoryIndex =
                    currentUser
                        .stories
                        .length - 1;
              });

              _loadStory();
            }
          }
        }
      },

      onVerticalDragUpdate: (details) {

        setState(() {

          dragOffset += details.delta.dy;
        });
      },

      onVerticalDragEnd: (_) {

        if (dragOffset > 120) {

          Navigator.pop(context);

        } else {

          setState(() {

            dragOffset = 0;
          });
        }
      },

      onLongPressStart: (_) {

        _pauseStory();
      },

      onLongPressEnd: (_) {

        _resumeStory();
      },

      onDoubleTap: () {

        setState(() {
          showHeart = true;
        });

        Future.delayed(
          const Duration(
              milliseconds: 700),

              () {

            if (mounted) {

              setState(() {
                showHeart = false;
              });
            }
          },
        );
      },

      child: GestureDetector(

        behavior:
          HitTestBehavior.translucent,

          onTapUp: (details) {

            final width =
                MediaQuery.of(context)
                    .size
                    .width;

            final dx =
                details.globalPosition.dx;

            if (dx < width / 2) {

              _previousStory();

            } else {

              _nextStory();
            }
          },

          child: Transform.translate(

            offset: Offset(0, dragOffset),

            child: Scaffold(

            backgroundColor: Colors.black,

            body: Stack(
              children: [

                /// STORY MEDIA
                SizedBox.expand(
                  child:

                  currentStory.type ==
                      StoryType.image

                      ? Container(

                    color: Colors.black,

                    child: Center(
                      child: Image.asset(

                        currentStory.media,

                        fit: BoxFit.contain,

                        width: double.infinity,
                      ),
                    ),
                  )

                      : videoController != null &&
                      videoController!
                          .value
                          .isInitialized

                      ? FittedBox(
                    fit: BoxFit.contain,

                    child: SizedBox(
                      width:
                      videoController!
                          .value
                          .size
                          .width,

                      height:
                      videoController!
                          .value
                          .size
                          .height,

                      child: VideoPlayer(
                        videoController!,
                      ),
                    ),
                  )

                      : const Center(
                    child:
                    CircularProgressIndicator(),
                  ),
                ),

                /// HEART ANIMATION
                Center(
                  child: AnimatedOpacity(

                    opacity:
                    showHeart ? 1 : 0,

                    duration:
                    const Duration(
                      milliseconds: 250,
                    ),

                    child: AnimatedScale(

                      scale:
                      showHeart ? 1 : 0.5,

                      duration:
                      const Duration(
                        milliseconds: 250,
                      ),

                      child: const Icon(
                        Icons.favorite,

                        color: Colors.white,

                        size: 110,
                      ),
                    ),
                  ),
                ),

                /// TOP UI
                Positioned(
                  top: 55,
                  left: 16,
                  right: 16,

                  child: Column(
                    children: [

                      /// ANIMATED PROGRESS
                      Row(
                        children: List.generate(

                          currentUser.stories.length,

                              (index) {

                            return Expanded(
                              child: Container(

                                margin:
                                const EdgeInsets.symmetric(
                                  horizontal: 2,
                                ),

                                height: 3,

                                decoration: BoxDecoration(

                                  color: Colors.white24,

                                  borderRadius:
                                  BorderRadius.circular(
                                      10),
                                ),

                                child: FractionallySizedBox(

                                  alignment:
                                  Alignment.centerLeft,

                                  widthFactor:

                                  index < currentStoryIndex

                                      ? 1

                                      : index ==
                                      currentStoryIndex

                                      ? progress

                                      : 0,

                                  child: Container(

                                    decoration: BoxDecoration(

                                      color: Colors.white,

                                      borderRadius:
                                      BorderRadius.circular(
                                          10),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 14),

                      /// USER INFO
                      Row(
                        children: [

                          CircleAvatar(
                            radius: 16,

                            backgroundImage:
                            AssetImage(
                              currentUser
                                  .profileImage,
                            ),
                          ),

                          const SizedBox(width: 8),

                          Text(
                            currentUser.username,

                            style:
                            const TextStyle(
                              color:
                              Colors.white,

                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),

                          const SizedBox(width: 6),

                          Text(
                            currentStory.time,

                            style:
                            const TextStyle(
                              color:
                              Colors.white70,
                            ),
                          ),

                          const Spacer(),

                          GestureDetector(

                            onTap: () {
                              Navigator.pop(
                                  context);
                            },

                            child: const Icon(
                              Icons.close,

                              color:
                              Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                /// BOTTOM UI
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 40,

                  child: Row(
                    children: [

                      /// REPLY FIELD
                      Expanded(
                        child: Container(

                          padding:
                          const EdgeInsets
                              .symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),

                          decoration:
                          BoxDecoration(

                            border:
                            Border.all(
                              color:
                              Colors.white38,
                            ),

                            borderRadius:
                            BorderRadius
                                .circular(
                                30),
                          ),

                          child: Text(
                            "Reply to ${currentUser.username}...",

                            style:
                            const TextStyle(
                              color:
                              Colors.white70,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 14),

                      const Icon(
                        Icons.favorite_border,

                        color: Colors.white,
                      ),

                      const SizedBox(width: 18),

                      const Icon(
                        Icons.send_rounded,

                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}