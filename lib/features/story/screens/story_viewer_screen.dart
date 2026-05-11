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

  late PageController pageController;

  late int currentUserIndex;

  int currentStoryIndex = 0;

  Timer? timer;

  bool showHeart = false;

  bool isLiked = false;

  double progress = 0;

  double dragOffset = 0;

  double edgeOffset = 0;

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

    pageController = PageController(
      initialPage:
      widget.initialUserIndex,
    );

    widget.users[currentUserIndex]
        .viewed = true;

    _loadStory();
  }

  void _loadStory() async {

    timer?.cancel();

    videoController?.dispose();

    progress = 0;

    final story = currentStory;

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

            if (progress >= 1) {

              timer.cancel();

              _nextStory();
            }
          }
        },
      );

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

        pageController.nextPage(

          duration:
          const Duration(
              milliseconds: 300),

          curve:
          Curves.easeOutCubic,
        );

      } else {

        Navigator.pop(context);
      }
    }
  }

  void _previousStory() {

    if (currentStoryIndex > 0) {

      setState(() {
        currentStoryIndex--;
      });

      _loadStory();
    }

    else if (
    currentUserIndex == 0) {

      Navigator.pop(context);
    }

    else {

      pageController.previousPage(

        duration:
        const Duration(
            milliseconds: 300),

        curve:
        Curves.easeOutCubic,
      );
    }
  }

  void _pauseStory() {

    timer?.cancel();

    videoController?.pause();
  }

  void _resumeStory() {

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

    pageController.dispose();

    super.dispose();
  }

  Widget buildStoryPage(
      StoryUserModel user,
      int index,
      ) {

    final story =
    user.stories[currentStoryIndex];

    return Stack(
      children: [

        /// MEDIA
        SizedBox.expand(

          child:
          story.type ==
              StoryType.image

              ? Container(

            color: Colors.black,

            child: Center(
              child: Image.asset(

                story.media,

                fit: BoxFit.contain,

                width: double.infinity,
              ),
            ),
          )

              : videoController != null &&
              currentUserIndex == index &&
              videoController!
                  .value
                  .isInitialized

              ? Container(

            color: Colors.black,

            child: FittedBox(
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
            ),
          )

              : const Center(
            child:
            CircularProgressIndicator(),
          ),
        ),

        /// HEART
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

                color: Colors.redAccent,

                size: 110,
              ),
            ),
          ),
        ),

        /// TOP
        Positioned(
          top: 55,
          left: 16,
          right: 16,

          child: Column(
            children: [

              /// PROGRESS
              Row(
                children: List.generate(

                  user.stories.length,

                      (storyIndex) {

                    return Expanded(
                      child: Container(

                        margin:
                        const EdgeInsets
                            .symmetric(
                          horizontal: 2,
                        ),

                        height: 3,

                        decoration:
                        BoxDecoration(

                          color:
                          Colors.white24,

                          borderRadius:
                          BorderRadius
                              .circular(10),
                        ),

                        child:
                        FractionallySizedBox(

                          alignment:
                          Alignment.centerLeft,

                          widthFactor:

                          storyIndex <
                              currentStoryIndex

                              ? 1

                              : storyIndex ==
                              currentStoryIndex &&
                              currentUserIndex ==
                                  index

                              ? progress

                              : 0,

                          child: Container(

                            decoration:
                            BoxDecoration(

                              color:
                              Colors.white,

                              borderRadius:
                              BorderRadius
                                  .circular(
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

              /// USER
              Row(
                children: [

                  CircleAvatar(
                    radius: 16,

                    backgroundImage:
                    AssetImage(
                      user.profileImage,
                    ),
                  ),

                  const SizedBox(width: 8),

                  Text(
                    user.username,

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
                    story.time,

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

        /// BOTTOM
        Positioned(
          left: 16,
          right: 16,
          bottom: 40,

          child: Row(
            children: [

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
                        .circular(30),
                  ),

                  child: Text(
                    "Reply to ${user.username}...",

                    style:
                    const TextStyle(
                      color:
                      Colors.white70,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 14),

              GestureDetector(

                onTap: () {

                  setState(() {

                    isLiked = !isLiked;
                  });
                },

                child: AnimatedScale(

                  duration:
                  const Duration(
                      milliseconds: 180),

                  scale:
                  isLiked ? 1.15 : 1,

                  child: Icon(

                    isLiked

                        ? Icons.favorite

                        : Icons.favorite_border,

                    color:

                    isLiked

                        ? Colors.redAccent

                        : Colors.white,
                  ),
                ),
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
    );
  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(

      behavior:
      HitTestBehavior.translucent,

      /// EDGE CLOSE SWIPE
      onHorizontalDragUpdate: (details) {

        /// FIRST USER
        if (currentUserIndex == 0 &&
            details.delta.dx > 0) {

          setState(() {

            edgeOffset += details.delta.dx;
          });
        }

        /// LAST USER
        else if (
        currentUserIndex ==
            widget.users.length - 1 &&
            details.delta.dx < 0) {

          setState(() {

            edgeOffset += details.delta.dx;
          });
        }
      },

      onHorizontalDragEnd: (_) {

        /// FIRST USER CLOSE
        if (currentUserIndex == 0 &&
            edgeOffset > 60) {

          Navigator.pop(context);
        }

        /// LAST USER CLOSE
        else if (
        currentUserIndex ==
            widget.users.length - 1 &&
            edgeOffset < -60) {

          Navigator.pop(context);
        }

        setState(() {

          edgeOffset = 0;
        });
      },

      /// DRAG DOWN
      onVerticalDragUpdate: (details) {

        setState(() {

          dragOffset += details.delta.dy;

          if (dragOffset < 0) {
            dragOffset = 0;
          }
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

      /// HOLD
      onLongPressStart: (_) {

        _pauseStory();
      },

      onLongPressEnd: (_) {

        _resumeStory();
      },

      /// DOUBLE TAP
      onDoubleTap: () {

        setState(() {

          showHeart = true;

          isLiked = true;
        });

        Future.delayed(
          const Duration(milliseconds: 700),

              () {

            if (mounted) {

              setState(() {

                showHeart = false;
              });
            }
          },
        );
      },

      /// TAP
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

      child: AnimatedOpacity(

        duration:
        const Duration(milliseconds: 180),

        opacity:
        (1 - (dragOffset / 500))
            .clamp(0.7, 1),

        child: AnimatedScale(

          duration:
          const Duration(milliseconds: 180),

          scale:
          (1 - (dragOffset / 2000))
              .clamp(0.92, 1),

          child: AnimatedContainer(

            duration:
            const Duration(milliseconds: 180),

            transform:
            Matrix4.translationValues(
              edgeOffset,
              dragOffset,
              0,
            ),

            child: Scaffold(

              backgroundColor:
              Colors.black,

              body: PageView.builder(

                controller:
                pageController,

                physics:
                const ClampingScrollPhysics(),

                onPageChanged: (index) {

                  setState(() {

                    currentUserIndex =
                        index;

                    currentStoryIndex = 0;
                  });

                  widget.users[index]
                      .viewed = true;

                  _loadStory();
                },

                itemCount:
                widget.users.length,

                itemBuilder:
                    (context, index) {

                  return buildStoryPage(
                    widget.users[index],
                    index,
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}