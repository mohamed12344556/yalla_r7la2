import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../core/cache/shared_pref_helper.dart';
import '../../../../core/utils/image_helper.dart';
import '../../data/models/user_model.dart';
import '../../data/repos/profile_repo.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepo profileRepository;

  ProfileCubit({required this.profileRepository}) : super(ProfileInitial());

  // Get current user data
  UserModel? get currentUser {
    final currentState = state;
    if (currentState is ProfileLoaded) return currentState.user;
    if (currentState is ProfileUpdating) return currentState.currentUser;
    if (currentState is ProfileUpdated) return currentState.user;
    if (currentState is ProfileError) return currentState.currentUser;
    return null;
  }

  // Get cached profile image
  File? get cachedProfileImage {
    final currentState = state;
    if (currentState is ProfileLoaded) return currentState.cachedProfileImage;
    if (currentState is ProfileUpdating) return currentState.cachedProfileImage;
    if (currentState is ProfileUpdated) return currentState.cachedProfileImage;
    if (currentState is ProfileError) return currentState.cachedProfileImage;
    return null;
  }

  // Load user profile
  Future<void> loadUserProfile() async {
    try {
      emit(ProfileLoading());
      log('Loading user profile...');

      final user = await profileRepository.getUserProfile();
      File? cachedImage;

      // معالجة صورة البروفايل
      if (user.imageBytes != null) {
        // حفظ البيانات كملف مؤقت
        cachedImage = await ImageHelper.saveBytesToFile(
          user.imageBytes!,
          'profile_image_${user.name ?? 'default'}.jpg',
        );

        // حفظ مسار الملف في SharedPreferences
        await SharedPrefHelper.setData(
          'cached_profile_image_path',
          cachedImage.path,
        );
      } else {
        // محاولة تحميل الصورة المحفوظة مسبقاً
        cachedImage = await _loadCachedProfileImage();
      }

      emit(ProfileLoaded(user: user, cachedProfileImage: cachedImage));
      log('Profile loaded successfully');
    } catch (e) {
      log('Error loading profile: $e');
      emit(ProfileError(message: e.toString()));
    }
  }

  // Validate user data before update
  String? _validateUserData(UserModel user) {
    if (user.password == null) {
      return 'Password is required for profile update';
    }
    if (user.phoneNumber == null) {
      return 'Phone number is required for profile update';
    }

    // Additional validations
    if (user.email != null && user.email!.isNotEmpty) {
      if (!_isValidEmail(user.email!)) {
        return 'Please enter a valid email address';
      }
    }

    if (user.name != null && user.name!.isNotEmpty) {
      if (user.name!.length < 2) {
        return 'Name must be at least 2 characters long';
      }
    }

    return null;
  }

  // Email validation helper
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // Create a complete user model for update
  UserModel _createUpdateUserModel(UserModel updatedUser) {
    final current = currentUser;
    if (current == null) return updatedUser;

    return current.copyWith(
      name: updatedUser.name ?? current.name,
      email: updatedUser.email ?? current.email,
      city: updatedUser.city ?? current.city,
      age: updatedUser.age ?? current.age,
      prefrance: updatedUser.preference ?? current.preference,
      phoneNumber: updatedUser.phoneNumber ?? current.phoneNumber,
      password: updatedUser.password ?? current.password,
    );
  }

  // Update user profile without image
  Future<void> updateUserProfile(UserModel updatedUser) async {
    try {
      final current = currentUser;
      if (current == null) {
        emit(ProfileError(message: 'No user data available'));
        return;
      }

      // Create complete user model with required fields
      final completeUser = _createUpdateUserModel(updatedUser);

      // التحقق من البيانات المطلوبة
      final validationError = _validateUserData(completeUser);
      if (validationError != null) {
        emit(
          ProfileError(
            message: validationError,
            currentUser: current,
            cachedProfileImage: cachedProfileImage,
          ),
        );
        return;
      }

      emit(
        ProfileUpdating(
          currentUser: current,
          cachedProfileImage: cachedProfileImage,
        ),
      );

      log('Updating user profile (without new image)...');
      log('Update data: ${completeUser.toJson()}');

      final user = await profileRepository.updateUserProfile(
        user: completeUser,
        imageFile: null,
      );

      emit(
        ProfileUpdated(
          user: user,
          cachedProfileImage: cachedProfileImage,
          message: 'Profile updated successfully',
        ),
      );

      log('Profile updated successfully');
    } catch (e) {
      log('Error updating profile: $e');
      emit(
        ProfileError(
          message: _handleErrorMessage(e.toString()),
          currentUser: currentUser,
          cachedProfileImage: cachedProfileImage,
        ),
      );
    }
  }

  // Update user profile with image
  Future<void> updateUserProfileWithImage({
    required UserModel updatedUser,
    required File imageFile,
  }) async {
    try {
      final current = currentUser;
      if (current == null) {
        emit(ProfileError(message: 'No user data available'));
        return;
      }

      // Check if image file exists
      if (!await imageFile.exists()) {
        emit(
          ProfileError(
            message: 'Selected image file does not exist',
            currentUser: current,
            cachedProfileImage: cachedProfileImage,
          ),
        );
        return;
      }

      // Create complete user model with required fields
      final completeUser = _createUpdateUserModel(updatedUser);

      // التحقق من البيانات المطلوبة
      final validationError = _validateUserData(completeUser);
      if (validationError != null) {
        emit(
          ProfileError(
            message: validationError,
            currentUser: current,
            cachedProfileImage: cachedProfileImage,
          ),
        );
        return;
      }

      emit(
        ProfileUpdating(
          currentUser: current,
          cachedProfileImage: cachedProfileImage,
        ),
      );

      log('Updating user profile with image...');
      log('Update data: ${completeUser.toJson()}');
      log('Image file path: ${imageFile.path}');

      final user = await profileRepository.updateUserProfile(
        user: completeUser,
        imageFile: imageFile,
      );

      // Cache the new image
      await _cacheProfileImage(imageFile);

      emit(
        ProfileUpdated(
          user: user,
          cachedProfileImage: imageFile,
          message: 'Profile and image updated successfully',
        ),
      );

      log('Profile and image updated successfully');
    } catch (e) {
      log('Error updating profile with image: $e');
      emit(
        ProfileError(
          message: _handleErrorMessage(e.toString()),
          currentUser: currentUser,
          cachedProfileImage: cachedProfileImage,
        ),
      );
    }
  }

  // Pick and update profile image
  Future<void> pickAndUpdateProfileImage({
    ImageSource source = ImageSource.gallery,
  }) async {
    try {
      final current = currentUser;
      if (current == null) {
        emit(ProfileError(message: 'No user data available'));
        return;
      }

      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        final imageFile = File(pickedFile.path);

        // Update profile with the new image
        await updateUserProfileWithImage(
          updatedUser: current,
          imageFile: imageFile,
        );
      }
    } catch (e) {
      log('Error picking and updating image: $e');
      emit(
        ProfileError(
          message:
              'Failed to update image: ${_handleErrorMessage(e.toString())}',
          currentUser: currentUser,
          cachedProfileImage: cachedProfileImage,
        ),
      );
    }
  }

  // Pick and cache profile image (without uploading)
  Future<void> pickAndCacheProfileImage({
    ImageSource source = ImageSource.gallery,
  }) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        final imageFile = File(pickedFile.path);
        await _cacheProfileImage(imageFile);

        final current = currentUser;
        if (current != null) {
          emit(ProfileLoaded(user: current, cachedProfileImage: imageFile));
          log('Profile image cached locally');
        }
      }
    } catch (e) {
      log('Error picking image: $e');
      emit(
        ProfileError(
          message: 'Failed to pick image: ${_handleErrorMessage(e.toString())}',
          currentUser: currentUser,
          cachedProfileImage: cachedProfileImage,
        ),
      );
    }
  }

  // Update profile info and image together
  Future<void> updateProfileComplete({
    required UserModel updatedUser,
    File? newImageFile,
  }) async {
    try {
      final current = currentUser;
      if (current == null) {
        emit(ProfileError(message: 'No user data available'));
        return;
      }

      // Check if image file exists (if provided)
      if (newImageFile != null && !await newImageFile.exists()) {
        emit(
          ProfileError(
            message: 'Selected image file does not exist',
            currentUser: current,
            cachedProfileImage: cachedProfileImage,
          ),
        );
        return;
      }

      // Create complete user model with required fields
      final completeUser = _createUpdateUserModel(updatedUser);

      // التحقق من البيانات المطلوبة
      final validationError = _validateUserData(completeUser);
      if (validationError != null) {
        emit(
          ProfileError(
            message: validationError,
            currentUser: current,
            cachedProfileImage: cachedProfileImage,
          ),
        );
        return;
      }

      emit(
        ProfileUpdating(
          currentUser: current,
          cachedProfileImage: cachedProfileImage,
        ),
      );

      log('Updating complete profile...');
      log('Update data: ${completeUser.toJson()}');
      if (newImageFile != null) {
        log('New image file path: ${newImageFile.path}');
      }

      final user = await profileRepository.updateUserProfile(
        user: completeUser,
        imageFile: newImageFile,
      );

      File? finalCachedImage = cachedProfileImage;

      // Cache new image if provided
      if (newImageFile != null) {
        await _cacheProfileImage(newImageFile);
        finalCachedImage = newImageFile;
      }

      emit(
        ProfileUpdated(
          user: user,
          cachedProfileImage: finalCachedImage,
          message:
              newImageFile != null
                  ? 'Profile and image updated successfully'
                  : 'Profile updated successfully',
        ),
      );

      log('Complete profile update successful');
    } catch (e) {
      log('Error updating complete profile: $e');
      emit(
        ProfileError(
          message: _handleErrorMessage(e.toString()),
          currentUser: currentUser,
          cachedProfileImage: cachedProfileImage,
        ),
      );
    }
  }

  // Change password - Updated to use the same profile update endpoint
  Future<void> changePassword({required String newPassword}) async {
    try {
      final current = currentUser;
      if (current == null) {
        emit(ProfileError(message: 'No user data available'));
        return;
      }

      // Validate new password
      if (newPassword.length < 6) {
        emit(
          ProfileError(
            message: 'New password must be at least 6 characters long',
            currentUser: current,
            cachedProfileImage: cachedProfileImage,
          ),
        );
        return;
      }

      emit(PasswordChanging());
      log('Changing password using profile update endpoint...');

      // Use the profile update endpoint with new password
      final updatedUser = await profileRepository.changePassword(
        currentUser: current,
        newPassword: newPassword,
      );

      emit(PasswordChanged(message: 'Password changed successfully'));

      // Update the current user with new password (for local state)
      final userWithNewPassword = current.copyWith(password: newPassword);

      // Return to loaded state with updated user
      emit(
        ProfileLoaded(
          user: userWithNewPassword,
          cachedProfileImage: cachedProfileImage,
        ),
      );

      log('Password changed successfully');
    } catch (e) {
      log('Error changing password: $e');
      emit(
        ProfileError(
          message: _handleErrorMessage(e.toString()),
          currentUser: currentUser,
          cachedProfileImage: cachedProfileImage,
        ),
      );
    }
  }

  // Handle error messages
  String _handleErrorMessage(String error) {
    if (error.contains('Connection timeout')) {
      return 'Connection timeout. Please check your internet connection and try again.';
    } else if (error.contains('Connection error')) {
      return 'Connection error. Please check your internet connection.';
    } else if (error.contains('Authentication failed')) {
      return 'Authentication failed. Please login again.';
    } else if (error.contains('Access denied')) {
      return 'Access denied. You don\'t have permission to perform this action.';
    } else if (error.contains('Server error')) {
      return 'Server error occurred. Please try again later.';
    } else if (error.contains('Invalid data')) {
      return 'Invalid data provided. Please check your input and try again.';
    }
    return error;
  }

  // دالة لتحويل bytes إلى ملف مؤقت للعرض
  Future<File?> convertBytesToFile(Uint8List bytes) async {
    try {
      return await ImageHelper.saveBytesToTempFile(bytes);
    } catch (e) {
      log('Error converting bytes to file: $e');
      return null;
    }
  }

  // Cache profile image locally
  Future<void> _cacheProfileImage(File imageFile) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final profileDir = Directory('${directory.path}/profile');

      if (!await profileDir.exists()) {
        await profileDir.create(recursive: true);
      }

      final fileName = 'profile_image.jpg';
      final cachedFile = File('${profileDir.path}/$fileName');

      await imageFile.copy(cachedFile.path);
      await SharedPrefHelper.setData(
        'cached_profile_image_path',
        cachedFile.path,
      );

      log('Profile image cached at: ${cachedFile.path}');
    } catch (e) {
      log('Error caching profile image: $e');
    }
  }

  // Load cached profile image
  Future<File?> _loadCachedProfileImage() async {
    try {
      final cachedPath = await SharedPrefHelper.getString(
        'cached_profile_image_path',
      );
      if (cachedPath.isNotEmpty) {
        final cachedFile = File(cachedPath);
        if (await cachedFile.exists()) {
          log('Loaded cached profile image from: $cachedPath');
          return cachedFile;
        }
      }
    } catch (e) {
      log('Error loading cached profile image: $e');
    }
    return null;
  }

  // Clear cached profile image
  Future<void> clearCachedProfileImage() async {
    try {
      final cachedPath = await SharedPrefHelper.getString(
        'cached_profile_image_path',
      );
      if (cachedPath.isNotEmpty) {
        final cachedFile = File(cachedPath);
        if (await cachedFile.exists()) {
          await cachedFile.delete();
        }
        await SharedPrefHelper.removeData('cached_profile_image_path');
        log('Cached profile image cleared');
      }

      final current = currentUser;
      if (current != null) {
        emit(ProfileLoaded(user: current, cachedProfileImage: null));
      }
    } catch (e) {
      log('Error clearing cached profile image: $e');
    }
  }

  // Reset to initial state
  void reset() {
    emit(ProfileInitial());
  }
}
