import 'package:flutter/material.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';

class AutoUpdateChecker {
  static final ShorebirdUpdater _updater = ShorebirdUpdater();

  // فحص التحديثات تلقائياً عند فتح التطبيق
  static Future<void> checkForUpdatesOnStartup(BuildContext context) async {
    // انتظار قليل لضمان تحميل التطبيق بالكامل
    await Future.delayed(const Duration(seconds: 2));

    try {
      final status = await _updater.checkForUpdate();

      if (status == UpdateStatus.outdated) {
        // إظهار dialog للمستخدم
        _showUpdateDialog(context);
      }
    } catch (e) {
      debugPrint('Error checking for updates on startup: $e');
      // لا نظهر خطأ للمستخدم هنا لأنه فحص تلقائي
    }
  }

  // إظهار dialog التحديث
  static void _showUpdateDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // منع إغلاق الـ dialog بالضغط خارجه
      builder: (BuildContext context) {
        return const UpdateDialog();
      },
    );
  }
}

class UpdateDialog extends StatefulWidget {
  const UpdateDialog({super.key});

  @override
  State<UpdateDialog> createState() => _UpdateDialogState();
}

class _UpdateDialogState extends State<UpdateDialog>
    with SingleTickerProviderStateMixin {
  bool _isUpdating = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _downloadUpdate() async {
    setState(() {
      _isUpdating = true;
    });

    try {
      final updater = ShorebirdUpdater();
      await updater.update();

      // التحديث تم بنجاح
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('تم تحديث التطبيق بنجاح! 🎉'),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } on UpdateException catch (e) {
      debugPrint('Update failed: ${e.message}');
      if (mounted) {
        setState(() {
          _isUpdating = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(child: Text('فشل التحديث: ${e.message}')),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      debugPrint('Unexpected error during update: $e');
      if (mounted) {
        setState(() {
          _isUpdating = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.error, color: Colors.white),
                SizedBox(width: 8),
                Text('حدث خطأ غير متوقع أثناء التحديث'),
              ],
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // أيقونة التحديث مع حركة دوران
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFF30B0C7).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.system_update_alt,
                size: 40,
                color: Color(0xFF30B0C7),
              ),
            ),

            const SizedBox(height: 20),

            // عنوان
            const Text(
              'تحديث متاح! 🚀',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 12),

            // رسالة التحديث
            const Text(
              'يتوفر تحديث جديد للتطبيق يتضمن تحسينات وميزات جديدة.\nهل تريد تحميله الآن؟',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 24),

            // أزرار الإجراءات
            Row(
              children: [
                // زر لاحقاً
                Expanded(
                  child: OutlinedButton(
                    onPressed:
                        _isUpdating
                            ? null
                            : () {
                              Navigator.of(context).pop();
                            },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.grey.shade600,
                      side: BorderSide(color: Colors.grey.shade300),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'لاحقاً',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // زر التحديث
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isUpdating ? null : _downloadUpdate,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF30B0C7),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child:
                        _isUpdating
                            ? const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text('تحديث...'),
                              ],
                            )
                            : const Text(
                              'تحديث الآن',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
