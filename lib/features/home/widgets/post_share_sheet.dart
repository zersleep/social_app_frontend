import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/post_model.dart';

// ─── Mock data ────────────────────────────────────────────────────────────────

const _dms = [
  (name: 'iko',     avatar: 'assets/images/story2.jpg'),
  (name: 'jules.h', avatar: 'assets/images/story3.jpg'),
  (name: 'mara.s',  avatar: 'assets/images/post2.jpg'),
  (name: 'ona',     avatar: 'assets/images/story1.jpg'),
  (name: 'lev.p',   avatar: 'assets/images/post5.jpg'),
  (name: 'danny',   avatar: 'assets/images/post4.jpg'),
  (name: 'raihan',  avatar: 'assets/images/post6.jpg'),
];

// ─── Sheet ────────────────────────────────────────────────────────────────────

class PostShareSheet extends StatefulWidget {
  final PostModel post;
  const PostShareSheet({super.key, required this.post});

  @override
  State<PostShareSheet> createState() => _PostShareSheetState();
}

class _PostShareSheetState extends State<PostShareSheet> {
  final _searchController = TextEditingController();
  final Set<String> _selected = {};

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggle(String name) => setState(() {
    _selected.contains(name) ? _selected.remove(name) : _selected.add(name);
  });

  void _sendSelected() {
    if (_selected.isEmpty) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final bottomPad   = MediaQuery.of(context).padding.bottom;

    return Container(
      decoration: const BoxDecoration(
        color:        Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
      ),
      padding: EdgeInsets.only(bottom: bottomInset > 0 ? bottomInset : bottomPad),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Handle ───────────────────────────────────────────────────
          const SizedBox(height: 10),
          Center(
            child: Container(
              width: 36, height: 4,
              decoration: BoxDecoration(
                color:        Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 14),

          // ── Search bar ────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Container(
              height: 38,
              decoration: BoxDecoration(
                color:        Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: _searchController,
                style:      const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  hintText:       'Search',
                  hintStyle:      TextStyle(color: Colors.grey[500], fontSize: 14),
                  prefixIcon:     Icon(Icons.search, color: Colors.grey[500], size: 20),
                  border:         InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 9),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // ── DM friends row ────────────────────────────────────────────
          SizedBox(
            height: 96,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding:         const EdgeInsets.symmetric(horizontal: 14),
              itemCount:       _dms.length,
              itemBuilder: (_, i) {
                final dm       = _dms[i];
                final selected = _selected.contains(dm.name);
                return GestureDetector(
                  onTap: () => _toggle(dm.name),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 18),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: selected
                                    ? Border.all(color: const Color(0xFF0095F6), width: 2.5)
                                    : null,
                              ),
                              child: CircleAvatar(
                                radius:          28,
                                backgroundImage: AssetImage(dm.avatar),
                              ),
                            ),
                            if (selected)
                              Positioned(
                                right:  0,
                                bottom: 0,
                                child: Container(
                                  width:  20,
                                  height: 20,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF0095F6),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.check, color: Colors.white, size: 13),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          dm.name,
                          style: TextStyle(
                            fontSize:   12,
                            color:      selected ? const Color(0xFF0095F6) : Colors.black,
                            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 4),
          const Divider(height: 1, thickness: 0.5),
          const SizedBox(height: 4),

          // ── Options list ──────────────────────────────────────────────
          _ShareOption(
            icon:    Icons.link_rounded,
            color:   const Color(0xFF1877F2),
            label:   'Copy link',
            onTap: () {
              Clipboard.setData(
                const ClipboardData(text: 'https://social.app/post/123'),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content:  const Text('Link copied'),
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 1),
                  shape:    RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
              Navigator.pop(context);
            },
          ),
          _ShareOption(
            icon:    Icons.auto_awesome_rounded,
            color:   const Color(0xFFE1306C),
            label:   'Share to your Story',
            onTap:   () => Navigator.pop(context),
          ),
          _ShareOption(
            icon:    Icons.group_rounded,
            color:   const Color(0xFF00B900),
            label:   'Share to Close Friends',
            onTap:   () => Navigator.pop(context),
          ),
          _ShareOption(
            icon:    Icons.add_box_outlined,
            color:   Colors.black,
            label:   'Add post to your profile',
            onTap:   () => Navigator.pop(context),
          ),
          _ShareOption(
            icon:    Icons.ios_share_rounded,
            color:   Colors.black,
            label:   'Share to...',
            onTap:   () => Navigator.pop(context),
          ),

          const SizedBox(height: 8),

          // ── Send button (appears when friends selected) ───────────────
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            child: _selected.isEmpty
                ? const SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.fromLTRB(14, 4, 14, 12),
                    child: SizedBox(
                      width:  double.infinity,
                      height: 46,
                      child: ElevatedButton(
                        onPressed: _sendSelected,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0095F6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Send (${_selected.length})',
                          style: const TextStyle(
                            color:      Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize:   15,
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

// ─── Option row ───────────────────────────────────────────────────────────────

class _ShareOption extends StatelessWidget {
  final IconData     icon;
  final Color        color;
  final String       label;
  final VoidCallback onTap;

  const _ShareOption({
    required this.icon,
    required this.color,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(width: 16),
            Text(
              label,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ),
    );
  }
}
