import 'package:flutter/material.dart';
import 'package:social_test/features/home/widgets/home_appbar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [

            /// CUSTOM APPBAR
            const HomeAppBar(),

          ]
        ),
      ),
    );
  }
}