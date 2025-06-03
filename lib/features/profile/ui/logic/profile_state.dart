import 'dart:io';

import 'package:p1/features/profile/data/models/user_model.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserModel user;
  final File? cachedProfileImage;

  ProfileLoaded({required this.user, this.cachedProfileImage});

  ProfileLoaded copyWith({UserModel? user, File? cachedProfileImage}) {
    return ProfileLoaded(
      user: user ?? this.user,
      cachedProfileImage: cachedProfileImage ?? this.cachedProfileImage,
    );
  }
}

class ProfileUpdating extends ProfileState {
  final UserModel currentUser;
  final File? cachedProfileImage;

  ProfileUpdating({required this.currentUser, this.cachedProfileImage});
}

class ProfileUpdated extends ProfileState {
  final UserModel user;
  final File? cachedProfileImage;
  final String message;

  ProfileUpdated({
    required this.user,
    this.cachedProfileImage,
    this.message = 'Profile updated successfully',
  });
}

class ProfileImageUploading extends ProfileState {
  final UserModel currentUser;
  final File uploadingImage;

  ProfileImageUploading({
    required this.currentUser,
    required this.uploadingImage,
  });
}

class ProfileImageUploaded extends ProfileState {
  final UserModel user;
  final File cachedProfileImage;
  final String message;

  ProfileImageUploaded({
    required this.user,
    required this.cachedProfileImage,
    this.message = 'Profile image updated successfully',
  });
}

class PasswordChanging extends ProfileState {}

class PasswordChanged extends ProfileState {
  final String message;

  PasswordChanged({this.message = 'Password changed successfully'});
}

class ProfileError extends ProfileState {
  final String message;
  final UserModel? currentUser;
  final File? cachedProfileImage;

  ProfileError({
    required this.message,
    this.currentUser,
    this.cachedProfileImage,
  });
}
