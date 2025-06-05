import 'package:flutter/material.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';

class ShorebirdUpdateService {
  static final ShorebirdUpdater _updater = ShorebirdUpdater();

  // فحص وجود تحديثات جديدة
  static Future<bool> checkForUpdates() async {
    try {
      final status = await _updater.checkForUpdate();
      return status == UpdateStatus.outdated;
    } catch (e) {
      debugPrint('Error checking for updates: $e');
      return false;
    }
  }

  // تحميل وتطبيق التحديث
  static Future<bool> downloadAndInstallUpdate() async {
    try {
      await _updater.update();
      return true;
    } on UpdateException catch (e) {
      debugPrint('Update failed: ${e.message}');
      return false;
    } catch (e) {
      debugPrint('Unexpected error during update: $e');
      return false;
    }
  }

  // الحصول على رقم الإصدار الحالي
  static Future<String?> getCurrentPatchNumber() async {
    try {
      final currentPatch = await _updater.readCurrentPatch();
      return currentPatch?.number.toString();
    } catch (e) {
      debugPrint('Error reading current patch: $e');
      return null;
    }
  }
}
