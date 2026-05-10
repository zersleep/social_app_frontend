import 'package:flutter/material.dart';
import '../../story/screens/story_viewer_screen.dart';
import '../screens/image_viewer_screen.dart';
import '../../story/story_data.dart';

class PostCard extends StatefulWidget {

  final String profileImage;
  final String username;
  final String subtitle;

  final List<String> postImages;

  final String caption;

  final bool hasStory;

  const PostCard({
    super.key,
    required this.profileImage,
    required this.username,
    required this.subtitle,
    required this.postImages,
    required this.caption,
    this.hasStory = false,
  });

  @override
  State<PostCard> createState() =>
      _PostCardState();
}

class _PostCardState extends State<PostCard> {

  int currentPage = 0;

  bool isLiked = false;

  bool showHeart = false;

  final PageController pageController =
  PageController();

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 16,
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          /// TOP USER INFO
          Row(
            children: [

              /// PROFILE IMAGE
              GestureDetector(

                onTap: () {

                  if (widget.hasStory) {

                    Navigator.push(
                      context,

                      MaterialPageRoute(
                        builder: (_) => StoryViewerScreen(
                          users: storyUsers,
                          initialUserIndex: 0,
                        ),
                      ),
                    );
                  }
                },

                child: Container(
                  padding:
                  const EdgeInsets.all(2),

                  decoration: BoxDecoration(
                    shape: BoxShape.circle,

                    gradient: widget.hasStory

                        ? const LinearGradient(
                      colors: [
                        Color(0xFFFF5F6D),
                        Color(0xFFFFC371),
                      ],
                    )

                        : null,
                  ),

                  child: CircleAvatar(
                    radius: 20,

                    backgroundImage:
                    AssetImage(
                      widget.profileImage,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 10),

              /// USER INFO
              Expanded(
                child: GestureDetector(

                  onTap: () {

                    /// profile later

                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(

                      SnackBar(
                        content: Text(
                          "Open ${widget.username} profile",
                        ),
                      ),
                    );
                  },

                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    children: [

                      Text(
                        widget.username,

                        style:
                        const TextStyle(
                          fontWeight:
                          FontWeight.bold,

                          fontSize: 15,
                        ),
                      ),

                      Text(
                        widget.subtitle,

                        style: TextStyle(
                          color:
                          Colors.grey
                              .shade600,

                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              /// MORE BUTTON
              IconButton(
                onPressed: () {},

                icon: const Icon(
                  Icons.more_horiz,
                  size: 22,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// IMAGE SLIDER
          ClipRRect(
            borderRadius:
            BorderRadius.circular(26),

            child: Stack(
              alignment: Alignment.center,

              children: [

                /// PAGE VIEW
                SizedBox(
                  height: 320,

                  child: PageView.builder(

                    controller: pageController,

                    itemCount:
                    widget.postImages.length,

                    onPageChanged: (index) {

                      setState(() {
                        currentPage = index;
                      });
                    },

                    itemBuilder:
                        (context, index) {

                      return GestureDetector(

                        onDoubleTap: () {

                          setState(() {

                            isLiked = true;

                            showHeart = true;
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

                        onTap: () {

                          Navigator.push(
                            context,

                            MaterialPageRoute(
                              builder: (_) =>
                                  ImageViewerScreen(

                                    images:
                                    widget.postImages,

                                    initialIndex:
                                    index,
                                  ),
                            ),
                          );
                        },

                        child: Container(

                          color: Colors.black,

                          child: Center(
                            child: Image.asset(

                              widget.postImages[
                              index
                              ],

                              fit: BoxFit.contain,

                              width:
                              double.infinity,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                /// IMAGE COUNT
                Positioned(
                  top: 12,
                  right: 12,

                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),

                    decoration: BoxDecoration(
                      color: Colors.black38,

                      borderRadius:
                      BorderRadius.circular(
                          20),
                    ),

                    child: Text(
                      "${currentPage + 1}/${widget.postImages.length}",

                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight:
                        FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                /// DOTS
                Positioned(
                  bottom: 14,

                  child: Row(
                    children: List.generate(

                      widget.postImages.length,

                          (index) {

                        final bool active =
                            currentPage == index;

                        return AnimatedContainer(

                          duration:
                          const Duration(
                            milliseconds: 200,
                          ),

                          margin:
                          const EdgeInsets.symmetric(
                            horizontal: 3,
                          ),

                          width:
                          active ? 18 : 5,

                          height: 5,

                          decoration:
                          BoxDecoration(

                            color:
                            active

                                ? Colors.white

                                : Colors.white54,

                            borderRadius:
                            BorderRadius.circular(
                                20),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                /// HEART ANIMATION
                AnimatedOpacity(

                  duration:
                  const Duration(milliseconds: 250),

                  opacity: showHeart ? 1 : 0,

                  child: AnimatedScale(

                    duration:
                    const Duration(milliseconds: 250),

                    scale: showHeart ? 1 : 0.6,

                    child: const Icon(
                      Icons.favorite,

                      color: Colors.white,

                      size: 110,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          /// ACTIONS
          Padding(
            padding:
            const EdgeInsets.symmetric(
              horizontal: 2,
            ),

            child: Row(
              children: [

                GestureDetector(

                  onTap: () {

                    setState(() {
                      isLiked = !isLiked;
                    });
                  },

                  child: AnimatedScale(

                    duration:
                    const Duration(milliseconds: 200),

                    scale: isLiked ? 1.15 : 1,

                    child: Icon(

                      isLiked

                          ? Icons.favorite

                          : Icons.favorite_outline,

                      size: 26,

                      color:
                      isLiked

                          ? Colors.red

                          : Colors.black,
                    ),
                  ),
                ),

                const SizedBox(width: 20),

                _minimalIcon(
                  Icons.chat_bubble_outline_rounded,
                ),

                const SizedBox(width: 20),

                _minimalIcon(
                  Icons.reply_rounded,
                ),

                const Spacer(),

                _minimalIcon(
                  Icons.bookmark_outline,
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          /// LIKES
          const Text(
            "1,284 likes",

            style: TextStyle(
              fontWeight:
              FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          /// CAPTION
          RichText(
            text: TextSpan(
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
                height: 1.7,
              ),

              children: [

                TextSpan(
                  text:
                  "${widget.username} ",

                  style:
                  const TextStyle(
                    fontWeight:
                    FontWeight
                        .bold,
                  ),
                ),

                TextSpan(
                  text: widget.caption,
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          /// COMMENTS
          Text(
            "view all 3 comments",

            style: TextStyle(
              color:
              Colors.grey.shade700,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            "2H AGO",

            style: TextStyle(
              color:
              Colors.grey.shade500,

              fontSize: 11,

              letterSpacing: 1,
            ),
          ),

          const SizedBox(height: 18),

          const SizedBox(height: 18),

          Container(
            margin:
            const EdgeInsets.only(
              top: 4,
            ),

            width: double.infinity,
            height: 1.2,

            color: const Color(
              0xFFE5E5E5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _minimalIcon(
      IconData icon,
      ) {

    return Padding(
      padding: const EdgeInsets.all(4),

      child: Icon(
        icon,

        size: 25,

        color: Colors.black,

        weight: 300,
      ),
    );
  }
}