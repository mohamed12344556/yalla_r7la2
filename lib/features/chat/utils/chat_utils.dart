import 'package:flutter/material.dart';

class ChatUtils {
  static String formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return "الآن";
    } else if (difference.inHours < 1) {
      return "منذ ${difference.inMinutes} دقيقة";
    } else if (difference.inDays < 1) {
      return "منذ ${difference.inHours} ساعة";
    } else {
      return "${timestamp.day}/${timestamp.month}";
    }
  }

  static void scrollToBottom(ScrollController controller) {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (controller.hasClients) {
        controller.animateTo(
          controller.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
}
