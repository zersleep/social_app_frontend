import 'package:flutter/material.dart';

abstract class AppColors {
  // Backgrounds
  static const Color feedBackground  = Color(0xFFFFFBF7);
  static const Color cardBackground  = Colors.white;

  // Dividers / borders
  static const Color divider         = Color(0xFFE5E5E5);

  // Avatar placeholder
  static const Color avatarFill      = Color(0xFFD8B4A0);

  // Story ring — active
  static const List<Color> storyRing = [
    Color(0xFFFF5F6D),
    Color(0xFFFF9966),
    Color(0xFFFFC371),
  ];

  // Story ring — viewed
  static const List<Color> storyRingViewed = [
    Colors.grey,
    Colors.grey,
  ];

  // Like
  static const Color like            = Color(0xFFFF4D6D);

  // Primary accent — IG blue (links, follow btn, etc.)
  static const Color accent          = Color(0xFF3797F0);

  // Primary blue — Meta/DM blue (buttons, selections)
  static const Color primaryBlue     = Color(0xFF0095F6);

  // Online presence dot
  static const Color online          = Color(0xFF22C55E);

  // Repost green
  static const Color repost          = Color(0xFF00BA7C);
}
