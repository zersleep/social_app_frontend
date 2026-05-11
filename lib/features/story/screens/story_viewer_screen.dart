import 'dart:async';
import 'dart:ui';

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

  final Map<String, bool>
  likedStories = {};

  double progress = 0;

  double dragOffset = 0;

  double edgeOffset = 0;

  VideoPlayerController? videoController;

  final TextEditingController
  messageController =
  TextEditingController();

  List<String> sentMessages = [];

  String? latestMessage;

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
              milliseconds: 320),

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

    } else if (
    currentUserIndex == 0) {

      Navigator.pop(context);

    } else {

      pageController.previousPage(

        duration:
        const Duration(
            milliseconds: 320),

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

    messageController.dispose();

    super.dispose();
  }

  Widget buildShareUser(
      String username) {

    return Container(

      margin:
      const EdgeInsets.only(
        bottom: 12,
      ),

      padding:
      const EdgeInsets.all(14),

      decoration: BoxDecoration(

        color:
        Colors.white.withValues(
          alpha: 0.08,
        ),

        borderRadius:
        BorderRadius.circular(18),
      ),

      child: Row(
        children: [

          CircleAvatar(
            radius: 22,

            backgroundColor:
            Colors.white24,

            child: Text(
              username[0]
                  .toUpperCase(),

              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Text(
              username,

              style: const TextStyle(
                color: Colors.white,

                fontSize: 16,

                fontWeight:
                FontWeight.w600,
              ),
            ),
          ),

          Container(

            padding:
            const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 8,
            ),

            decoration: BoxDecoration(

              color: Colors.white,

              borderRadius:
              BorderRadius.circular(14),
            ),

            child: const Text(
              "Send",

              style: TextStyle(
                color: Colors.black,
                fontWeight:
                FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
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
        Positioned.fill(

          top: 70,

          bottom: 8,

          child:

          story.type ==
              StoryType.image

              ? Container(

            color: Colors.black,

            child: ClipRRect(

              borderRadius:
              BorderRadius.circular(18),

              child: Image.asset(

                story.media,

                fit: BoxFit.cover,

                width: double.infinity,

                height: double.infinity,
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

            child: ClipRRect(

              borderRadius:
              BorderRadius.circular(18),

              child: SizedBox.expand(

                child: FittedBox(

                  fit: BoxFit.cover,

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
              ),
            ),
          )

              : const Center(
            child:
            CircularProgressIndicator(),
          ),
        ),

        /// HEART BURST
        Center(
          child: IgnorePointer(

            child: AnimatedOpacity(

              opacity:
              showHeart ? 1 : 0,

              duration:
              const Duration(
                milliseconds: 220,
              ),

              child: TweenAnimationBuilder(

                tween:
                Tween<double>(
                  begin: 0.6,
                  end:
                  showHeart
                      ? 1.25
                      : 0.6,
                ),

                duration:
                const Duration(
                  milliseconds: 420,
                ),

                curve:
                Curves.easeOutBack,

                builder:
                    (context, scale, child) {

                  return Transform.scale(
                    scale: scale,

                    child: child,
                  );
                },

                child: Container(

                  decoration: BoxDecoration(

                    shape:
                    BoxShape.circle,

                    boxShadow: [

                      BoxShadow(
                        color:
                        const Color(
                          0xFFFF4D6D,
                        ).withValues(
                          alpha: 0.55,
                        ),

                        blurRadius: 40,
                      ),
                    ],
                  ),

                  child: const Icon(
                    Icons.favorite_rounded,

                    color:
                    Color(0xFFFF4D6D),

                    size: 110,
                  ),
                ),
              ),
            ),
          ),
        ),

        /// TOP
        Positioned(
          top: 8,
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

              const SizedBox(height: 8),

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

        /// SENT MESSAGE POPUP
        if (latestMessage != null)

          Positioned(
            bottom: 110,
            right: 20,

            child: AnimatedContainer(

              duration:
              const Duration(
                  milliseconds: 220),

              padding:
              const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),

              decoration: BoxDecoration(

                color:
                Colors.white.withValues(
                  alpha: 0.12,
                ),

                borderRadius:
                BorderRadius.circular(22),

                border: Border.all(
                  color:
                  Colors.white.withValues(
                    alpha: 0.10,
                  ),
                ),
              ),

              child: Row(
                mainAxisSize:
                MainAxisSize.min,

                children: [

                  const Icon(
                    Icons.send_rounded,

                    color: Colors.white,
                    size: 18,
                  ),

                  const SizedBox(width: 8),

                  Text(
                    latestMessage!,

                    style: const TextStyle(
                      color: Colors.white,

                      fontWeight:
                      FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),

        /// BOTTOM BAR
        Positioned(
          left: 16,
          right: 16,
          bottom: 18,

          child: SafeArea(

            child: ClipRRect(

              borderRadius:
              BorderRadius.circular(32),

              child: BackdropFilter(

                filter: ImageFilter.blur(
                  sigmaX: 18,
                  sigmaY: 18,
                ),

                child: Container(

                  padding:
                  const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),

                  decoration: BoxDecoration(

                    color:
                    Colors.black.withValues(
                      alpha: 0.24,
                    ),

                    borderRadius:
                    BorderRadius.circular(32),

                    border: Border.all(
                      color:
                      Colors.white.withValues(
                        alpha: 0.08,
                      ),
                    ),
                  ),

                  child: Row(
                    children: [

                      /// MESSAGE FIELD
                      Expanded(

                        child: Container(

                          height: 48,

                          padding:
                          const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),

                          decoration: BoxDecoration(

                            color:
                            Colors.white.withValues(
                              alpha: 0.10,
                            ),

                            borderRadius:
                            BorderRadius.circular(26),
                          ),

                          child: Row(
                            children: [

                              Expanded(
                                child: TextField(

                                  controller:
                                  messageController,

                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),

                                  decoration:
                                  const InputDecoration(

                                    hintText:
                                    "Send message...",

                                    hintStyle:
                                    TextStyle(
                                      color:
                                      Colors.white70,
                                    ),

                                    border:
                                    InputBorder.none,
                                  ),

                                  onSubmitted: (value) {

                                    if (mounted) {

                                      setState(() {

                                        latestMessage = null;
                                      });
                                    }

                                    setState(() {

                                      latestMessage = value;

                                      sentMessages.add(value);

                                      messageController.clear();
                                    });

                                    Future.delayed(
                                      const Duration(seconds: 2),

                                          () {

                                        if (mounted) {

                                          setState(() {

                                            latestMessage = null;
                                          });
                                        }
                                      },
                                    );
                                  },
                                ),
                              ),


                            ],
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      /// HEART
                      GestureDetector(

                        onTap: () {

                          setState(() {

                            likedStories[
                            currentStory.media] =

                            !(likedStories[
                            currentStory.media]
                                ?? false);
                          });
                        },

                        child: AnimatedScale(

                          duration:
                          const Duration(
                            milliseconds: 180,
                          ),

                          scale:

                          (likedStories[
                          currentStory.media]
                              ?? false)

                              ? 1.2
                              : 1,

                          child: Icon(

                            (likedStories[
                            currentStory.media]
                                ?? false)

                                ? Icons.favorite_rounded

                                : Icons.favorite_border_rounded,

                            color:

                            (likedStories[
                            currentStory.media]
                                ?? false)

                                ? const Color(0xFFFF4D6D)

                                : Colors.white,

                            size: 28,
                          ),
                        ),
                      ),

                      const SizedBox(width: 14),

                      /// SHARE
                      GestureDetector(

                        onTap: () {

                          showModalBottomSheet(

                            context: context,

                            backgroundColor:
                            Colors.black,

                            shape:
                            const RoundedRectangleBorder(

                              borderRadius:
                              BorderRadius.vertical(
                                top:
                                Radius.circular(30),
                              ),
                            ),

                            builder: (context) {

                              return Container(

                                padding:
                                const EdgeInsets.all(20),

                                child: Column(
                                  mainAxisSize:
                                  MainAxisSize.min,

                                  children: [

                                    buildShareUser(
                                      "mara.s",
                                    ),

                                    buildShareUser(
                                      "ona",
                                    ),

                                    buildShareUser(
                                      "sophy",
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },

                        child: const Icon(
                          Icons.send_rounded,

                          color: Colors.white,

                          size: 26,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
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

      onHorizontalDragUpdate:
          (details) {

        if (currentUserIndex == 0 &&
            details.delta.dx > 0) {

          setState(() {

            edgeOffset += details.delta.dx;
          });
        }

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

        if (currentUserIndex == 0 &&
            edgeOffset > 60) {

          Navigator.pop(context);
        }

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

      onVerticalDragUpdate:
          (details) {

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

      onLongPressStart: (_) {

        _pauseStory();
      },

      onLongPressEnd: (_) {

        _resumeStory();
      },

      onDoubleTap: () {

        setState(() {

          showHeart = true;

          likedStories[
          currentStory.media]
          = true;
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