import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/routes/app_routes.dart';
import 'features/chat/controllers/message_controller.dart';
import 'features/chat/screens/chat_view.dart';
import 'features/home/screens/main_navigation_screen.dart';
import 'features/profile/controllers/profile_controller.dart';
import 'features/profile/edit_profile_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: BindingsBuilder(() {
        Get.put(ProfileController());
      }),
      home: const MainNavigationScreen(),
      getPages: [
        GetPage(name: AppRoutes.editProfile, page: () => const EditProfileView()),
        GetPage(
          name: AppRoutes.chatView,
          page: () => const ChatView(),
          binding: BindingsBuilder(() { Get.put(DirectController()); }),
        ),
      ],
    );
  }
}
