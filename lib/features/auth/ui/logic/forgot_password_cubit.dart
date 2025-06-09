import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repos/auth_repo_forgot_password.dart';

import '../../data/repos/auth_repo.dart';
import 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final AuthRepo authRepo;

  ForgotPasswordCubit({required this.authRepo})
    : super(ForgotPasswordInitial());

  // Form controllers
  final emailController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  // Getters for password visibility
  bool get obscureNewPassword => _obscureNewPassword;
  bool get obscureConfirmPassword => _obscureConfirmPassword;

  // Toggle password visibility
  void toggleNewPasswordVisibility() {
    _obscureNewPassword = !_obscureNewPassword;
    emit(ForgotPasswordPasswordVisibility());
  }

  void toggleConfirmPasswordVisibility() {
    _obscureConfirmPassword = !_obscureConfirmPassword;
    emit(ForgotPasswordPasswordVisibility());
  }

  // Reset Password method
  Future<void> resetPassword() async {
    emit(ForgotPasswordLoading());

    try {
      final result = await authRepo.resetPassword(
        email: emailController.text.trim(),
        newPassword: newPasswordController.text.trim(),
      );

      result.fold(
        (error) => emit(ForgotPasswordError(error)),
        (response) => emit(ForgotPasswordSuccess(response)),
      );
    } catch (e) {
      emit(ForgotPasswordError('An unexpected error occurred: $e'));
    }
  }

  // Clear data
  void clearData() {
    emailController.clear();
    newPasswordController.clear();
    confirmPasswordController.clear();
    _obscureNewPassword = true;
    _obscureConfirmPassword = true;
    emit(ForgotPasswordInitial());
  }

  @override
  Future<void> close() {
    emailController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    return super.close();
  }
}
