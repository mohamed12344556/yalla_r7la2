import 'package:flutter/material.dart';
import '../../../../../core/widgets/app_loading_indicator.dart';

class BookingLoadingState extends StatelessWidget {
  final String? message;

  const BookingLoadingState({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(child: AppLoadingIndicator());
  }
}
