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
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
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
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
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
    return Intl.message(
      'Email',
      name: 'Email',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get Password {
    return Intl.message(
      'Password',
      name: 'Password',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Login',
      name: 'Login',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Sign Up',
      name: 'Sign_Up',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Log In',
      name: 'Log_In',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Full Name',
      name: 'Full_Name',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'City',
      name: 'City',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Camera',
      name: 'Camera',
      desc: '',
      args: [],
    );
  }

  /// `Gallery`
  String get Gallery {
    return Intl.message(
      'Gallery',
      name: 'Gallery',
      desc: '',
      args: [],
    );
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

  /// `Cancel Booking`
  String get Cancel_Booking {
    return Intl.message(
      'Cancel Booking',
      name: 'Cancel_Booking',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to cancel your booking to`
  String get Are_you_sure_cancel_booking {
    return Intl.message(
      'Are you sure you want to cancel your booking to',
      name: 'Are_you_sure_cancel_booking',
      desc: '',
      args: [],
    );
  }

  /// `This action cannot be undone. You may be subject to cancellation fees.`
  String get This_action_cannot_be_undone {
    return Intl.message(
      'This action cannot be undone. You may be subject to cancellation fees.',
      name: 'This_action_cannot_be_undone',
      desc: '',
      args: [],
    );
  }

  /// `Keep Booking`
  String get Keep_Booking {
    return Intl.message(
      'Keep Booking',
      name: 'Keep_Booking',
      desc: '',
      args: [],
    );
  }

  /// `Delete Booking`
  String get Delete_Booking {
    return Intl.message(
      'Delete Booking',
      name: 'Delete_Booking',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to permanently delete this booking record? This action cannot be undone.`
  String get Are_you_sure_delete_booking {
    return Intl.message(
      'Are you sure you want to permanently delete this booking record? This action cannot be undone.',
      name: 'Are_you_sure_delete_booking',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get Cancel {
    return Intl.message(
      'Cancel',
      name: 'Cancel',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get Delete {
    return Intl.message(
      'Delete',
      name: 'Delete',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get OK {
    return Intl.message(
      'OK',
      name: 'OK',
      desc: '',
      args: [],
    );
  }

  /// `Retry`
  String get Retry {
    return Intl.message(
      'Retry',
      name: 'Retry',
      desc: '',
      args: [],
    );
  }

  /// `Confirmed`
  String get Confirmed {
    return Intl.message(
      'Confirmed',
      name: 'Confirmed',
      desc: '',
      args: [],
    );
  }

  /// `Cancelled`
  String get Cancelled {
    return Intl.message(
      'Cancelled',
      name: 'Cancelled',
      desc: '',
      args: [],
    );
  }

  /// `Completed`
  String get Completed {
    return Intl.message(
      'Completed',
      name: 'Completed',
      desc: '',
      args: [],
    );
  }

  /// `Pending`
  String get Pending {
    return Intl.message(
      'Pending',
      name: 'Pending',
      desc: '',
      args: [],
    );
  }

  /// `Total Price`
  String get Total_Price {
    return Intl.message(
      'Total Price',
      name: 'Total_Price',
      desc: '',
      args: [],
    );
  }

  /// `for`
  String get for1 {
    return Intl.message(
      'for',
      name: 'for1',
      desc: '',
      args: [],
    );
  }

  /// `person`
  String get person {
    return Intl.message(
      'person',
      name: 'person',
      desc: '',
      args: [],
    );
  }

  /// `people`
  String get people {
    return Intl.message(
      'people',
      name: 'people',
      desc: '',
      args: [],
    );
  }

  /// `Proceed to Payment`
  String get Proceed_to_Payment {
    return Intl.message(
      'Proceed to Payment',
      name: 'Proceed_to_Payment',
      desc: '',
      args: [],
    );
  }

  /// `Unknown Location`
  String get Unknown_Location {
    return Intl.message(
      'Unknown Location',
      name: 'Unknown_Location',
      desc: '',
      args: [],
    );
  }

  /// `No description available`
  String get No_description_available {
    return Intl.message(
      'No description available',
      name: 'No_description_available',
      desc: '',
      args: [],
    );
  }

  /// `Flight Details`
  String get Flight_Details {
    return Intl.message(
      'Flight Details',
      name: 'Flight_Details',
      desc: '',
      args: [],
    );
  }

  /// `Outbound Flight`
  String get Outbound_Flight {
    return Intl.message(
      'Outbound Flight',
      name: 'Outbound_Flight',
      desc: '',
      args: [],
    );
  }

  /// `Return Flight`
  String get Return_Flight {
    return Intl.message(
      'Return Flight',
      name: 'Return_Flight',
      desc: '',
      args: [],
    );
  }

  /// `Direct`
  String get Direct {
    return Intl.message(
      'Direct',
      name: 'Direct',
      desc: '',
      args: [],
    );
  }

  /// `What's Included`
  String get Whats_Included {
    return Intl.message(
      'What\'s Included',
      name: 'Whats_Included',
      desc: '',
      args: [],
    );
  }

  /// `Passengers`
  String get Passengers {
    return Intl.message(
      'Passengers',
      name: 'Passengers',
      desc: '',
      args: [],
    );
  }

  /// `Number of Passengers`
  String get Number_of_Passengers {
    return Intl.message(
      'Number of Passengers',
      name: 'Number_of_Passengers',
      desc: '',
      args: [],
    );
  }

  /// `Price Breakdown`
  String get Price_Breakdown {
    return Intl.message(
      'Price Breakdown',
      name: 'Price_Breakdown',
      desc: '',
      args: [],
    );
  }

  /// `Base Price`
  String get Base_Price {
    return Intl.message(
      'Base Price',
      name: 'Base_Price',
      desc: '',
      args: [],
    );
  }

  /// `Taxes & Fees`
  String get Taxes_and_Fees {
    return Intl.message(
      'Taxes & Fees',
      name: 'Taxes_and_Fees',
      desc: '',
      args: [],
    );
  }

  /// `Total Amount`
  String get Total_Amount {
    return Intl.message(
      'Total Amount',
      name: 'Total_Amount',
      desc: '',
      args: [],
    );
  }

  /// `Passenger`
  String get Passenger {
    return Intl.message(
      'Passenger',
      name: 'Passenger',
      desc: '',
      args: [],
    );
  }

  /// `Travel Dates`
  String get Travel_Dates {
    return Intl.message(
      'Travel Dates',
      name: 'Travel_Dates',
      desc: '',
      args: [],
    );
  }

  /// `Departure`
  String get Departure {
    return Intl.message(
      'Departure',
      name: 'Departure',
      desc: '',
      args: [],
    );
  }

  /// `Return`
  String get Return {
    return Intl.message(
      'Return',
      name: 'Return',
      desc: '',
      args: [],
    );
  }

  /// `Loading...`
  String get Loading {
    return Intl.message(
      'Loading...',
      name: 'Loading',
      desc: '',
      args: [],
    );
  }

  /// `Something went wrong`
  String get Something_went_wrong {
    return Intl.message(
      'Something went wrong',
      name: 'Something_went_wrong',
      desc: '',
      args: [],
    );
  }

  /// `Try Again`
  String get Try_Again {
    return Intl.message(
      'Try Again',
      name: 'Try_Again',
      desc: '',
      args: [],
    );
  }

  /// `Explore Destinations`
  String get Explore_Destinations {
    return Intl.message(
      'Explore Destinations',
      name: 'Explore_Destinations',
      desc: '',
      args: [],
    );
  }

  /// `Monday`
  String get Monday {
    return Intl.message(
      'Monday',
      name: 'Monday',
      desc: '',
      args: [],
    );
  }

  /// `Tuesday`
  String get Tuesday {
    return Intl.message(
      'Tuesday',
      name: 'Tuesday',
      desc: '',
      args: [],
    );
  }

  /// `Wednesday`
  String get Wednesday {
    return Intl.message(
      'Wednesday',
      name: 'Wednesday',
      desc: '',
      args: [],
    );
  }

  /// `Thursday`
  String get Thursday {
    return Intl.message(
      'Thursday',
      name: 'Thursday',
      desc: '',
      args: [],
    );
  }

  /// `Friday`
  String get Friday {
    return Intl.message(
      'Friday',
      name: 'Friday',
      desc: '',
      args: [],
    );
  }

  /// `Saturday`
  String get Saturday {
    return Intl.message(
      'Saturday',
      name: 'Saturday',
      desc: '',
      args: [],
    );
  }

  /// `Sunday`
  String get Sunday {
    return Intl.message(
      'Sunday',
      name: 'Sunday',
      desc: '',
      args: [],
    );
  }

  /// `Book`
  String get Book {
    return Intl.message(
      'Book',
      name: 'Book',
      desc: '',
      args: [],
    );
  }

  /// `Booking Successful!`
  String get Booking_Successful {
    return Intl.message(
      'Booking Successful!',
      name: 'Booking_Successful',
      desc: '',
      args: [],
    );
  }

  /// `Your booking has been confirmed for`
  String get Your_booking_has_been_confirmed_for {
    return Intl.message(
      'Your booking has been confirmed for',
      name: 'Your_booking_has_been_confirmed_for',
      desc: '',
      args: [],
    );
  }

  /// `slots remaining`
  String get slots_remaining {
    return Intl.message(
      'slots remaining',
      name: 'slots_remaining',
      desc: '',
      args: [],
    );
  }

  /// `View Bookings`
  String get View_Bookings {
    return Intl.message(
      'View Bookings',
      name: 'View_Bookings',
      desc: '',
      args: [],
    );
  }

  /// `Done`
  String get Done {
    return Intl.message(
      'Done',
      name: 'Done',
      desc: '',
      args: [],
    );
  }

  /// `Booking Failed`
  String get Booking_Failed {
    return Intl.message(
      'Booking Failed',
      name: 'Booking_Failed',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Booking`
  String get Confirm_Booking {
    return Intl.message(
      'Confirm Booking',
      name: 'Confirm_Booking',
      desc: '',
      args: [],
    );
  }

  /// `Destination`
  String get Destination {
    return Intl.message(
      'Destination',
      name: 'Destination',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get Confirm {
    return Intl.message(
      'Confirm',
      name: 'Confirm',
      desc: '',
      args: [],
    );
  }

  /// `Booking...`
  String get Booking {
    return Intl.message(
      'Booking...',
      name: 'Booking',
      desc: '',
      args: [],
    );
  }

  /// `Already Booked`
  String get Already_Booked {
    return Intl.message(
      'Already Booked',
      name: 'Already_Booked',
      desc: '',
      args: [],
    );
  }

  /// `You have already booked this destination`
  String get You_have_already_booked_this_destination {
    return Intl.message(
      'You have already booked this destination',
      name: 'You_have_already_booked_this_destination',
      desc: '',
      args: [],
    );
  }

  /// `Date Conflict`
  String get Date_Conflict {
    return Intl.message(
      'Date Conflict',
      name: 'Date_Conflict',
      desc: '',
      args: [],
    );
  }

  /// `Your selected dates conflict with existing booking`
  String get Your_selected_dates_conflict_with_existing_booking {
    return Intl.message(
      'Your selected dates conflict with existing booking',
      name: 'Your_selected_dates_conflict_with_existing_booking',
      desc: '',
      args: [],
    );
  }

  /// `You have already booked`
  String get You_have_already_booked {
    return Intl.message(
      'You have already booked',
      name: 'You_have_already_booked',
      desc: '',
      args: [],
    );
  }

  /// `Check your bookings to view details.`
  String get Check_your_bookings_to_view_details {
    return Intl.message(
      'Check your bookings to view details.',
      name: 'Check_your_bookings_to_view_details',
      desc: '',
      args: [],
    );
  }

  /// `Bookmark feature coming soon!`
  String get Bookmark_feature_coming_soon {
    return Intl.message(
      'Bookmark feature coming soon!',
      name: 'Bookmark_feature_coming_soon',
      desc: '',
      args: [],
    );
  }

  /// `My Bookings`
  String get My_Bookings {
    return Intl.message(
      'My Bookings',
      name: 'My_Bookings',
      desc: '',
      args: [],
    );
  }

  /// `All Bookings`
  String get All_Bookings {
    return Intl.message(
      'All Bookings',
      name: 'All_Bookings',
      desc: '',
      args: [],
    );
  }

  /// `Upcoming Bookings`
  String get Upcoming_Bookings {
    return Intl.message(
      'Upcoming Bookings',
      name: 'Upcoming_Bookings',
      desc: '',
      args: [],
    );
  }

  /// `Past Bookings`
  String get Past_Bookings {
    return Intl.message(
      'Past Bookings',
      name: 'Past_Bookings',
      desc: '',
      args: [],
    );
  }

  /// `Booking cancelled successfully`
  String get Booking_cancelled_successfully {
    return Intl.message(
      'Booking cancelled successfully',
      name: 'Booking_cancelled_successfully',
      desc: '',
      args: [],
    );
  }

  /// `Booking deleted successfully`
  String get Booking_deleted_successfully {
    return Intl.message(
      'Booking deleted successfully',
      name: 'Booking_deleted_successfully',
      desc: '',
      args: [],
    );
  }

  /// `Something went wrong`
  String get Something_went_wrong_message {
    return Intl.message(
      'Something went wrong',
      name: 'Something_went_wrong_message',
      desc: '',
      args: [],
    );
  }

  /// `Please try again later`
  String get Please_try_again_later {
    return Intl.message(
      'Please try again later',
      name: 'Please_try_again_later',
      desc: '',
      args: [],
    );
  }

  /// `Booking ID`
  String get Booking_ID {
    return Intl.message(
      'Booking ID',
      name: 'Booking_ID',
      desc: '',
      args: [],
    );
  }

  /// `Booked`
  String get Booked {
    return Intl.message(
      'Booked',
      name: 'Booked',
      desc: '',
      args: [],
    );
  }

  /// `Details`
  String get Details {
    return Intl.message(
      'Details',
      name: 'Details',
      desc: '',
      args: [],
    );
  }

  /// `Your AI assistant is ready to help`
  String get ai_assistant {
    return Intl.message(
      'Your AI assistant is ready to help',
      name: 'ai_assistant',
      desc: '',
      args: [],
    );
  }

  /// `My Favorites`
  String get favoritesTitle {
    return Intl.message(
      'My Favorites',
      name: 'favoritesTitle',
      desc: '',
      args: [],
    );
  }

  /// `Location`
  String get homeLocationLabel {
    return Intl.message(
      'Location',
      name: 'homeLocationLabel',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to Yalla R7la!`
  String get homeWelcomeTitle {
    return Intl.message(
      'Welcome to Yalla R7la!',
      name: 'homeWelcomeTitle',
      desc: '',
      args: [],
    );
  }

  /// `No favorites yet`
  String get noFavoritesYet {
    return Intl.message(
      'No favorites yet',
      name: 'noFavoritesYet',
      desc: '',
      args: [],
    );
  }

  /// `Add some destinations to your favorites`
  String get addFavoritesPrompt {
    return Intl.message(
      'Add some destinations to your favorites',
      name: 'addFavoritesPrompt',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get Language {
    return Intl.message(
      'Language',
      name: 'Language',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get English {
    return Intl.message(
      'English',
      name: 'English',
      desc: '',
      args: [],
    );
  }

  /// `Arabic`
  String get Arabic {
    return Intl.message(
      'Arabic',
      name: 'Arabic',
      desc: '',
      args: [],
    );
  }

  /// `Log Out`
  String get LogOut {
    return Intl.message(
      'Log Out',
      name: 'LogOut',
      desc: '',
      args: [],
    );
  }

  /// `Clear`
  String get Clear {
    return Intl.message(
      'Clear',
      name: 'Clear',
      desc: '',
      args: [],
    );
  }

  /// `Search results`
  String get searchResults {
    return Intl.message(
      'Search results',
      name: 'searchResults',
      desc: '',
      args: [],
    );
  }

  /// `Added to favorites`
  String get addedToFavorites {
    return Intl.message(
      'Added to favorites',
      name: 'addedToFavorites',
      desc: '',
      args: [],
    );
  }

  /// `Removed from favorites`
  String get removedFromFavorites {
    return Intl.message(
      'Removed from favorites',
      name: 'removedFromFavorites',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get homeTabLabel {
    return Intl.message(
      'Home',
      name: 'homeTabLabel',
      desc: '',
      args: [],
    );
  }

  /// `Favorites`
  String get favoritesTabLabel {
    return Intl.message(
      'Favorites',
      name: 'favoritesTabLabel',
      desc: '',
      args: [],
    );
  }

  /// `Bookings`
  String get bookingsTabLabel {
    return Intl.message(
      'Bookings',
      name: 'bookingsTabLabel',
      desc: '',
      args: [],
    );
  }

  /// `Chat`
  String get chatTabLabel {
    return Intl.message(
      'Chat',
      name: 'chatTabLabel',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profileTabLabel {
    return Intl.message(
      'Profile',
      name: 'profileTabLabel',
      desc: '',
      args: [],
    );
  }

  /// `1/2`
  String get imageCounter {
    return Intl.message(
      '1/2',
      name: 'imageCounter',
      desc: '',
      args: [],
    );
  }

  /// `Search destinations...`
  String get searchHint {
    return Intl.message(
      'Search destinations...',
      name: 'searchHint',
      desc: '',
      args: [],
    );
  }

  /// `Categories`
  String get categoriesLabel {
    return Intl.message(
      'Categories',
      name: 'categoriesLabel',
      desc: '',
      args: [],
    );
  }

  /// `See All`
  String get seeAllButton {
    return Intl.message(
      'See All',
      name: 'seeAllButton',
      desc: '',
      args: [],
    );
  }

  /// `AI Search`
  String get aiSearchTitle {
    return Intl.message(
      'AI Search',
      name: 'aiSearchTitle',
      desc: '',
      args: [],
    );
  }

  /// `Upload an image and add description to find similar destinations`
  String get aiSearchDescription {
    return Intl.message(
      'Upload an image and add description to find similar destinations',
      name: 'aiSearchDescription',
      desc: '',
      args: [],
    );
  }

  /// `Tap to add image`
  String get addImagePrompt {
    return Intl.message(
      'Tap to add image',
      name: 'addImagePrompt',
      desc: '',
      args: [],
    );
  }

  /// `Describe what you're looking for...`
  String get aiSearchTextHint {
    return Intl.message(
      'Describe what you\'re looking for...',
      name: 'aiSearchTextHint',
      desc: '',
      args: [],
    );
  }

  /// `Search with AI`
  String get searchWithAIButton {
    return Intl.message(
      'Search with AI',
      name: 'searchWithAIButton',
      desc: '',
      args: [],
    );
  }

  /// `Select Image Source`
  String get selectImageSourceTitle {
    return Intl.message(
      'Select Image Source',
      name: 'selectImageSourceTitle',
      desc: '',
      args: [],
    );
  }

  /// `Gallery`
  String get galleryOption {
    return Intl.message(
      'Gallery',
      name: 'galleryOption',
      desc: '',
      args: [],
    );
  }

  /// `Camera`
  String get cameraOption {
    return Intl.message(
      'Camera',
      name: 'cameraOption',
      desc: '',
      args: [],
    );
  }

  /// `Error picking image`
  String get errorPickingImage {
    return Intl.message(
      'Error picking image',
      name: 'errorPickingImage',
      desc: '',
      args: [],
    );
  }

  /// `Searching for`
  String get searchingFor {
    return Intl.message(
      'Searching for',
      name: 'searchingFor',
      desc: '',
      args: [],
    );
  }

  /// `Search failed`
  String get searchFailed {
    return Intl.message(
      'Search failed',
      name: 'searchFailed',
      desc: '',
      args: [],
    );
  }

  /// `Top Trips`
  String get topTripsLabel {
    return Intl.message(
      'Top Trips',
      name: 'topTripsLabel',
      desc: '',
      args: [],
    );
  }

  /// `trips`
  String get tripsCount {
    return Intl.message(
      'trips',
      name: 'tripsCount',
      desc: '',
      args: [],
    );
  }

  /// `Loading more destinations...`
  String get loadingMoreDestinations {
    return Intl.message(
      'Loading more destinations...',
      name: 'loadingMoreDestinations',
      desc: '',
      args: [],
    );
  }

  /// `No trips found`
  String get noTripsFound {
    return Intl.message(
      'No trips found',
      name: 'noTripsFound',
      desc: '',
      args: [],
    );
  }

  /// `Try selecting a different category or refresh`
  String get noTripsFoundPrompt {
    return Intl.message(
      'Try selecting a different category or refresh',
      name: 'noTripsFoundPrompt',
      desc: '',
      args: [],
    );
  }

  /// `Page 1`
  String get pageInfo {
    return Intl.message(
      'Page 1',
      name: 'pageInfo',
      desc: '',
      args: [],
    );
  }

  /// `Load More`
  String get loadMoreButton {
    return Intl.message(
      'Load More',
      name: 'loadMoreButton',
      desc: '',
      args: [],
    );
  }

  /// `Loading...`
  String get loadingLabel {
    return Intl.message(
      'Loading...',
      name: 'loadingLabel',
      desc: '',
      args: [],
    );
  }

  /// `Refresh`
  String get refreshButton {
    return Intl.message(
      'Refresh',
      name: 'refreshButton',
      desc: '',
      args: [],
    );
  }

  /// `Image failed to load`
  String get imageFailedToLoad {
    return Intl.message(
      'Image failed to load',
      name: 'imageFailedToLoad',
      desc: '',
      args: [],
    );
  }

  /// `No Image Available`
  String get noImageAvailable {
    return Intl.message(
      'No Image Available',
      name: 'noImageAvailable',
      desc: '',
      args: [],
    );
  }

  /// `/person`
  String get perPerson {
    return Intl.message(
      '/person',
      name: 'perPerson',
      desc: '',
      args: [],
    );
  }

  /// `spots available`
  String get spotsAvailable {
    return Intl.message(
      'spots available',
      name: 'spotsAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Price on request`
  String get priceOnRequest {
    return Intl.message(
      'Price on request',
      name: 'priceOnRequest',
      desc: '',
      args: [],
    );
  }

  /// `% OFF`
  String get discountBadge {
    return Intl.message(
      '% OFF',
      name: 'discountBadge',
      desc: '',
      args: [],
    );
  }

  /// `POPULAR`
  String get popularBadge {
    return Intl.message(
      'POPULAR',
      name: 'popularBadge',
      desc: '',
      args: [],
    );
  }

  /// `Added to favorites!`
  String get addedToFavoritesWithExclamation {
    return Intl.message(
      'Added to favorites!',
      name: 'addedToFavoritesWithExclamation',
      desc: '',
      args: [],
    );
  }

  /// `Removed from favorites!`
  String get removedFromFavoritesWithExclamation {
    return Intl.message(
      'Removed from favorites!',
      name: 'removedFromFavoritesWithExclamation',
      desc: '',
      args: [],
    );
  }

  /// `View All`
  String get viewAllFavorites {
    return Intl.message(
      'View All',
      name: 'viewAllFavorites',
      desc: '',
      args: [],
    );
  }

  /// `Error loading destination`
  String get errorLoadingDestination {
    return Intl.message(
      'Error loading destination',
      name: 'errorLoadingDestination',
      desc: '',
      args: [],
    );
  }

  /// `No destination data found`
  String get noDestinationDataFound {
    return Intl.message(
      'No destination data found',
      name: 'noDestinationDataFound',
      desc: '',
      args: [],
    );
  }

  /// `View Photo Gallery`
  String get viewPhotoGallery {
    return Intl.message(
      'View Photo Gallery',
      name: 'viewPhotoGallery',
      desc: '',
      args: [],
    );
  }

  /// `photos available`
  String get photosAvailable {
    return Intl.message(
      'photos available',
      name: 'photosAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Starting Price`
  String get startingPrice {
    return Intl.message(
      'Starting Price',
      name: 'startingPrice',
      desc: '',
      args: [],
    );
  }

  /// `About This Destination`
  String get aboutThisDestination {
    return Intl.message(
      'About This Destination',
      name: 'aboutThisDestination',
      desc: '',
      args: [],
    );
  }

  /// `What's Included`
  String get whatsIncluded {
    return Intl.message(
      'What\'s Included',
      name: 'whatsIncluded',
      desc: '',
      args: [],
    );
  }

  /// `Location`
  String get location {
    return Intl.message(
      'Location',
      name: 'location',
      desc: '',
      args: [],
    );
  }

  /// `Interactive Map`
  String get interactiveMap {
    return Intl.message(
      'Interactive Map',
      name: 'interactiveMap',
      desc: '',
      args: [],
    );
  }

  /// `Coming Soon`
  String get comingSoon {
    return Intl.message(
      'Coming Soon',
      name: 'comingSoon',
      desc: '',
      args: [],
    );
  }

  /// `View`
  String get viewMap {
    return Intl.message(
      'View',
      name: 'viewMap',
      desc: '',
      args: [],
    );
  }

  /// `Discover this amazing destination with breathtaking views and unforgettable experiences. Perfect for travelers seeking adventure and natural beauty.`
  String get defaultDescription {
    return Intl.message(
      'Discover this amazing destination with breathtaking views and unforgettable experiences. Perfect for travelers seeking adventure and natural beauty.',
      name: 'defaultDescription',
      desc: '',
      args: [],
    );
  }

  /// `Destination`
  String get defaultDestination {
    return Intl.message(
      'Destination',
      name: 'defaultDestination',
      desc: '',
      args: [],
    );
  }

  /// `Book Now`
  String get bookNow {
    return Intl.message(
      'Book Now',
      name: 'bookNow',
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
