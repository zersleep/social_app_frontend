import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/reel_model.dart';

const _friends = [
  (name: 'iko',     avatar: 'assets/images/story2.jpg'),
  (name: 'jules.h', avatar: 'assets/images/story3.jpg'),
  (name: 'mara.s',  avatar: 'assets/images/post2.jpg'),
  (name: 'ona',     avatar: 'assets/images/story1.jpg'),
  (name: 'lev.p',   avatar: 'assets/images/post5.jpg'),
  (name: 'danny',   avatar: 'assets/images/post4.jpg'),
  (name: 'raihan',  avatar: 'assets/images/post6.jpg'),
];

class ReelShareSheet extends StatefulWidget {
  final ReelModel reel;
  const ReelShareSheet({super.key, required this.reel});

  @override
  State<ReelShareSheet> createState() => _ReelShareSheetState();
}

class _ReelShareSheetState extends State<ReelShareSheet> {
  final Set<String> _sent = {};

  void _sendTo(String name) => setState(() => _sent.add(name));

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return Container(
      decoration: const BoxDecoration(
        color:        Color(0xFF1C1C1E),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Handle ───────────────────────────────────────────────────
          const SizedBox(height: 12),
          Center(
            child: Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: Colors.white24, borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // ── Title ────────────────────────────────────────────────────
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Share',
                style: TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w700, fontSize: 18,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // ── Friends row ───────────────────────────────────────────────
          SizedBox(
            height: 92,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding:         const EdgeInsets.symmetric(horizontal: 16),
              itemCount:       _friends.length,
              itemBuilder: (_, i) {
                final f    = _friends[i];
                final sent = _sent.contains(f.name);
                return GestureDetector(
                  onTap: () => _sendTo(f.name),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 18),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundImage: AssetImage(f.avatar),
                            ),
                            if (sent)
                              Positioned.fill(
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.black54,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.check_rounded,
                                    color: Colors.white,
                                    size:  22,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          f.name,
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 12),
          const Divider(height: 1, color: Colors.white12),
          const SizedBox(height: 16),

          // ── Action grid ───────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing:    14,
              runSpacing: 14,
              children: [
                _ShareOption(
                  icon:  Icons.link_rounded,
                  label: 'Copy link',
                  onTap: () {
                    Clipboard.setData(
                      const ClipboardData(text: 'https://social.app/reel/123'),
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
                  icon:  Icons.download_rounded,
                  label: 'Save video',
                  onTap: () => Navigator.pop(context),
                ),
                _ShareOption(
                  icon:  Icons.share_rounded,
                  label: 'Share to...',
                  onTap: () => Navigator.pop(context),
                ),
                _ShareOption(
                  icon:  Icons.qr_code_rounded,
                  label: 'QR code',
                  onTap: () => Navigator.pop(context),
                ),
                _ShareOption(
                  icon:  Icons.not_interested_rounded,
                  label: 'Not interested',
                  onTap: () => Navigator.pop(context),
                ),
                _ShareOption(
                  icon:  Icons.flag_rounded,
                  label: 'Report',
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          SizedBox(height: bottomPad + 24),
        ],
      ),
    );
  }
}

// ─── Option tile ──────────────────────────────────────────────────────────────

class _ShareOption extends StatelessWidget {
  final IconData     icon;
  final String       label;
  final VoidCallback onTap;

  const _ShareOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 72,
        child: Column(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color:        Colors.white12,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 11),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}
