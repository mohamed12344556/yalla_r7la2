import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/models/auth_model.dart';
import '../../data/repos/auth_repo.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final AuthRepo authRepo;

  RegisterCubit({required this.authRepo}) : super(RegisterInitial());

  // Form and controllers
  final registerFormKey = GlobalKey<FormState>();
  final registerFullNameController = TextEditingController();
  final registerEmailController = TextEditingController();
  final registerPhoneController = TextEditingController();
  final registerDobController = TextEditingController();
  final registerPasswordController = TextEditingController();
  final registerConfirmPasswordController = TextEditingController();
  final registerCityController = TextEditingController();
  final registerPrefranceController = TextEditingController();

  // Password visibility states
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // Image handling
  File? _selectedImage;
  String? _imagePath;

  // Getters
  bool get obscurePassword => _obscurePassword;
  bool get obscureConfirmPassword => _obscureConfirmPassword;
  File? get selectedImage => _selectedImage;
  String? get imagePath => _imagePath;

  // Password visibility methods
  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    emit(RegisterPasswordVisibilityChanged()); // Changed state name
  }

  void toggleConfirmPasswordVisibility() {
    _obscureConfirmPassword = !_obscureConfirmPassword;
    emit(RegisterConfirmPasswordVisibilityChanged()); // Changed state name
  }

  // Password validation
  String? validateConfirmPassword(String? value) {
    if (value != registerPasswordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  // Date picker
  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(
        const Duration(days: 6570),
      ), // 18 years ago
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      // Format date for display in the field
      registerDobController.text =
          "${picked.day}/${picked.month}/${picked.year}";
      emit(RegisterDateSelected()); // Emit state change
    }
  }

  // Image selection methods
  Future<void> pickImageFromGallery() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );

      if (image != null) {
        _selectedImage = File(image.path);
        _imagePath = image.path;
        emit(RegisterImageSelected());
      }
    } catch (e) {
      emit(RegisterError('Failed to pick image: $e'));
    }
  }

  Future<void> pickImageFromCamera() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );

      if (image != null) {
        _selectedImage = File(image.path);
        _imagePath = image.path;
        emit(RegisterImageSelected());
      }
    } catch (e) {
      emit(RegisterError('Failed to take picture: $e'));
    }
  }

  void removeSelectedImage() {
    _selectedImage = null;
    _imagePath = null;
    emit(RegisterImageRemoved());
  }

  // Convert display date to ISO format for API
  String _convertDateToISO(String displayDate) {
    try {
      final parts = displayDate.split('/');
      if (parts.length == 3) {
        final day = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final year = int.parse(parts[2]);
        final dateTime = DateTime(year, month, day);
        return dateTime.toIso8601String();
      }
    } catch (e) {
      // Handle parsing error
    }
    return displayDate; // Return original if parsing fails
  }

  // Form validation method
  bool validateForm() {
    return registerFormKey.currentState?.validate() ?? false;
  }

  // Register method
  Future<void> register({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
    required String dateOfBirth,
    required String city,
    required String prefrance,
  }) async {
    emit(RegisterLoading());

    try {
      // Convert date to ISO format for API
      final isoDateOfBirth = _convertDateToISO(dateOfBirth);

      final result = await authRepo.register(
        email: email,
        password: password,
        fullName: fullName,
        phoneNumber: phoneNumber,
        dateOfBirth: isoDateOfBirth,
        city: city,
        prefrance: prefrance,
        imagePath: _imagePath,
      );

      result.fold(
        (error) => emit(RegisterError(error)),
        (authResponse) => emit(RegisterSuccess(authResponse)),
      );
    } catch (e) {
      emit(RegisterError('An unexpected error occurred: $e'));
    }
  }

  // Alternative register method without parameters
  Future<void> registerWithControllers() async {
    if (!validateForm()) {
      emit(RegisterError('Please fill all required fields correctly'));
      return;
    }

    await register(
      email: registerEmailController.text.trim(),
      password: registerPasswordController.text,
      fullName: registerFullNameController.text.trim(),
      phoneNumber: registerPhoneController.text.trim(),
      dateOfBirth: registerDobController.text,
      city: registerCityController.text.trim(),
      prefrance: registerPrefranceController.text.trim(),
    );
  }

  // Reset to initial state without clearing data
  void resetState() {
    if (state is! RegisterLoading) {
      emit(RegisterInitial());
    }
  }

  // Clear all data
  void clearData() {
    _selectedImage = null;
    _imagePath = null;
    _obscurePassword = true;
    _obscureConfirmPassword = true;

    // Clear all controllers
    registerFullNameController.clear();
    registerEmailController.clear();
    registerPhoneController.clear();
    registerDobController.clear();
    registerPasswordController.clear();
    registerConfirmPasswordController.clear();
    registerCityController.clear();
    registerPrefranceController.clear();

    emit(RegisterInitial());
  }

  @override
  Future<void> close() {
    registerFullNameController.dispose();
    registerEmailController.dispose();
    registerPhoneController.dispose();
    registerDobController.dispose();
    registerPasswordController.dispose();
    registerConfirmPasswordController.dispose();
    registerCityController.dispose();
    registerPrefranceController.dispose();
    return super.close();
  }
}
