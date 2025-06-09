import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/auth_model.dart';
import '../../data/repos/auth_repo.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepo authRepo;

  LoginCubit({required this.authRepo}) : super(LoginInitial());

  // Form and controllers
  final loginFormKey = GlobalKey<FormState>();
  final loginEmailController = TextEditingController();
  final loginPasswordController = TextEditingController();
  bool _obscurePassword = true;

  // Getter for password visibility
  bool get obscurePassword => _obscurePassword;

  // Toggle password visibility
  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    emit(LoginPasswordVisibility());
  }

  // Login method
  Future<void> login({required String email, required String password}) async {
    emit(LoginLoading());

    try {
      final result = await authRepo.login(email: email, password: password);

      result.fold(
        (error) => emit(LoginError(error)),
        (authResponse) => emit(LoginSuccess(authResponse)),
      );
    } catch (e) {
      emit(LoginError('An unexpected error occurred: $e'));
    }
  }

  // Clear data on logout
  void logout() {
    loginEmailController.clear();
    loginPasswordController.clear();
    _obscurePassword = true;
    emit(LoginInitial());
  }

  @override
  Future<void> close() {
    loginEmailController.dispose();
    loginPasswordController.dispose();
    return super.close();
  }
}
