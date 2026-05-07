import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          /// LEFT PLUS BUTTON
          GestureDetector(
            onTap: () {

              /// popup later

            },
            child: const Icon(
              Icons.add,
              size: 34,
            ),
          ),

          /// APP NAME
          Text(
            "Social app",
            style: GoogleFonts.cookie(
              fontSize: 42,
              color: Colors.black,
            ),
          ),

          /// NOTIFICATION BUTTON
          Stack(
            children: [

              GestureDetector(
                onTap: () {

                  /// notifications later

                },
                child: const Icon(
                  Icons.crop_square_rounded,
                  size: 34,
                ),
              ),

              /// RED DOT
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}