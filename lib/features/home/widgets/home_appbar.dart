import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../screens/create_post_screen.dart';

class HomeAppBar extends StatefulWidget {
  const HomeAppBar({super.key});

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _plusController;
  late final Animation<double> _plusRotation;

  @override
  void initState() {
    super.initState();
    _plusController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    _plusRotation = Tween<double>(begin: 0, end: 0.125).animate(
      CurvedAnimation(parent: _plusController, curve: Curves.easeOutBack),
    );
  }

  @override
  void dispose() {
    _plusController.dispose();
    super.dispose();
  }

  void _onPlusTap() {
    _plusController.forward();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const _CreateBottomSheet(),
    ).whenComplete(() => _plusController.reverse());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 18,
        left: 20,
        right: 20,
        bottom: 14,
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            /// LOGO
            const Expanded(
              child: Text(
                "Social app",
                style: TextStyle(
                  fontSize: 32,
                  fontFamily: 'Cookie',
                  color: Colors.black87,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),

            /// PLUS
            GestureDetector(
              onTap: _onPlusTap,
              child: RotationTransition(
                turns: _plusRotation,
                child: const Icon(
                  CupertinoIcons.plus_circle,
                  size: 26,
                  color: Colors.black87,
                ),
              ),
            ),

            const SizedBox(width: 18),

            /// HEART
            _topIcon(CupertinoIcons.heart),

            const SizedBox(width: 18),

            /// CHAT
            _topIcon(CupertinoIcons.chat_bubble),
          ],
        ),
      ),
    );
  }

  Widget _topIcon(IconData icon) {
    return Icon(icon, size: 26, color: Colors.black87);
  }
}

// ─── Bottom Sheet ─────────────────────────────────────────────────────────────

class _CreateBottomSheet extends StatefulWidget {
  const _CreateBottomSheet();

  @override
  State<_CreateBottomSheet> createState() => _CreateBottomSheetState();
}

class _CreateBottomSheetState extends State<_CreateBottomSheet>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  static const _items = [
    _CreateItem(
      icon: Icons.photo_library_outlined,
      label: 'Post',
      description: 'Share photos to your feed',
      color: Color(0xFF6C63FF),
    ),
    _CreateItem(
      icon: Icons.auto_awesome,
      label: 'Story',
      description: 'Share moments for 24h',
      color: Color(0xFFFF5F6D),
    ),
    _CreateItem(
      icon: Icons.play_circle_outline_rounded,
      label: 'Short',
      description: 'Create a short video',
      color: Color(0xFF00C9A7),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 14, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          const SizedBox(height: 20),

          // Title
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Create',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.4,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Items
          ...List.generate(_items.length, (i) {
            final delay = i * 0.15;
            final itemAnim = CurvedAnimation(
              parent: _controller,
              curve: Interval(delay, delay + 0.6, curve: Curves.easeOutCubic),
            );
            return AnimatedBuilder(
              animation: itemAnim,
              builder: (context, child) => Opacity(
                opacity: itemAnim.value,
                child: Transform.translate(
                  offset: Offset(0, 24 * (1 - itemAnim.value)),
                  child: child,
                ),
              ),
              child: _CreateTile(
                item: _items[i],
                onTap: () {
                  Navigator.pop(context);
                  if (_items[i].label == 'Post') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CreatePostScreen()),
                    );
                  }
                },
              ),
            );
          }),

          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}

class _CreateItem {
  final IconData icon;
  final String label;
  final String description;
  final Color color;
  const _CreateItem({
    required this.icon,
    required this.label,
    required this.description,
    required this.color,
  });
}

class _CreateTile extends StatefulWidget {
  final _CreateItem item;
  final VoidCallback onTap;
  const _CreateTile({required this.item, required this.onTap});

  @override
  State<_CreateTile> createState() => _CreateTileState();
}

class _CreateTileState extends State<_CreateTile> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: _pressed ? Colors.grey[100] : Colors.grey[50],
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: widget.item.color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(widget.item.icon, color: widget.item.color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.item.label,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.item.description,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, size: 15, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }
}
