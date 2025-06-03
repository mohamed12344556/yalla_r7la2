import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

class ImageHelper {
  // تحويل bytes إلى base64
  static String bytesToBase64(Uint8List bytes) {
    return base64Encode(bytes);
  }

  // تحويل base64 إلى bytes
  static Uint8List base64ToBytes(String base64String) {
    // إزالة prefix إذا كان موجود
    String cleanBase64 = base64String;
    if (base64String.contains(',')) {
      cleanBase64 = base64String.split(',')[1];
    }
    return base64Decode(cleanBase64);
  }

  // حفظ bytes كملف مؤقت
  static Future<File> saveBytesToTempFile(
    Uint8List bytes, {
    String fileName = 'temp_image.jpg',
  }) async {
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/$fileName');
    await file.writeAsBytes(bytes);
    return file;
  }

  // حفظ bytes في documents directory
  static Future<File> saveBytesToFile(Uint8List bytes, String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final profileDir = Directory('${directory.path}/profile');

    if (!await profileDir.exists()) {
      await profileDir.create(recursive: true);
    }

    final file = File('${profileDir.path}/$fileName');
    await file.writeAsBytes(bytes);
    return file;
  }
}
