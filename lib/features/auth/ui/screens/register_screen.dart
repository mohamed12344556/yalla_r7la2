import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:p1/core/routes/routes.dart';
import 'package:p1/core/utils/extensions.dart';
import 'package:p1/core/utils/validators.dart';
import 'package:p1/core/widgets/app_button.dart';
import 'package:p1/core/widgets/app_text_field.dart';

import '../logic/register_cubit.dart';
import '../widgets/image_picker_bottom_sheet.dart';
import '../widgets/profile_image_section.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  void _signUp() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    context.read<RegisterCubit>().register(
      fullName:
          context.read<RegisterCubit>().registerFullNameController.text.trim(),
      email: context.read<RegisterCubit>().registerEmailController.text.trim(),
      phoneNumber:
          context.read<RegisterCubit>().registerPhoneController.text.trim(),
      dateOfBirth:
          context.read<RegisterCubit>().registerDobController.text.trim(),
      password:
          context.read<RegisterCubit>().registerPasswordController.text.trim(),
      city: context.read<RegisterCubit>().registerCityController.text.trim(),
      prefrance:
          context.read<RegisterCubit>().registerPrefranceController.text.trim(),
    );
  }

  void _showImagePicker() {
    showImagePickerBottomSheet(context);
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<RegisterCubit>();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: BlocConsumer<RegisterCubit, RegisterState>(
          listener: (context, state) {
            if (state is RegisterSuccess) {
              context.showSuccessSnackBar('Account created successfully');
              context.pushReplacementNamed(Routes.host);
            } else if (state is RegisterError) {
              context.showErrorSnackBar(state.errorMessage);
            }
          },
          buildWhen: (previous, current) {
            return true; // Build for all state changes
          },
          builder: (context, state) {
            return Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 50),
                  // Logo/Image
                  Image.asset(
                    'assets/undraw_adventure_map_hnin2(1).png',
                    height: 200,
                  ),
                  const SizedBox(height: 30),
                  // Welcome Text
                  const Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Please enter your details to create an account.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 24),

                  // Profile Picture Section
                  ProfileImageSection(onImagePickerTap: _showImagePicker),
                  const SizedBox(height: 24),

                  // Full Name Field
                  AppTextField(
                    controller: cubit.registerFullNameController,
                    hintText: 'Full Name',
                    prefixIcon: const Icon(Icons.person),
                    validator:
                        (value) =>
                            Validators.validateRequired(value, "Full Name"),
                  ),
                  const SizedBox(height: 16),

                  // Email Field
                  AppTextField(
                    controller: cubit.registerEmailController,
                    hintText: 'Email',
                    prefixIcon: const Icon(Icons.email),
                    validator: Validators.validateEmail,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),

                  // Phone Number Field
                  AppTextField(
                    controller: cubit.registerPhoneController,
                    hintText: 'Phone Number',
                    prefixIcon: const Icon(Icons.phone),
                    validator: Validators.validatePhone,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),

                  // Date of Birth Field
                  AppTextField(
                    controller: cubit.registerDobController,
                    hintText: 'Date of Birth',
                    prefixIcon: const Icon(Icons.calendar_today),
                    validator:
                        (value) =>
                            Validators.validateRequired(value, "Date of Birth"),
                    readOnly: true,
                    onTap: () => cubit.selectDate(context),
                    suffixIcon: const Icon(Icons.calendar_today),
                  ),
                  const SizedBox(height: 16),

                  // City Field
                  AppTextField(
                    controller: cubit.registerCityController,
                    hintText: 'City',
                    prefixIcon: const Icon(Icons.location_city),
                    validator:
                        (value) => Validators.validateRequired(value, "City"),
                  ),
                  const SizedBox(height: 16),

                  // Preferred City Field
                  AppTextField(
                    controller: cubit.registerPrefranceController,
                    hintText: 'Preferred City',
                    prefixIcon: const Icon(Icons.favorite),
                    validator:
                        (value) => Validators.validateRequired(
                          value,
                          "Preferred City",
                        ),
                  ),
                  const SizedBox(height: 16),

                  // Password Field
                  BlocBuilder<RegisterCubit, RegisterState>(
                    builder: (context, state) {
                      return AppTextField(
                        controller: cubit.registerPasswordController,
                        hintText: 'Password',
                        prefixIcon: const Icon(Icons.lock),
                        validator: Validators.validatePassword,
                        isPassword: true,
                        passwordVisible: !cubit.obscurePassword,
                        onTogglePasswordVisibility: () {
                          cubit.togglePasswordVisibility();
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  // Confirm Password Field
                  BlocBuilder<RegisterCubit, RegisterState>(
                    builder: (context, state) {
                      return AppTextField(
                        controller: cubit.registerConfirmPasswordController,
                        hintText: 'Confirm Password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        validator: (value) {
                          final passwordError = Validators.validatePassword(
                            value,
                          );
                          if (passwordError != null) return passwordError;
                          return cubit.validateConfirmPassword(value);
                        },
                        isPassword: true,
                        passwordVisible: !cubit.obscureConfirmPassword,
                        onTogglePasswordVisibility: () {
                          cubit.toggleConfirmPasswordVisibility();
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 32),

                  // Sign Up Button
                  AppButton(
                    text: 'Sign Up',
                    isLoading: state is RegisterLoading,
                    onPressed: () {
                      log('Signing up...');
                      FocusScope.of(context).unfocus();
                      _signUp();
                    },
                  ),
                  const SizedBox(height: 16),

                  // Login Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already have an account? '),
                      GestureDetector(
                        onTap:
                            () => Navigator.pushReplacementNamed(
                              context,
                              Routes.login,
                            ),
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
