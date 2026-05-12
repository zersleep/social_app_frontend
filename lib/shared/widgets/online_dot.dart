import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Green presence dot placed via [Positioned] inside a [Stack] over an avatar.
///
/// Standard placement: `Positioned(right: 1, bottom: 1, child: OnlineDot())`
class OnlineDot extends StatelessWidget {
  final double size;

  const OnlineDot({super.key, this.size = 11});

  @override
  Widget build(BuildContext context) {
    return Container(
      width:  size,
      height: size,
      decoration: BoxDecoration(
        color:  AppColors.online,
        shape:  BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
    );
  }
}
