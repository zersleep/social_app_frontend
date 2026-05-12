import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../profile/other_profile_view.dart';
import '../models/reel_model.dart';
import 'reel_comments_sheet.dart';
import 'reel_share_sheet.dart';

// ─── Public widget ────────────────────────────────────────────────────────────

class ReelItem extends StatefulWidget {
  final ReelModel reel;
  final bool      isActive;

  const ReelItem({super.key, required this.reel, required this.isActive});

  @override
  State<ReelItem> createState() => _ReelItemState();
}

class _ReelItemState extends State<ReelItem> {
  late VideoPlayerController _controller;
  bool _isLiked     = false;
  late int _likeCount;
  bool _showHeart   = false;
  late bool _isFollowing;

  @override
  void initState() {
    super.initState();
    _likeCount   = widget.reel.likeCount;
    _isFollowing = widget.reel.isFollowing;
    _controller  = VideoPlayerController.asset(widget.reel.videoPath)
      ..initialize().then((_) {
        if (!mounted) return;
        setState(() {});
        _controller.setLooping(true);
        if (widget.isActive) _controller.play();
      });
  }

  @override
  void didUpdateWidget(ReelItem old) {
    super.didUpdateWidget(old);
    if (old.isActive != widget.isActive) {
      widget.isActive ? _controller.play() : _controller.pause();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // ── Interactions ────────────────────────────────────────────────────────────

  void _onTap() {
    _controller.value.isPlaying ? _controller.pause() : _controller.play();
    setState(() {});
  }

  void _onDoubleTap() {
    if (!_isLiked) setState(() { _isLiked = true; _likeCount++; });
    setState(() => _showHeart = true);
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) setState(() => _showHeart = false);
    });
  }

  void _toggleLike() => setState(() {
    _isLiked   = !_isLiked;
    _likeCount += _isLiked ? 1 : -1;
  });

  void _openComments() {
    _controller.pause();
    showModalBottomSheet(
      context:             context,
      isScrollControlled:  true,
      backgroundColor:     Colors.transparent,
      builder: (_) => ReelCommentsSheet(commentCount: widget.reel.commentCount),
    ).whenComplete(_resumeIfActive);
  }

  void _openShare() {
    _controller.pause();
    showModalBottomSheet(
      context:             context,
      isScrollControlled:  true,
      backgroundColor:     Colors.transparent,
      builder: (_) => ReelShareSheet(reel: widget.reel),
    ).whenComplete(_resumeIfActive);
  }

  void _openProfile() {
    _controller.pause();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OtherProfileView(
          username:     widget.reel.username,
          profileImage: widget.reel.profileImage,
        ),
      ),
    ).whenComplete(_resumeIfActive);
  }

  void _resumeIfActive() {
    if (widget.isActive && mounted) _controller.play();
  }

  // ── Build ────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return GestureDetector(
      behavior:    HitTestBehavior.opaque,
      onTap:       _onTap,
      onDoubleTap: _onDoubleTap,
      child: SizedBox.expand(
        child: Stack(
          children: [
            // ── Video ──────────────────────────────────────────────────
            _VideoLayer(controller: _controller),

            // ── Gradient overlay ───────────────────────────────────────
            const _BottomGradient(),

            // ── Pause indicator ────────────────────────────────────────
            if (!_controller.value.isPlaying && _controller.value.isInitialized)
              const Center(
                child: Icon(Icons.play_arrow_rounded, color: Colors.white54, size: 72),
              ),

            // ── Double-tap heart ───────────────────────────────────────
            _HeartBurst(visible: _showHeart),

            // ── Right actions ──────────────────────────────────────────
            Positioned(
              right:  10,
              bottom: bottomPad + 100,
              child: _RightActions(
                isLiked:      _isLiked,
                likeCount:    _likeCount,
                commentCount: widget.reel.commentCount,
                shareCount:   widget.reel.shareCount,
                profileImage: widget.reel.profileImage,
                onLike:       _toggleLike,
                onComment:    _openComments,
                onShare:      _openShare,
                onProfile:    _openProfile,
              ),
            ),

            // ── Bottom info ────────────────────────────────────────────
            Positioned(
              left:   16,
              right:  80,
              bottom: bottomPad + 100,
              child: _BottomInfo(
                reel:        widget.reel,
                isFollowing: _isFollowing,
                onFollow:    () => setState(() => _isFollowing = !_isFollowing),
                onProfile:   _openProfile,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Video layer ──────────────────────────────────────────────────────────────

class _VideoLayer extends StatelessWidget {
  final VideoPlayerController controller;
  const _VideoLayer({required this.controller});

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white38, strokeWidth: 1.5),
      );
    }
    return SizedBox.expand(
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width:  controller.value.size.width,
          height: controller.value.size.height,
          child:  VideoPlayer(controller),
        ),
      ),
    );
  }
}

