import 'package:flutter/material.dart';
import 'package:yalla_r7la2/features/auth/data/models/forgot_password_model.dart';

@immutable
sealed class ForgotPasswordState {}

final class ForgotPasswordInitial extends ForgotPasswordState {}

final class ForgotPasswordPasswordVisibility extends ForgotPasswordState {}

final class ForgotPasswordLoading extends ForgotPasswordState {}

final class ForgotPasswordSuccess extends ForgotPasswordState {
  final ForgotPasswordResponse response;
  ForgotPasswordSuccess(this.response);
}

final class ForgotPasswordError extends ForgotPasswordState {
  final String errorMessage;
  ForgotPasswordError(this.errorMessage);
}
