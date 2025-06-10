// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name =
        (locale.countryCode?.isEmpty ?? false)
            ? locale.languageCode
            : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Push Notifications`
  String get Push_Notifications {
    return Intl.message(
      'Push Notifications',
      name: 'Push_Notifications',
      desc: '',
      args: [],
    );
  }

  /// `Welcome Back`
  String get Welcome_Back {
    return Intl.message(
      'Welcome Back',
      name: 'Welcome_Back',
      desc: '',
      args: [],
    );
  }

  /// `Sign in to your account`
  String get Sign_in_to_your_account {
    return Intl.message(
      'Sign in to your account',
      name: 'Sign_in_to_your_account',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get Email {
    return Intl.message('Email', name: 'Email', desc: '', args: []);
  }

  /// `Password`
  String get Password {
    return Intl.message('Password', name: 'Password', desc: '', args: []);
  }

  /// `Forgot Password?`
  String get Forgot_Password {
    return Intl.message(
      'Forgot Password?',
      name: 'Forgot_Password',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get Login {
    return Intl.message('Login', name: 'Login', desc: '', args: []);
  }

  /// `Don't have an account?`
  String get Dont_have_account {
    return Intl.message(
      'Don\'t have an account?',
      name: 'Dont_have_account',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up`
  String get Sign_Up {
    return Intl.message('Sign Up', name: 'Sign_Up', desc: '', args: []);
  }

  /// `Reset Password`
  String get Reset_Password {
    return Intl.message(
      'Reset Password',
      name: 'Reset_Password',
      desc: '',
      args: [],
    );
  }

  /// `Reset Your Password`
  String get Reset_Your_Password {
    return Intl.message(
      'Reset Your Password',
      name: 'Reset_Your_Password',
      desc: '',
      args: [],
    );
  }

  /// `Enter your email and new password to reset your account password`
  String get Enter_email_and_new_password {
    return Intl.message(
      'Enter your email and new password to reset your account password',
      name: 'Enter_email_and_new_password',
      desc: '',
      args: [],
    );
  }

  /// `New Password`
  String get New_Password {
    return Intl.message(
      'New Password',
      name: 'New_Password',
      desc: '',
      args: [],
    );
  }

  /// `Confirm New Password`
  String get Confirm_New_Password {
    return Intl.message(
      'Confirm New Password',
      name: 'Confirm_New_Password',
      desc: '',
      args: [],
    );
  }

  /// `Remember your password?`
  String get Remember_password {
    return Intl.message(
      'Remember your password?',
      name: 'Remember_password',
      desc: '',
      args: [],
    );
  }

  /// `Log In`
  String get Log_In {
    return Intl.message('Log In', name: 'Log_In', desc: '', args: []);
  }

  /// `Please enter your details to create an account.`
  String get Please_enter_details {
    return Intl.message(
      'Please enter your details to create an account.',
      name: 'Please_enter_details',
      desc: '',
      args: [],
    );
  }

  /// `Full Name`
  String get Full_Name {
    return Intl.message('Full Name', name: 'Full_Name', desc: '', args: []);
  }

  /// `Phone Number`
  String get Phone_Number {
    return Intl.message(
      'Phone Number',
      name: 'Phone_Number',
      desc: '',
      args: [],
    );
  }

  /// `Date of Birth`
  String get Date_of_Birth {
    return Intl.message(
      'Date of Birth',
      name: 'Date_of_Birth',
      desc: '',
      args: [],
    );
  }

  /// `City`
  String get City {
    return Intl.message('City', name: 'City', desc: '', args: []);
  }

  /// `Select Preferred City`
  String get Select_Preferred_City {
    return Intl.message(
      'Select Preferred City',
      name: 'Select_Preferred_City',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get Confirm_Password {
    return Intl.message(
      'Confirm Password',
      name: 'Confirm_Password',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account?`
  String get Already_have_account {
    return Intl.message(
      'Already have an account?',
      name: 'Already_have_account',
      desc: '',
      args: [],
    );
  }

  /// `Select Profile Picture`
  String get Select_Profile_Picture {
    return Intl.message(
      'Select Profile Picture',
      name: 'Select_Profile_Picture',
      desc: '',
      args: [],
    );
  }

  /// `Camera`
  String get Camera {
    return Intl.message('Camera', name: 'Camera', desc: '', args: []);
  }

  /// `Gallery`
  String get Gallery {
    return Intl.message('Gallery', name: 'Gallery', desc: '', args: []);
  }

  /// `Tap the red button to remove`
  String get Tap_red_button_to_remove {
    return Intl.message(
      'Tap the red button to remove',
      name: 'Tap_red_button_to_remove',
      desc: '',
      args: [],
    );
  }

  /// `Tap the camera icon to add photo`
  String get Tap_camera_icon_to_add {
    return Intl.message(
      'Tap the camera icon to add photo',
      name: 'Tap_camera_icon_to_add',
      desc: '',
      args: [],
    );
  }

  /// `Passwords do not match`
  String get Passwords_do_not_match {
    return Intl.message(
      'Passwords do not match',
      name: 'Passwords_do_not_match',
      desc: '',
      args: [],
    );
  }

  /// `Password reset successful`
  String get Password_reset_successful {
    return Intl.message(
      'Password reset successful',
      name: 'Password_reset_successful',
      desc: '',
      args: [],
    );
  }

  /// `Login successful`
  String get Login_successful {
    return Intl.message(
      'Login successful',
      name: 'Login_successful',
      desc: '',
      args: [],
    );
  }

  /// `Account created successfully`
  String get Account_created_successfully {
    return Intl.message(
      'Account created successfully',
      name: 'Account_created_successfully',
      desc: '',
      args: [],
    );
  }

  /// `Please select your preferred city`
  String get Please_select_preferred_city {
    return Intl.message(
      'Please select your preferred city',
      name: 'Please_select_preferred_city',
      desc: '',
      args: [],
    );
  }

  /// `Please confirm your password`
  String get Please_confirm_password {
    return Intl.message(
      'Please confirm your password',
      name: 'Please_confirm_password',
      desc: '',
      args: [],
    );
  }

  /// `Please select your preferred city`
  String get Please_select_your_preferred_city {
    return Intl.message(
      'Please select your preferred city',
      name: 'Please_select_your_preferred_city',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
