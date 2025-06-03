import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:p1/core/api/api_constants.dart';
import 'package:p1/core/cache/shared_pref_helper.dart';
import 'package:p1/core/routes/routes.dart';
import 'package:p1/core/utils/extensions.dart';
import 'package:p1/core/utils/image_helper.dart';
import 'package:p1/core/widgets/app_loading_indicator.dart';
import 'package:p1/features/profile/data/models/user_model.dart';
import 'package:p1/features/profile/ui/logic/profile_cubit.dart';
import 'package:p1/features/profile/ui/logic/profile_state.dart';

class ProfileViewScreen extends StatefulWidget {
  const ProfileViewScreen({super.key});

  @override
  State<ProfileViewScreen> createState() => _ProfileViewScreenState();
}

class _ProfileViewScreenState extends State<ProfileViewScreen> {
  bool _notificationsEnabled = true;
  bool _isDarkMode = false;
  final bool _hasLoadedProfile = false;
  File? _selectedImage;

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   // Load profile data only once when dependencies are available
  //   if (!_hasLoadedProfile && mounted) {
  //     final cubit = context.read<ProfileCubit>();
  //     if (!cubit.isClosed) {
  //       cubit.loadUserProfile();
  //       _hasLoadedProfile = true;
  //     }
  //   }
  // }

  @override
  void initState() {
    super.initState();
    final cubit = context.read<ProfileCubit>();
    if (!cubit.isClosed) {
      cubit.loadUserProfile();
    }
  }

  // دالة الـ refresh
  Future<void> _onRefresh() async {
    if (!mounted) return;

    try {
      final cubit = context.read<ProfileCubit>();
      // التحقق من أن الـ cubit لم يتم إغلاقه
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
        border: Border.all(color: Colors.white, width: 4),
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
        radius: 60,
        backgroundColor: Colors.grey[300],
        backgroundImage: _getProfileImageProvider(user, cachedImage),
        child:
            _getProfileImageProvider(user, cachedImage) == null
                ? const Icon(Icons.person, size: 40, color: Colors.grey)
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
        // إزالة البادئة إن وجدت
        if (base64String.contains(',')) {
          base64String = base64String.split(',')[1];
        }
        final bytes = base64Decode(base64String);
        return MemoryImage(bytes);
      } catch (e) {
        print('خطأ في فك تشفير Base64: $e');
      }
    }

