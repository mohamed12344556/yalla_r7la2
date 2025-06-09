import 'package:flutter/material.dart';
import '../utils/extensions.dart';
import '../utils/shorebird_update_service.dart';
import 'app_loading_indicator.dart';

class AppUpdateWidget extends StatefulWidget {
  const AppUpdateWidget({super.key});

  @override
  State<AppUpdateWidget> createState() => _AppUpdateWidgetState();
}

class _AppUpdateWidgetState extends State<AppUpdateWidget> {
  bool _isChecking = false;
  bool _isUpdating = false;
  bool _hasUpdate = false;
  String? _currentPatch;

  @override
  void initState() {
    super.initState();
    _loadCurrentPatch();
  }

  Future<void> _loadCurrentPatch() async {
    final patch = await ShorebirdUpdateService.getCurrentPatchNumber();
    setState(() {
      _currentPatch = patch;
    });
  }

  Future<void> _checkForUpdates() async {
    setState(() {
      _isChecking = true;
      _hasUpdate = false;
    });

    try {
      final hasUpdate = await ShorebirdUpdateService.checkForUpdates();
      setState(() {
        _hasUpdate = hasUpdate;
        _isChecking = false;
      });

      if (hasUpdate) {
        context.showSuccessSnackBar('تحديث جديد متاح!');
      } else {
        context.showSnackBar('التطبيق محدث بالفعل ✅');
      }
    } catch (e) {
      setState(() {
        _isChecking = false;
      });
      context.showErrorSnackBar('حدث خطأ أثناء فحص التحديثات');
    }
  }

  Future<void> _downloadUpdate() async {
    setState(() {
      _isUpdating = true;
    });

    try {
      final success = await ShorebirdUpdateService.downloadAndInstallUpdate();

      if (success) {
        context.showSuccessSnackBar('تم تحديث التطبيق بنجاح! 🎉');
        setState(() {
          _hasUpdate = false;
        });
        // إعادة تحميل رقم الإصدار الحالي
        await _loadCurrentPatch();
      } else {
        context.showErrorSnackBar('فشل في تحديث التطبيق');
      }
    } catch (e) {
      context.showErrorSnackBar('حدث خطأ أثناء التحديث');
    } finally {
      setState(() {
        _isUpdating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF30B0C7).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.system_update,
                  color: Color(0xFF30B0C7),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'تحديثات التطبيق',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Current Version Info
          if (_currentPatch != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.grey.shade600,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'الإصدار الحالي: $_currentPatch',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Update Status
          if (_hasUpdate) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.new_releases,
                    color: Colors.green.shade600,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'تحديث جديد متاح للتحميل',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.green,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Action Buttons
          Row(
            children: [
              // Check for Updates Button
              Expanded(
                child: OutlinedButton.icon(
                  onPressed:
                      _isChecking || _isUpdating ? null : _checkForUpdates,
                  icon:
                      _isChecking
                          ? AppLoadingIndicator()
                          : const Icon(Icons.search),
                  label: Text(_isChecking ? 'فحص...' : 'فحص التحديثات'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF30B0C7),
                    side: const BorderSide(color: Color(0xFF30B0C7)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),

              if (_hasUpdate) ...[
                const SizedBox(width: 12),
                // Download Update Button
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isUpdating ? null : _downloadUpdate,
                    icon:
                        _isUpdating
                            ? AppLoadingIndicator()
                            : const Icon(Icons.download),
                    label: Text(_isUpdating ? 'تحديث...' : 'تحميل'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF30B0C7),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
