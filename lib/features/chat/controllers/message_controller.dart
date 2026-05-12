import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DirectMessage {
  final String text;
  final bool isMe;
  DirectMessage({required this.text, required this.isMe});
}

class DirectController extends GetxController {
  final messages = <DirectMessage>[].obs;
  final messageController = TextEditingController();

  @override
  void onClose() {
    messageController.dispose();
    super.onClose();
  }

  void sendMessage() {
    final text = messageController.text.trim();
    if (text.isEmpty) return;
    messages.add(DirectMessage(text: text, isMe: true));
    messageController.clear();
  }
}