// ─── Gradient overlay ─────────────────────────────────────────────────────────

class _BottomGradient extends StatelessWidget {
  const _BottomGradient();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin:  Alignment.topCenter,
              end:    Alignment.bottomCenter,
              stops:  const [0.45, 1.0],
              colors: [
                Colors.transparent,
                Colors.black.withValues(alpha: 0.72),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Heart burst ──────────────────────────────────────────────────────────────

class _HeartBurst extends StatelessWidget {
  final bool visible;
  const _HeartBurst({required this.visible});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: IgnorePointer(
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity:  visible ? 1.0 : 0.0,
          child: AnimatedScale(
            duration: const Duration(milliseconds: 400),
            curve:    Curves.easeOutBack,
            scale:    visible ? 1.3 : 0.4,
            child: const Icon(
              Icons.favorite_rounded,
              color:  Colors.white,
              size:   120,
              shadows: [Shadow(blurRadius: 40, color: Colors.white38)],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Right action column ──────────────────────────────────────────────────────

class _RightActions extends StatelessWidget {
  final bool         isLiked;
  final int          likeCount;
  final int          commentCount;
  final int          shareCount;
  final String       profileImage;
  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback onShare;
  final VoidCallback onProfile;

  const _RightActions({
    required this.isLiked,
    required this.likeCount,
    required this.commentCount,
    required this.shareCount,
    required this.profileImage,
    required this.onLike,
    required this.onComment,
    required this.onShare,
    required this.onProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Profile avatar
        GestureDetector(
          onTap: onProfile,
          child: Container(
            decoration: BoxDecoration(
              shape:  BoxShape.circle,
              border: Border.all(color: Colors.white, width: 1.5),
            ),
            child: CircleAvatar(
              radius: 22,
              backgroundImage: AssetImage(profileImage),
            ),
          ),
        ),
        const SizedBox(height: 22),

        _ActionBtn(
          icon:    isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          label:   _fmt(likeCount),
          color:   isLiked ? const Color(0xFFFF4D6D) : Colors.white,
          onTap:   onLike,
          animate: isLiked,
        ),
        const SizedBox(height: 20),

        _ActionBtn(
          icon:  Icons.chat_bubble_rounded,
          label: _fmt(commentCount),
          onTap: onComment,
        ),
        const SizedBox(height: 20),

        _ActionBtn(
          icon:    Icons.reply_rounded,
          label:   _fmt(shareCount),
          onTap:   onShare,
          mirrorX: true,
        ),
        const SizedBox(height: 20),

        _ActionBtn(
          icon:  Icons.more_horiz_rounded,
          label: '',
          onTap: () {},
        ),
      ],
    );
  }

  static String _fmt(int n) =>
      n >= 1000 ? '${(n / 1000).toStringAsFixed(1)}K' : '$n';
}

class _ActionBtn extends StatelessWidget {
  final IconData     icon;
  final String       label;
  final Color        color;
  final VoidCallback onTap;
  final bool         animate;
  final bool         mirrorX;

  const _ActionBtn({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color   = Colors.white,
    this.animate = false,
    this.mirrorX = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget ico = AnimatedScale(
      duration: const Duration(milliseconds: 200),
      scale:    animate ? 1.25 : 1.0,
      child:    Icon(icon, color: color, size: 30),
    );
    if (mirrorX) ico = Transform.scale(scaleX: -1, child: ico);

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          ico,
          if (label.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Bottom info ──────────────────────────────────────────────────────────────

class _BottomInfo extends StatelessWidget {
  final ReelModel    reel;
  final bool         isFollowing;
  final VoidCallback onFollow;
  final VoidCallback onProfile;

  const _BottomInfo({
    required this.reel,
    required this.isFollowing,
    required this.onFollow,
    required this.onProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Username row
        Row(
          children: [
            GestureDetector(
              onTap: onProfile,
              child: CircleAvatar(
                radius: 16,
                backgroundImage: AssetImage(reel.profileImage),
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: onProfile,
              child: Text(
                reel.username,
                style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15,
                ),
              ),
            ),
            const SizedBox(width: 10),
            if (!isFollowing)
              GestureDetector(
                onTap: onFollow,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                  decoration: BoxDecoration(
                    border:       Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Follow',
                    style: TextStyle(
                      color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),

        // Caption
        Text(
          reel.caption,
          style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.4),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 10),

        // Audio pill
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color:        Colors.black45,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.music_note_rounded, color: Colors.white, size: 14),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  reel.audioTitle,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
