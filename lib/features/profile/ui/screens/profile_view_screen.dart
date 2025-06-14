import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/api/api_constants.dart';
import '../../../../core/cache/shared_pref_helper.dart';
import '../../../../core/di/dependency_injection.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/themes/app_colors.dart'; // تأكد من import الصحيح
import '../../../../core/themes/cubit/locale_cubit.dart';
import '../../../../core/themes/cubit/theme_cubit.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/image_helper.dart';
import '../../../../core/widgets/app_loading_indicator.dart';
import '../../../../core/widgets/app_update_widget.dart';
import '../../../../core/widgets/language_selection_dialog.dart';
import '../../../../generated/l10n.dart';
import '../../data/models/user_model.dart';
import '../logic/profile_cubit.dart';
import '../logic/profile_state.dart';

class ProfileViewScreen extends StatefulWidget {
  const ProfileViewScreen({super.key});

  @override
  State<ProfileViewScreen> createState() => _ProfileViewScreenState();
}

class _ProfileViewScreenState extends State<ProfileViewScreen> {
  bool _notificationsEnabled = false;
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<ProfileCubit>();
    if (!cubit.isClosed) {
      cubit.loadUserProfile();
    }
  }

  // دالة حساب العمر
  int calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    int age = now.year - birthDate.year;

    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }

    return age;
  }

  // دالة تحويل العمر إلى تاريخ ميلاد تقريبي
  DateTime? getBirthDateFromAge(int? age) {
    if (age == null || age <= 0) return null;

    final now = DateTime.now();
    return DateTime(now.year - age, 1, 1);
  }

  // دالة تنسيق عرض العمر
  String formatAgeDisplay(UserModel? user) {
    if (user?.age != null && user!.age! > 0) {
      final birthDate = getBirthDateFromAge(user.age);
      if (birthDate != null) {
        final calculatedAge = calculateAge(birthDate);
        return '$calculatedAge years old';
      }
    }
    return 'Age not specified';
  }

  // دالة تنسيق عرض تاريخ الميلاد
  String formatBirthDateDisplay(UserModel? user) {
    if (user?.age != null && user!.age! > 0) {
      final birthDate = getBirthDateFromAge(user.age);
      if (birthDate != null) {
        return '${birthDate.year}';
      }
    }
    return 'Not specified';
  }

  // دالة الـ refresh
  Future<void> _onRefresh() async {
    if (!mounted) return;

    try {
      final cubit = context.read<ProfileCubit>();
      if (!cubit.isClosed) {
        await cubit.loadUserProfile();
      }
    } catch (e) {
      if (mounted) {
        context.showErrorSnackBar("Failed to refresh profile: $e");
      }
    }
  }

  // دالة محسنة لعرض الصورة
  Widget _buildProfileImage() {
    final user = context.read<ProfileCubit>().currentUser;
    final cachedImage = context.read<ProfileCubit>().cachedProfileImage;

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Theme.of(context).colorScheme.surface,
          width: 4,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: CircleAvatar(
        radius: 60,
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        backgroundImage: _getProfileImageProvider(user, cachedImage),
        child:
            _getProfileImageProvider(user, cachedImage) == null
                ? Icon(
                  Icons.person,
                  size: 40,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                )
                : null,
      ),
    );
  }

  ImageProvider? _getProfileImageProvider(UserModel? user, File? cachedImage) {
    // 1. الملف المحفوظ محلياً
    if (cachedImage != null && cachedImage.existsSync()) {
      return FileImage(cachedImage);
    }

    // 2. البيانات من الـ API (bytes)
    if (user?.imageBytes != null && user!.imageBytes!.isNotEmpty) {
      return MemoryImage(user.imageBytes!);
    }

    // 3. رابط الصورة
    if (user?.imageData != null &&
        user!.imageData!.isNotEmpty &&
        (user.imageData!.startsWith('http') ||
            user.imageData!.startsWith('https'))) {
      return NetworkImage(user.imageData!);
    }

    // 4. Base64 string
    if (user?.imageData != null && user!.imageData!.isNotEmpty) {
      try {
        String base64String = user.imageData!;
        if (base64String.contains(',')) {
          base64String = base64String.split(',')[1];
        }
        final bytes = base64Decode(base64String);
        return MemoryImage(bytes);
      } catch (e) {
        print('خطأ في فك تشفير Base64: $e');
      }
    }

    return null;
  }

  ImageProvider _getProfileImage() {
    final user = context.read<ProfileCubit>().currentUser;
    final cachedImage = context.read<ProfileCubit>().cachedProfileImage;

    // إذا كانت الصورة URL
    if (user?.imageData != null &&
        user!.imageData!.isNotEmpty &&
        user.imageData!.startsWith('http')) {
      return NetworkImage(user.imageData!);
    }

    // إذا كانت الصورة Base64
    if (user?.imageData != null && user!.imageData!.isNotEmpty) {
      try {
        final bytes = ImageHelper.base64ToBytes(user.imageData!);
        return MemoryImage(bytes);
      } catch (e) {
        log('Error loading base64 image: $e');
      }
    }

    // Default image
    return const AssetImage('assets/default_profile.png');
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Theme.of(context).colorScheme.surface,
            title: Text(
              'Logout',
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
            content: Text(
              'Are you sure you want to logout?',
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _performLogout();
                },
                child: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }

  void _performLogout() async {
    if (!mounted) return;

    try {
      log(
        "Logging out : ${await SharedPrefHelper.getSecuredString(SharedPrefKeys.token)}",
      );

      await SharedPrefHelper.clearAllData();
      await SharedPrefHelper.clearAllSecuredData();

      final cubit = context.read<ProfileCubit>();
      if (!cubit.isClosed) {
        cubit.reset();
      }

      if (mounted) {
        context.showSuccessSnackBar("Logged out successfully");

        context.pushNamedAndRemoveUntil(
          Routes.login,
          predicate: (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        context.showErrorSnackBar("Error during logout: $e");
      }
    }
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:
            isDarkMode
                ? AppColors.surfaceContainerDark
                : AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color:
                        isDarkMode
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color:
                        isDarkMode
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsContainer({
    required String title,
    required List<Widget> children,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color:
            isDarkMode
                ? AppColors.surfaceContainerDark
                : AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color:
                    isDarkMode
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimary,
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDarkMode ? AppColors.backgroundDark : AppColors.background,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.primary,
        centerTitle: true,
        title: const Text(
          "My Profile",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        toolbarHeight: 80,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, Routes.editProfile).then((value) {
                if (value != null) {
                  context.read<ProfileCubit>().loadUserProfile();
                }
              });
            },
          ),
        ],
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
          onPressed:
              () => context.pushNamedAndRemoveUntil(
                Routes.host,
                predicate: (route) => false,
              ),
        ),
      ),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileError) {
            context.showErrorSnackBar(state.message);
          } else if (state is ProfileUpdated) {
            context.showSuccessSnackBar(state.message);
          } else if (state is ProfileImageUploaded) {
            context.showSuccessSnackBar(state.message);
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(
              child: AppLoadingIndicator(showBackground: true),
            );
          }

          final cubit = context.read<ProfileCubit>();
          final user = cubit.currentUser;
          final cachedImage = cubit.cachedProfileImage;

          return RefreshIndicator(
            onRefresh: _onRefresh,
            color: AppColors.primary,
            backgroundColor:
                isDarkMode
                    ? AppColors.surfaceContainerDark
                    : AppColors.surfaceContainer,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  // Profile Header Section
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),

                        // Profile Image Section
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 4,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    spreadRadius: 2,
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: CircleAvatar(
                                radius: 70,
                                backgroundImage: _getProfileImage(),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // User Name and Email
                        Text(
                          user?.name != null ? user!.name! : 'Your Name',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          user?.email ?? 'your.email@example.com',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),

                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Personal Information Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Personal Information',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color:
                                isDarkMode
                                    ? AppColors.textPrimaryDark
                                    : AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),

                        if (user?.name != null && user!.name!.isNotEmpty)
                          _buildInfoCard(
                            icon: Icons.person,
                            title: 'Username',
                            subtitle: user.name!,
                          ),

                        // if (user?.age != null)
                        //   _buildInfoCard(
                        //     icon: Icons.cake,
                        //     title: 'Date of Birth',
                        //     subtitle: formatBirthDateDisplay(user),
                        //   ),
                        if (user?.city != null && user!.city!.isNotEmpty)
                          _buildInfoCard(
                            icon: Icons.location_on,
                            title: 'City',
                            subtitle: user.city!,
                          ),

                        if (user?.age != null)
                          _buildInfoCard(
                            icon: Icons.calendar_today,
                            title: 'Age',
                            subtitle: formatAgeDisplay(user),
                          ),

                        if (user?.preference != null &&
                            user!.preference!.isNotEmpty)
                          _buildInfoCard(
                            icon: Icons.favorite,
                            title: 'Preferred City',
                            subtitle: user.preference!,
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Settings Section
                  _buildSettingsContainer(
                    title: "Settings",
                    children: [
                      SwitchListTile(
                        title: Text(
                          S.of(context).Push_Notifications,
                          style: TextStyle(
                            color:
                                isDarkMode
                                    ? AppColors.textPrimaryDark
                                    : AppColors.textPrimary,
                          ),
                        ),
                        subtitle: Text(
                          "Receive app notifications",
                          style: TextStyle(
                            color:
                                isDarkMode
                                    ? AppColors.textSecondaryDark
                                    : AppColors.textSecondary,
                          ),
                        ),
                        value: _notificationsEnabled,
                        activeColor: AppColors.primary,
                        onChanged: (value) {
                          setState(() {
                            _notificationsEnabled = value;
                          });
                          if (value) {
                            context.showComingSoonFeature();
                          }
                        },
                      ),

                      ListTile(
                        leading: Icon(Icons.language, color: AppColors.primary),
                        title: Text(
                          "Language",
                          style: TextStyle(
                            color:
                                isDarkMode
                                    ? AppColors.textPrimaryDark
                                    : AppColors.textPrimary,
                          ),
                        ),
                        subtitle: Text(
                          "App language preference",
                          style: TextStyle(
                            color:
                                isDarkMode
                                    ? AppColors.textSecondaryDark
                                    : AppColors.textSecondary,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            BlocBuilder<LocaleCubit, Locale>(
                              builder: (context, locale) {
                                final currentLanguageName =
                                    context
                                        .read<LocaleCubit>()
                                        .getCurrentLanguageDisplayName();

                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    currentLanguageName,
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              Icons.chevron_right,
                              color:
                                  isDarkMode
                                      ? AppColors.textSecondaryDark
                                      : AppColors.textSecondary,
                            ),
                          ],
                        ),
                        onTap: () {
                          LanguageSelectionDialog.show(context);
                        },
                      ),

                      BlocBuilder<ThemeCubit, ThemeMode>(
                        bloc: sl<ThemeCubit>(),
                        builder: (context, themeMode) {
                          final isDarkMode =
                              themeMode == ThemeMode.dark ||
                              (themeMode == ThemeMode.system &&
                                  MediaQuery.of(context).platformBrightness ==
                                      Brightness.dark);

                          return SwitchListTile(
                            title: Text(
                              "Dark Mode",
                              style: TextStyle(
                                color:
                                    Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? AppColors.textPrimaryDark
                                        : AppColors.textPrimary,
                              ),
                            ),
                            subtitle: Text(
                              themeMode == ThemeMode.system
                                  ? "Following system theme (${isDarkMode ? 'Dark' : 'Light'})"
                                  : "Switch to ${isDarkMode ? 'light' : 'dark'} theme",
                              style: TextStyle(
                                color:
                                    Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? AppColors.textSecondaryDark
                                        : AppColors.textSecondary,
                              ),
                            ),
                            value: isDarkMode,
                            activeColor: AppColors.primary,
                            onChanged: (value) {
                              sl<ThemeCubit>().changeTheme(
                                value ? ThemeMode.dark : ThemeMode.light,
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Account Section
                  _buildSettingsContainer(
                    title: "Account",
                    children: [
                      _buildAccountListTile(
                        icon: Icons.privacy_tip,
                        title: "Privacy Policy",
                        onTap: () {
                          // Navigate to privacy policy
                        },
                      ),

                      _buildAccountListTile(
                        icon: Icons.description,
                        title: "Terms of Service",
                        onTap: () {
                          // Navigate to terms of service
                        },
                      ),

                      _buildAccountListTile(
                        icon: Icons.help,
                        title: "Help & Support",
                        onTap: () {
                          // Navigate to help & support
                        },
                      ),

                      const AppUpdateWidget(),

                      ListTile(
                        leading: const Icon(
                          Icons.logout,
                          color: AppColors.error,
                        ),
                        title: Text(
                          "Log out",
                          style: TextStyle(
                            color: AppColors.error,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onTap: _handleLogout,
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAccountListTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(
        title,
        style: TextStyle(
          color: isDarkMode ? AppColors.textPrimaryDark : AppColors.textPrimary,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color:
            isDarkMode ? AppColors.textSecondaryDark : AppColors.textSecondary,
      ),
      onTap: onTap,
    );
  }
}
