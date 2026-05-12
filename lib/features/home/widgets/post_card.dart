import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/story_avatar.dart';
import '../../profile/other_profile_view.dart';
import '../../story/screens/story_viewer_screen.dart';
import '../../story/story_data.dart';
import '../models/post_model.dart';
import '../screens/image_viewer_screen.dart';
import 'post_comments_sheet.dart';
import 'post_share_sheet.dart';

// ─── Public widget ────────────────────────────────────────────────────────────

class PostCard extends StatefulWidget {
  final PostModel post;

  const PostCard({super.key, required this.post});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool _isLiked    = false;
  bool _isReposted = false;

  void _toggleLike()   => setState(() => _isLiked    = !_isLiked);
  void _forceLike()    => setState(() => _isLiked    = true);
  void _toggleRepost() => setState(() => _isReposted = !_isReposted);

  void _openComments() => showModalBottomSheet(
    context:            context,
    isScrollControlled: true,
    backgroundColor:    Colors.transparent,
    builder: (_) => PostCommentsSheet(post: widget.post),
  );

  void _openShare() => showModalBottomSheet(
    context:            context,
    isScrollControlled: true,
    backgroundColor:    Colors.transparent,
    builder: (_) => PostShareSheet(post: widget.post),
  );

  @override
  Widget build(BuildContext context) {
    final post = widget.post;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PostHeader(post: post),
          const SizedBox(height: 12),
          _PostImageSlider(images: post.images, onLike: _forceLike),
          const SizedBox(height: 14),
          _PostActions(
            isLiked:       _isLiked,
            isReposted:    _isReposted,
            onToggleLike:  _toggleLike,
            onComment:     _openComments,
            onRepost:      _toggleRepost,
            onShare:       _openShare,
          ),
          const SizedBox(height: 12),
          _PostCaption(
            post:            post,
            isLiked:         _isLiked,
            onViewComments:  _openComments,
          ),
          const SizedBox(height: 18),
          const _PostDivider(),
        ],
      ),
    );
  }
}

// ─── Sub-widgets ──────────────────────────────────────────────────────────────

class _PostHeader extends StatelessWidget {
  final PostModel post;
  const _PostHeader({required this.post});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Avatar with optional story ring
        GestureDetector(
          onTap: () {
            if (!post.hasStory) return;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => StoryViewerScreen(
                  users:            storyUsers,
                  initialUserIndex: 0,
                ),
              ),
            );
          },
          child: StoryAvatar(
            imagePath: post.profileImage,
            username:  post.username,
            radius:    20,
            hasRing:   post.hasStory,
          ),
        ),
        const SizedBox(width: 10),

        // Username + subtitle
        Expanded(
          child: GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => OtherProfileView(
                  username:     post.username,
                  profileImage: post.profileImage,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.username,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize:   15,
                  ),
                ),
                Text(
                  post.subtitle,
                  style: TextStyle(
                    color:    Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),

        // More
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.more_horiz, size: 22),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _PostImageSlider extends StatefulWidget {
  final List<String> images;
  final VoidCallback onLike;

  const _PostImageSlider({required this.images, required this.onLike});

  @override
  State<_PostImageSlider> createState() => _PostImageSliderState();
}

