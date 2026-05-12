import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Reusable story-ring avatar used in the feed StoryItem and chat stories.
///
/// Pass [hasRing] to show the gradient ring.
/// Pass [isViewed] to switch to the grey ring.
/// Pass [showAddBadge] for the "+" overlay (current-user with no story).
class StoryAvatar extends StatelessWidget {
  final String?  imagePath;
  final String   username;
  final double   radius;
  final bool     hasRing;
  final bool     isViewed;
  final bool     showAddBadge;

  const StoryAvatar({
    super.key,
    this.imagePath,
    required this.username,
    this.radius       = 30,
    this.hasRing      = false,
    this.isViewed     = false,
    this.showAddBadge = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // ── Ring + white gap + avatar ──────────────────────────────────
        Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            shape:    BoxShape.circle,
            gradient: hasRing
                ? LinearGradient(
                    colors: isViewed
                        ? AppColors.storyRingViewed
                        : AppColors.storyRing,
                  )
                : null,
          ),
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: CircleAvatar(
              radius:          radius,
              backgroundColor: AppColors.avatarFill,
              backgroundImage: imagePath != null
                  ? AssetImage(imagePath!) as ImageProvider
                  : null,
              child: imagePath == null
                  ? Text(
                      username[0].toUpperCase(),
                      style: TextStyle(
                        color:      Colors.white,
                        fontSize:   radius,
                        fontWeight: FontWeight.w300,
                        fontStyle:  FontStyle.italic,
                      ),
                    )
                  : null,
            ),
          ),
        ),

        // ── Add badge ──────────────────────────────────────────────────
        if (showAddBadge)
          Positioned(
            bottom: 2,
            right:  2,
            child: Container(
              width:  24,
              height: 24,
              decoration: BoxDecoration(
                color:  Colors.black,
                shape:  BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 4),
                ],
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 14),
            ),
          ),
      ],
    );
  }
}
