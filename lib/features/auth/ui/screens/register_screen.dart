import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/routes/routes.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../generated/l10n.dart';
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

    // Check if preferred city is selected
    final cubit = context.read<RegisterCubit>();
    if (cubit.selectedPreferredCity == null) {
      context.showErrorSnackBar(
        S.of(context).Please_select_your_preferred_city,
      );
      return;
    }

    cubit.register(
      fullName: cubit.registerFullNameController.text.trim(),
      email: cubit.registerEmailController.text.trim(),
      phoneNumber: cubit.registerPhoneController.text.trim(),
      dateOfBirth: cubit.registerDobController.text.trim(),
      password: cubit.registerPasswordController.text.trim(),
      city: cubit.registerCityController.text.trim(),
      prefrance: cubit.selectedPreferredCity!,
    );
  }

  void _showImagePicker() {
    showImagePickerBottomSheet(context);
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<RegisterCubit>();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: BlocConsumer<RegisterCubit, RegisterState>(
            listener: (context, state) {
              if (state is RegisterSuccess) {
                context.showSuccessSnackBar(
                  S.of(context).Account_created_successfully,
                );
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Welcome Text
                    Text(
                      S.of(context).Sign_Up,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      S.of(context).Please_enter_details,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Profile Picture Section
                    ProfileImageSection(onImagePickerTap: _showImagePicker),
                    const SizedBox(height: 24),

                    // Full Name Field
                    AppTextField(
                      controller: cubit.registerFullNameController,
                      hintText: S.of(context).Full_Name,
                      prefixIcon: const Icon(Icons.person),
                      validator:
                          (value) => Validators.validateRequired(
                            value,
                            S.of(context).Full_Name,
                          ),
                    ),
                    const SizedBox(height: 16),

                    // Email Field
                    AppTextField(
                      controller: cubit.registerEmailController,
                      hintText: S.of(context).Email,
                      prefixIcon: const Icon(Icons.email),
                      validator: Validators.validateEmail,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),

                    // Phone Number Field
                    AppTextField(
                      controller: cubit.registerPhoneController,
                      hintText: S.of(context).Phone_Number,
                      prefixIcon: const Icon(Icons.phone),
                      validator: Validators.validatePhone,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 16),

                    // Date of Birth Field
                    AppTextField(
                      controller: cubit.registerDobController,
                      hintText: S.of(context).Date_of_Birth,
                      prefixIcon: const Icon(Icons.calendar_today),
                      validator:
                          (value) => Validators.validateRequired(
                            value,
                            S.of(context).Date_of_Birth,
                          ),
                      readOnly: true,
                      onTap: () => cubit.selectDate(context),
                      suffixIcon: const Icon(Icons.calendar_today),
                    ),
                    const SizedBox(height: 16),

                    // City Field
                    AppTextField(
                      controller: cubit.registerCityController,
                      hintText: S.of(context).City,
                      prefixIcon: const Icon(Icons.location_city),
                      validator:
                          (value) => Validators.validateRequired(
                            value,
                            S.of(context).City,
                          ),
                    ),
                    const SizedBox(height: 16),

                    // Preferred City Dropdown
                    BlocBuilder<RegisterCubit, RegisterState>(
                      builder: (context, state) {
                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color:
                                  context.isDark
                                      ? Colors.grey[600]!
                                      : Colors.grey[300]!,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: DropdownButtonFormField<String>(
                            value: cubit.selectedPreferredCity,
                            decoration: InputDecoration(
                              hintText: S.of(context).Select_Preferred_City,
                              hintStyle: TextStyle(
                                color: colorScheme.onSurface.withOpacity(0.6),
                              ),
                              prefixIcon: Icon(
                                Icons.favorite,
                                color: colorScheme.primary,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                            items:
                                cubit.preferredCities.map((String city) {
                                  return DropdownMenuItem<String>(
                                    value: city,
                                    child: Text(
                                      city,
                                      style: TextStyle(
                                        color: colorScheme.onSurface,
                                      ),
                                    ),
                                  );
                                }).toList(),
                            onChanged: (String? value) {
                              cubit.setPreferredCity(value);
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return S
                                    .of(context)
                                    .Please_select_preferred_city;
                              }
                              return null;
                            },
                            isExpanded: true,
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: colorScheme.onSurface,
                            ),
                            dropdownColor: colorScheme.surface,
                            style: TextStyle(color: colorScheme.onSurface),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),

                    // Password Field
                    BlocBuilder<RegisterCubit, RegisterState>(
                      builder: (context, state) {
                        return AppTextField(
                          controller: cubit.registerPasswordController,
                          hintText: S.of(context).Password,
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
                          hintText: S.of(context).Confirm_Password,
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
                      text: S.of(context).Sign_Up,
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
                        Text(
                          S.of(context).Already_have_account,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                        GestureDetector(
                          onTap:
                              () => Navigator.pushReplacementNamed(
                                context,
                                Routes.login,
                              ),
                          child: Text(
                            S.of(context).Login,
                            style: TextStyle(
                              color: colorScheme.primary,
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
      ),
    );
  }
}