class _PostImageSliderState extends State<_PostImageSlider> {
  final PageController _pageController = PageController();
  int  _currentPage = 0;
  bool _showHeart   = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onDoubleTap() {
    widget.onLike();
    setState(() => _showHeart = true);
    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) setState(() => _showHeart = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(26),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Page view
          SizedBox(
            height: 320,
            child: PageView.builder(
              controller: _pageController,
              itemCount:  widget.images.length,
              onPageChanged: (i) => setState(() => _currentPage = i),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onDoubleTap: _onDoubleTap,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ImageViewerScreen(
                        images:       widget.images,
                        initialIndex: index,
                      ),
                    ),
                  ),
                  child: Container(
                    color: Colors.black,
                    child: Center(
                      child: Image.asset(
                        widget.images[index],
                        fit:   BoxFit.contain,
                        width: double.infinity,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Image count badge (top-right)
          if (widget.images.length > 1)
            Positioned(
              top:   12,
              right: 12,
              child: _CountBadge(
                current: _currentPage + 1,
                total:   widget.images.length,
              ),
            ),

          // Dot indicators (bottom)
          if (widget.images.length > 1)
            Positioned(
              bottom: 14,
              child: _DotIndicator(
                count:   widget.images.length,
                current: _currentPage,
              ),
            ),

          // Heart burst on double-tap
          IgnorePointer(
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 250),
              opacity:  _showHeart ? 1 : 0,
              child: AnimatedScale(
                duration: const Duration(milliseconds: 250),
                scale:    _showHeart ? 1 : 0.6,
                child: const Icon(
                  Icons.favorite,
                  color: Colors.white,
                  size:  110,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _PostActions extends StatelessWidget {
  final bool         isLiked;
  final bool         isReposted;
  final VoidCallback onToggleLike;
  final VoidCallback onComment;
  final VoidCallback onRepost;
  final VoidCallback onShare;

  const _PostActions({
    required this.isLiked,
    required this.isReposted,
    required this.onToggleLike,
    required this.onComment,
    required this.onRepost,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Row(
        children: [
          // Like
          GestureDetector(
            onTap: onToggleLike,
            child: AnimatedScale(
              duration: const Duration(milliseconds: 200),
              scale:    isLiked ? 1.15 : 1,
              child: Icon(
                isLiked ? Icons.favorite : Icons.favorite_outline,
                size:  26,
                color: isLiked ? AppColors.like : Colors.black,
              ),
            ),
          ),
          const SizedBox(width: 20),

          // Comment
          GestureDetector(
            onTap: onComment,
            child: _ActionIcon(Icons.chat_bubble_outline_rounded),
          ),
          const SizedBox(width: 20),

          // Repost
          GestureDetector(
            onTap: onRepost,
            child: AnimatedScale(
              duration: const Duration(milliseconds: 180),
              scale: isReposted ? 1.15 : 1.0,
              child: Icon(
                Icons.repeat_rounded,
                size:  26,
                color: isReposted ? const Color(0xFF00BA7C) : Colors.black,
              ),
            ),
          ),
          const SizedBox(width: 20),

          // Share
          GestureDetector(
            onTap: onShare,
            child: _ActionIcon(Icons.reply_rounded),
          ),

          const Spacer(),

          // Bookmark
          _ActionIcon(Icons.bookmark_outline),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _PostCaption extends StatelessWidget {
  final PostModel    post;
  final bool         isLiked;
  final VoidCallback onViewComments;

  const _PostCaption({
    required this.post,
    required this.isLiked,
    required this.onViewComments,
  });

  @override
  Widget build(BuildContext context) {
    final likes = isLiked ? post.likeCount + 1 : post.likeCount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$likes likes',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        RichText(
          text: TextSpan(
            style: const TextStyle(color: Colors.black, fontSize: 14, height: 1.7),
            children: [
              TextSpan(
                text:  '${post.username} ',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(text: post.caption),
            ],
          ),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: onViewComments,
          child: Text(
            'View all ${post.commentCount} comments',
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          post.timeAgo,
          style: TextStyle(
            color:         Colors.grey.shade500,
            fontSize:      11,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _PostDivider extends StatelessWidget {
  const _PostDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:  const EdgeInsets.only(top: 4),
      height:  1.2,
      color:   AppColors.divider,
    );
  }
}

// ─── Micro widgets (used only within this file) ───────────────────────────────

class _CountBadge extends StatelessWidget {
  final int current;
  final int total;
  const _CountBadge({required this.current, required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color:        Colors.black38,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '$current / $total',
        style: const TextStyle(
          color:      Colors.white,
          fontSize:   11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _DotIndicator extends StatelessWidget {
  final int current;
  final int count;
  const _DotIndicator({required this.current, required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (i) {
        final active = i == current;
        return AnimatedContainer(
          duration:  const Duration(milliseconds: 200),
          margin:    const EdgeInsets.symmetric(horizontal: 3),
          width:     active ? 18 : 5,
          height:    5,
          decoration: BoxDecoration(
            color:        active ? Colors.white : Colors.white54,
            borderRadius: BorderRadius.circular(20),
          ),
        );
      }),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  final IconData icon;
  const _ActionIcon(this.icon);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Icon(icon, size: 25, color: Colors.black),
    );
  }
}
