import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/api/api_constants.dart';
import '../../../../core/cache/shared_pref_helper.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/utils/extensions.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../generated/l10n.dart';
import '../logic/login_cubit.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  void _login() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    context.read<LoginCubit>().login(
      email: context.read<LoginCubit>().loginEmailController.text.trim(),
      password: context.read<LoginCubit>().loginPasswordController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LoginCubit>();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: BlocConsumer<LoginCubit, LoginState>(
            listener: (context, state) async {
              if (state is LoginSuccess) {
                // Save user data using the existing SharedPrefHelper
                await SharedPrefHelper.setSecuredString(
                  SharedPrefKeys.token,
                  state.authResponse.token,
                );

                context.showSuccessSnackBar(S.of(context).Login_successful);

                // Navigate to main screen
                context.pushReplacementNamed(Routes.host);
              } else if (state is LoginError) {
                context.showErrorSnackBar(state.errorMessage);
              }
            },
            builder: (context, state) {
              return Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 80),
                    // Logo/Image
                    Image.asset(
                      'assets/undraw_adventure_map_hnin2(1).png',
                      height: 200,
                    ),
                    const SizedBox(height: 30),

                    // Welcome Text
                    Text(
                      S.of(context).Welcome_Back,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      S.of(context).Sign_in_to_your_account,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Email Field
                    AppTextField(
                      controller: cubit.loginEmailController,
                      hintText: S.of(context).Email,
                      prefixIcon: const Icon(Icons.email),
                      keyboardType: TextInputType.emailAddress,
                      validator: Validators.validateEmail,
                    ),
                    const SizedBox(height: 20),

                    // Password Field
                    AppTextField(
                      controller: cubit.loginPasswordController,
                      hintText: S.of(context).Password,
                      prefixIcon: const Icon(Icons.lock),
                      isPassword: true,
                      passwordVisible: !cubit.obscurePassword,
                      keyboardType: TextInputType.visiblePassword,
                      validator: Validators.validatePassword,
                      onTogglePasswordVisibility: () {
                        cubit.togglePasswordVisibility();
                      },
                    ),
                    const SizedBox(height: 15),

                    // Forgot Password
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          context.pushNamed(Routes.forgotPassword);
                        },
                        child: Text(S.of(context).Forgot_Password),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Login Button
                    AppButton(
                      text: S.of(context).Login,
                      isLoading: state is LoginLoading,
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        _login();
                      },
                    ),
                    const SizedBox(height: 20),

                    // Sign Up Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          S.of(context).Dont_have_account,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, Routes.register);
                          },
                          child: Text(
                            S.of(context).Sign_Up,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.primary,
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
