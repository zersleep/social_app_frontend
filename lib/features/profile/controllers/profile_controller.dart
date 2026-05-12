import 'package:get/get.dart';

class ProfileUser {
  final String username;
  ProfileUser({required this.username});
}

class ProfileController extends GetxController {
  final isLoading = false.obs;
  final user = Rx<ProfileUser?>(ProfileUser(username: 'TkVisalsak'));
  final bio = 'Living the dream ✨'.obs;
  final website = 'visalsak.dev'.obs;
  final name = 'Visalsak'.obs;

  void updateProfile() {
    Get.back();
  }
}