    // 5. لا توجد صورة
    return null;
  }

  ImageProvider _getProfileImage() {
    final user = context.read<ProfileCubit>().currentUser;
    final cachedImage = context.read<ProfileCubit>().cachedProfileImage;

    // 1. أولوية للصورة المحددة محلياً
    if (_selectedImage != null) {
      return FileImage(_selectedImage!);
    }

    // 2. الصورة المحفوظة محلياً
    if (cachedImage != null && cachedImage.existsSync()) {
      return FileImage(cachedImage);
    }

    // 3. معالجة البيانات من الـ API
    if (user?.imageBytes != null) {
      return MemoryImage(user!.imageBytes!);
    }

    // 4. إذا كانت الصورة URL
    if (user?.imageData != null &&
        user!.imageData!.isNotEmpty &&
        user.imageData!.startsWith('http')) {
      return NetworkImage(user.imageData!);
    }

    // 5. إذا كانت الصورة Base64
    if (user?.imageData != null && user!.imageData!.isNotEmpty) {
      try {
        final bytes = ImageHelper.base64ToBytes(user.imageData!);
        return MemoryImage(bytes);
      } catch (e) {
        log('Error loading base64 image: $e');
      }
    }

    // 6. الصورة الافتراضية
    return const AssetImage('assets/default_profile.png');
  }

  Future<void> _showImageSourceDialog() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Select Profile Photo',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildImageSourceOption(
                      icon: Icons.camera_alt,
                      label: 'Camera',
                      onTap: () {
                        Navigator.pop(context);
                        context.read<ProfileCubit>().pickAndCacheProfileImage(
                          source: ImageSource.camera,
                        );
                      },
                    ),
                    _buildImageSourceOption(
                      icon: Icons.photo_library,
                      label: 'Gallery',
                      onTap: () {
                        Navigator.pop(context);
                        context.read<ProfileCubit>().pickAndCacheProfileImage(
                          source: ImageSource.gallery,
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildImageSourceOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: const Color(0xFF30B0C7)),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Logout'),
            content: const Text('Are you sure you want to logout?'),
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

      // Clear cached data
      await SharedPrefHelper.clearAllData();
      await SharedPrefHelper.clearAllSecuredData();

      // Clear profile cache - التحقق من أن الـ cubit لم يتم إغلاقه
      final cubit = context.read<ProfileCubit>();
      if (!cubit.isClosed) {
        cubit.reset();
      }

      if (mounted) {
        context.showSuccessSnackBar("Logged out successfully");

        // Navigate to login
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
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
              color: const Color(0xFF30B0C7).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: const Color(0xFF30B0C7), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: const Color(0xFF30B0C7),
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
              // Navigate using named route instead of direct MaterialPageRoute
              // This ensures the ProfileCubit context is maintained
              Navigator.pushNamed(context, Routes.editProfile);
            },
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => context.pushNamed(Routes.host),
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
            color: const Color(0xFF30B0C7),
            backgroundColor: Colors.white,
            child: SingleChildScrollView(
              physics:
                  const AlwaysScrollableScrollPhysics(), // يضمن إمكانية السحب دائماً
              child: Column(
                children: [
                  // Profile Header Section
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color(0xFF30B0C7),
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
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(0xFF30B0C7),
                                    width: 2,
                                  ),
                                ),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.camera_alt,
                                    color: Color(0xFF30B0C7),
                                    size: 20,
                                  ),
                                  onPressed: _showImageSourceDialog,
                                ),
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
                        const Text(
                          'Personal Information',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 12),

                        if (user?.name != null && user!.name!.isNotEmpty)
                          _buildInfoCard(
                            icon: Icons.person,
                            title: 'Username',
                            subtitle: user.name!,
                          ),

                        if (user?.age != null)
                          _buildInfoCard(
                            icon: Icons.cake,
                            title: 'Date of Birth',
                            subtitle: user?.age?.toString() ?? 'N/A',
                          ),

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
                            subtitle: '${user!.age} years old',
                          ),

                        if (user?.prefrance != null &&
                            user!.prefrance!.isNotEmpty)
                          _buildInfoCard(
                            icon: Icons.favorite,
                            title: 'Preferred City',
                            subtitle: user.prefrance!,
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Settings Section
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            "Settings",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.black87,
                            ),
                          ),
                        ),

                        SwitchListTile(
                          title: const Text("Push Notifications"),
                          subtitle: const Text("Receive app notifications"),
                          value: _notificationsEnabled,
                          activeColor: const Color(0xFF30B0C7),
                          onChanged: (value) {
                            setState(() {
                              _notificationsEnabled = value;
                            });
                          },
                        ),

                        ListTile(
                          title: const Text("Language"),
                          subtitle: const Text("App language preference"),
                          trailing: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "English",
                                style: TextStyle(color: Colors.grey),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.chevron_right, color: Colors.grey),
                            ],
                          ),
                          onTap: () {
                            // Handle language selection
                          },
                        ),

                        SwitchListTile(
                          title: const Text("Dark Mode"),
                          subtitle: const Text("Switch to dark theme"),
                          value: _isDarkMode,
                          activeColor: const Color(0xFF30B0C7),
                          onChanged: (value) {
                            setState(() {
                              _isDarkMode = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Account Section
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            "Account",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.black87,
                            ),
                          ),
                        ),

                        ListTile(
                          leading: const Icon(
                            Icons.privacy_tip,
                            color: Color(0xFF30B0C7),
                          ),
                          title: const Text("Privacy Policy"),
                          trailing: const Icon(
                            Icons.chevron_right,
                            color: Colors.grey,
                          ),
                          onTap: () {
                            // Navigate to privacy policy
                          },
                        ),

                        ListTile(
                          leading: const Icon(
                            Icons.description,
                            color: Color(0xFF30B0C7),
                          ),
                          title: const Text("Terms of Service"),
                          trailing: const Icon(
                            Icons.chevron_right,
                            color: Colors.grey,
                          ),
                          onTap: () {
                            // Navigate to terms of service
                          },
                        ),

                        ListTile(
                          leading: const Icon(
                            Icons.help,
                            color: Color(0xFF30B0C7),
                          ),
                          title: const Text("Help & Support"),
                          trailing: const Icon(
                            Icons.chevron_right,
                            color: Colors.grey,
                          ),
                          onTap: () {
                            // Navigate to help & support
                          },
                        ),

                        ListTile(
                          leading: const Icon(Icons.logout, color: Colors.red),
                          title: const Text(
                            "Log out",
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          onTap: _handleLogout,
                        ),
                      ],
                    ),
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
}
