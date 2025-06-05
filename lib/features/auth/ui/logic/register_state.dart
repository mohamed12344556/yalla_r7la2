part of 'register_cubit.dart';

@immutable
sealed class RegisterState {}

final class RegisterInitial extends RegisterState {}

final class RegisterPasswordVisibilityChanged extends RegisterState {}

final class RegisterConfirmPasswordVisibilityChanged extends RegisterState {}

final class RegisterDateSelected extends RegisterState {}

final class RegisterLoading extends RegisterState {}

final class RegisterSuccess extends RegisterState {
  final AuthResponse authResponse;
  RegisterSuccess(this.authResponse);
}

final class RegisterError extends RegisterState {
  final String errorMessage;
  RegisterError(this.errorMessage);
}

// Image-related states
final class RegisterImageSelected extends RegisterState {}

final class RegisterImageRemoved extends RegisterState {}

// Preferred city state
final class RegisterPreferredCityChanged extends RegisterState {}
