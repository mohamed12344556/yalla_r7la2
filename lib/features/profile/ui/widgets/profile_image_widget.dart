import 'dart:io';

import 'package:flutter/material.dart';
import 'package:p1/core/utils/image_helper.dart';
import 'package:p1/features/profile/data/models/user_model.dart';

class ProfileImageWidget extends StatelessWidget {
  final UserModel? user;
  final File? cachedImage;
  final File? selectedImage;
  final double radius;
  final VoidCallback? onTap;

  const ProfileImageWidget({
    super.key,
    this.user,
    this.cachedImage,
    this.selectedImage,
    this.radius = 60,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: radius,
        backgroundImage: _getImageProvider(),
        child:
            _getImageProvider() == null
                ? Icon(Icons.person, size: radius)
                : null,
      ),
    );
  }

  ImageProvider? _getImageProvider() {
    // أولوية للصورة المحددة
    if (selectedImage != null) {
      return FileImage(selectedImage!);
    }

    // الصورة المحفوظة محلياً
    if (cachedImage?.existsSync() == true) {
      return FileImage(cachedImage!);
    }

    // معالجة البيانات من الـ API
    if (user?.imageBytes != null) {
      return MemoryImage(user!.imageBytes!);
    }

    // URL image
    if (user?.imageData != null &&
        user!.imageData!.isNotEmpty &&
        user!.imageData!.startsWith('http')) {
      return NetworkImage(user!.imageData!);
    }

    // Base64 image
    if (user?.imageData != null && user!.imageData!.isNotEmpty) {
      try {
        final bytes = ImageHelper.base64ToBytes(user!.imageData!);
        return MemoryImage(bytes);
      } catch (e) {
        print('Error loading base64 image: $e');
      }
    }

    return null;
  }
}
