import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

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

            /// HEART
            _topIcon(
              CupertinoIcons.heart,
            ),

            const SizedBox(width: 18),

            /// CHAT
            _topIcon(
              CupertinoIcons.chat_bubble,
            ),
          ],
        ),
      ),
    );
  }

  Widget _topIcon(
      IconData icon,
      ) {

    return Icon(
      icon,

      size: 26,

      color: Colors.black87,
    );
  }
}