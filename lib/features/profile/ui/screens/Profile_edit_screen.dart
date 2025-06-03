import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:p1/core/utils/extensions.dart';
import 'package:p1/core/utils/image_helper.dart';
import 'package:p1/core/widgets/app_loading_indicator.dart';
import 'package:p1/features/profile/ui/logic/profile_cubit.dart';
import 'package:p1/features/profile/ui/logic/profile_state.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();

  // Text Controllers

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _cityController = TextEditingController();
  final _preferenceCityController = TextEditingController();
  final _birthDateController = TextEditingController();

  String? _selectedGender;
  DateTime? _selectedDate;
  File? _selectedImage;
  final bool _isImageUploading = false;

  // final List<String> _genderOptions = ['Male', 'Female', 'Other'];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final user = context.read<ProfileCubit>().currentUser;
    if (user != null) {
      _nameController.text = user.name ?? '';
      _emailController.text = user.email ?? '';
      _phoneController.text = user.phoneNumber?.toString() ?? '';
      _cityController.text = user.city ?? '';
      _preferenceCityController.text = user.prefrance ?? '';
      // حط الباسورد الحالي (لو موجود)
      _passwordController.text = user.password?.toString() ?? '';

      // Handle age/birthdate logic properly
      if (user.age != null && user.age! > 0) {
        final currentYear = DateTime.now().year;
        final birthYear = currentYear - user.age!;
        _selectedDate = DateTime(birthYear, 1, 1);
        _birthDateController.text =
            _selectedDate!.toLocal().toString().split(' ')[0];
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _cityController.dispose();
    _preferenceCityController.dispose();
    _birthDateController.dispose();
    _passwordController.dispose(); // ضروري للباسورد
    super.dispose();
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
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handle bar
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 20),

                  const Text(
                    'Select Profile Photo',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 25),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildImageSourceOption(
                        icon: Icons.camera_alt,
                        label: 'Camera',
                        onTap: () {
                          Navigator.pop(context);
                          _pickImage();
                        },
                      ),
                      _buildImageSourceOption(
                        icon: Icons.photo_library,
                        label: 'Gallery',
                        onTap: () {
                          Navigator.pop(context);
                          _pickImage();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                ],
              ),
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
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          color: const Color(0xFF30B0C7).withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFF30B0C7).withOpacity(0.2),
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF30B0C7).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 28, color: const Color(0xFF30B0C7)),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF30B0C7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Future<void> _pickImage(ImageSource source) async {
  //   try {
  //     final picker = ImagePicker();
  //     final pickedFile = await picker.pickImage(
  //       source: source,
  //       maxWidth: 1024,
  //       maxHeight: 1024,
  //       imageQuality: 85,
  //     );

  //     if (pickedFile != null) {
  //       setState(() {
  //         _selectedImage = File(pickedFile.path);
  //       });
  //     }
  //   } catch (e) {
  //     if (mounted) {
  //       context.showErrorSnackBar('Failed to pick image: ${e.toString()}');
  //     }
  //   }
  // }
  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80, // Compress image to reduce file size
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });

        // Validate the picked image
        final fileSize = await _selectedImage!.length();
        if (fileSize > 5 * 1024 * 1024) {
          setState(() {
            _selectedImage = null;
          });
          context.showErrorSnackBar(
            'Image file is too large. Please select an image smaller than 5MB',
          );
        }
      }
    } catch (e) {
      context.showErrorSnackBar('Failed to pick image: ${e.toString()}');
    }
  }

  Future<void> _selectBirthDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now().subtract(
        const Duration(days: 365 * 13),
      ), // Min 13 years old
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: const Color(0xFF30B0C7),
              onPrimary: Colors.white,
              surface: Colors.white,
            ),
            dialogTheme: DialogThemeData(backgroundColor: Colors.white),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _birthDateController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    bool obscureText = false,
    bool readOnly = false,
    VoidCallback? onTap,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    Widget? suffixIcon,
    String? hintText,
    int? maxLength,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          readOnly: readOnly,
          onTap: onTap,
          keyboardType: keyboardType,
          validator: validator,
          maxLength: maxLength,
          style: const TextStyle(fontSize: 16),
          decoration: InputDecoration(
            hintText: hintText,
            suffixIcon: suffixIcon,
            counterText: '', // Hide character counter
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Color(0xFF30B0C7), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Colors.red, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }

  // Widget _buildGenderDropdown() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       const Text(
  //         'Gender',
  //         style: TextStyle(
  //           fontSize: 16,
  //           fontWeight: FontWeight.w600,
  //           color: Colors.black87,
  //         ),
  //       ),
  //       // const SizedBox(height: 8),
  //       // DropdownButtonFormField<String>(
  //       //   value: _selectedGender,
  //       //   style: const TextStyle(fontSize: 16, color: Colors.black87),
  //       //   decoration: InputDecoration(
  //       //     hintText: 'Select your gender',
  //       //     filled: true,
  //       //     fillColor: Colors.grey[50],
  //       //     border: OutlineInputBorder(
  //       //       borderRadius: BorderRadius.circular(15),
  //       //       borderSide: BorderSide(color: Colors.grey[300]!),
  //       //     ),
  //       //     enabledBorder: OutlineInputBorder(
  //       //       borderRadius: BorderRadius.circular(15),
  //       //       borderSide: BorderSide(color: Colors.grey[300]!),
  //       //     ),
  //       //     focusedBorder: OutlineInputBorder(
  //       //       borderRadius: BorderRadius.circular(15),
  //       //       borderSide: const BorderSide(color: Color(0xFF30B0C7), width: 2),
  //       //     ),
  //       //     contentPadding: const EdgeInsets.symmetric(
  //       //       horizontal: 16,
  //       //       vertical: 16,
  //       //     ),
  //       //   ),
  //       //   items:
  //       //       _genderOptions.map((String gender) {
  //       //         return DropdownMenuItem<String>(
  //       //           value: gender,
  //       //           child: Text(gender),
  //       //         );
  //       //       }).toList(),
  //       //   onChanged: (String? newValue) {
  //       //     setState(() {
  //       //       _selectedGender = newValue;
  //       //     });
  //       //   },
  //       // ),
  //     ],
  //   );
  // }

  bool _validateForm() {
    if (!_formKey.currentState!.validate()) {
      return false;
    }

    return true;
  }

  // Future<void> _saveProfile() async {
  //   if (!_validateForm()) {
  //     return;
  //   }

  //   try {
  //     final currentUser = context.read<ProfileCubit>().currentUser;
  //     if (currentUser == null) {
  //       context.showErrorSnackBar('User data not found');
  //       return;
  //     }

  //     // Validate required fields
  //     final name = _nameController.text.trim();
  //     final email = _emailController.text.trim();
  //     final city = _cityController.text.trim();
  //     final prefrance = _preferenceCityController.text.trim();
  //     final phone = _phoneController.text.trim();
  //     final password = _passwordController.text.trim();

  //     if (name.isEmpty) {
  //       context.showErrorSnackBar('Name is required');
  //       return;
  //     }
  //     if (email.isEmpty) {
  //       context.showErrorSnackBar('Email is required');
  //       return;
  //     }
  //     if (city.isEmpty) {
  //       context.showErrorSnackBar('City is required');
  //       return;
  //     }
  //     if (prefrance.isEmpty) {
  //       context.showErrorSnackBar('Preferred city is required');
  //       return;
  //     }
  //     // تأكد إن الباسورد مطلوب
  //     if (password.isEmpty) {
  //       context.showErrorSnackBar('Password is required');
  //       return;
  //     }
  //     if (password.length < 6) {
  //       context.showErrorSnackBar('Password must be at least 6 characters');
  //       return;
  //     }

  //     // Create updated user model with all required fields
  //     final updatedUser = currentUser.copyWith(
  //       name: name,
  //       email: email,
  //       city: city,
  //       prefrance: prefrance,
  //       phoneNumber: phone,
  //       age:
  //           _selectedDate != null
  //               ? _calculateAge(_selectedDate!)
  //               : currentUser.age,
  //       password: password,
  //       imageData: currentUser.imageData,
  //       imageBytes: currentUser.imageBytes,
  //     );

  //     await context.read<ProfileCubit>().updateProfileComplete(
  //       updatedUser: updatedUser,
  //       newImageFile: _selectedImage,
  //     );
  //   } catch (e) {
  //     if (mounted) {
  //       context.showErrorSnackBar('Failed to update profile: ${e.toString()}');
  //     }
  //   }
  // }

  Future<void> _saveProfile() async {
    if (!_validateForm()) {
      return;
    }

    try {
      final currentUser = context.read<ProfileCubit>().currentUser;
      if (currentUser == null) {
        context.showErrorSnackBar('User data not found');
        return;
      }

      // Validate image file if selected
      if (_selectedImage != null) {
        if (!await _selectedImage!.exists()) {
          context.showErrorSnackBar('Selected image file does not exist');
          return;
        }

        // Check file size (max 5MB)
        final fileSize = await _selectedImage!.length();
        if (fileSize > 5 * 1024 * 1024) {
          context.showErrorSnackBar(
            'Image file is too large. Please select an image smaller than 5MB',
          );
          return;
        }

        // Check file extension
        final fileName = _selectedImage!.path.split('/').last.toLowerCase();
        if (!fileName.endsWith('.jpg') &&
            !fileName.endsWith('.jpeg') &&
            !fileName.endsWith('.png') &&
            !fileName.endsWith('.gif') &&
            !fileName.endsWith('.webp')) {
          context.showErrorSnackBar(
            'Please select a valid image file (JPG, PNG, GIF, or WebP)',
          );
          return;
        }
      }

      // Rest of your validation code...
      final name = _nameController.text.trim();
      final email = _emailController.text.trim();
      final city = _cityController.text.trim();
      final prefrance = _preferenceCityController.text.trim();
      final phone = _phoneController.text.trim();
      final password = _passwordController.text.trim();

      if (name.isEmpty) {
        context.showErrorSnackBar('Name is required');
        return;
      }
      if (email.isEmpty) {
        context.showErrorSnackBar('Email is required');
        return;
      }
      if (city.isEmpty) {
        context.showErrorSnackBar('City is required');
        return;
      }
      if (prefrance.isEmpty) {
        context.showErrorSnackBar('Preferred city is required');
        return;
      }
      if (password.isEmpty) {
        context.showErrorSnackBar('Password is required');
        return;
      }
      if (password.length < 6) {
        context.showErrorSnackBar('Password must be at least 6 characters');
        return;
      }

      // Create updated user model with all required fields
      final updatedUser = currentUser.copyWith(
        name: name,
        email: email,
        city: city,
        prefrance: prefrance,
        phoneNumber: phone,
        age:
            _selectedDate != null
                ? _calculateAge(_selectedDate!)
                : currentUser.age,
        password: password,
        imageData: currentUser.imageData,
        imageBytes: currentUser.imageBytes,
      );

      await context.read<ProfileCubit>().updateProfileComplete(
        updatedUser: updatedUser,
        newImageFile: _selectedImage,
      );
    } catch (e) {
      if (mounted) {
        context.showErrorSnackBar('Failed to update profile: ${e.toString()}');
      }
    }
  }

  int _calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: const Color(0xFF30B0C7),
        centerTitle: true,
        elevation: 0,
        title: const Text(
          "Edit Profile",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: _saveProfile,
            child: const Text(
              'Save',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listenWhen: (previous, current) {
          // اسمع بس لو الـ state اتغير فعلاً
          return previous.runtimeType != current.runtimeType ||
              (previous is ProfileError &&
                  current is ProfileError &&
                  previous.message != current.message);
        },
        listener: (context, state) {
          if (state is ProfileError) {
            context.showErrorSnackBar(state.message);
          } else if (state is ProfileUpdated) {
            context.showSuccessSnackBar(state.message);
            Navigator.pop(context);
          } else if (state is ProfileImageUploaded) {
            context.showSuccessSnackBar(state.message);
          }
        },
        builder: (context, state) {
          if (state is ProfileUpdating || _isImageUploading) {
            return const Center(
              child: AppLoadingIndicator(
                message: "Updating profile...",
                showBackground: true,
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Image Section
                  Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFF30B0C7),
                              width: 4,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF30B0C7).withOpacity(0.2),
                                spreadRadius: 3,
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 65,
                            backgroundImage: _getProfileImage(),
                          ),
                        ),
                        Positioned(
                          bottom: 5,
                          right: 5,
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF30B0C7),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 3),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 22,
                              ),
                              onPressed: _showImageSourceDialog,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Personal Information Section
                  _buildSectionTitle('Personal Information'),

                  // Username
                  _buildTextField(
                    label: 'Username',
                    controller: _nameController,
                    hintText: 'Enter username',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Username is required';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // Email (if needed)
                  _buildTextField(
                    label: 'Email',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    hintText: 'Enter email address',
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        if (!RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        ).hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // Password
                  _buildTextField(
                    label: 'Password',
                    controller: _passwordController,
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                    hintText: 'Enter password',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Phone Number
                  _buildTextField(
                    label: 'Phone Number',
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    hintText: 'Enter phone number',
                    maxLength: 15,
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        if (value.length < 10) {
                          return 'Please enter a valid phone number';
                        }
                      }
                      return null;
                    },
                  ),

                  // // Gender Dropdown
                  // _buildGenderDropdown(),
                  const SizedBox(height: 20),

                  // Birth Date
                  _buildTextField(
                    label: 'Date of Birth',
                    controller: _birthDateController,
                    readOnly: true,
                    onTap: _selectBirthDate,
                    hintText: 'Select date of birth',
                    suffixIcon: const Icon(
                      Icons.calendar_today,
                      color: Color(0xFF30B0C7),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // City
                  _buildTextField(
                    label: 'City',
                    controller: _cityController,
                    hintText: 'Enter your city',
                  ),

                  const SizedBox(height: 20),

                  // Preferred City
                  _buildTextField(
                    label: 'Preferred City',
                    controller: _preferenceCityController,
                    hintText: 'Enter preferred city',
                  ),

                  const SizedBox(height: 40),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _saveProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF30B0C7),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 2,
                        shadowColor: const Color(0xFF30B0C7).withOpacity(0.3),
                      ),
                      child: const Text(
                        'Save Changes',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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
