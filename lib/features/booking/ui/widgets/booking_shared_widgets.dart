import 'package:flutter/material.dart';
import 'package:yalla_r7la2/core/themes/booking_constants.dart';
import 'package:yalla_r7la2/core/widgets/app_loading_indicator.dart';
import 'package:yalla_r7la2/features/booking/data/models/booking_models.dart';

/// Shared widgets used across booking screens
class BookingSharedWidgets {
  /// Status chip widget used in multiple screens
  static Widget buildStatusChip(BookingStatus status) {
    Color color;
    String text;

    switch (status) {
      case BookingStatus.confirmed:
        color = Colors.green;
        text = 'Confirmed';
        break;
      case BookingStatus.cancelled:
        color = Colors.red;
        text = 'Cancelled';
        break;
      case BookingStatus.completed:
        color = Colors.blue;
        text = 'Completed';
        break;
      case BookingStatus.pending:
        color = Colors.orange;
        text = 'Pending';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// Common price row widget for price breakdowns
  static Widget buildPriceRow(
    String title,
    String subtitle,
    String price, {
    bool isTotal = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: isTotal ? 18 : 16,
                fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
                color: isTotal ? Colors.blueAccent : Colors.black87,
              ),
            ),
            if (subtitle.isNotEmpty)
              Text(subtitle, style: BookingConstants.captionStyle),
          ],
        ),
        Text(
          price,
          style: TextStyle(
            fontSize: isTotal ? 20 : 16,
            fontWeight: FontWeight.bold,
            color: isTotal ? Colors.blueAccent : Colors.black87,
          ),
        ),
      ],
    );
  }

  /// Common date and time info widget
  static Widget buildDateInfo(
    String title,
    String date,
    String time,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blueAccent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: Colors.blueAccent),
              const SizedBox(width: 4),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            date,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          Text(time, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
      ),
    );
  }

  /// Common section container with title and content
  static Widget buildSection({
    required String title,
    required Widget child,
    EdgeInsets? padding,
    Color? backgroundColor,
    Border? border,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: BookingConstants.subtitleStyle),
        const SizedBox(height: 16),
        Container(
          padding: padding ?? BookingConstants.cardPadding,
          decoration: BoxDecoration(
            color: backgroundColor ?? Colors.white,
            borderRadius: BookingConstants.cardRadius,
            border:
                border ?? Border.all(color: Colors.blueAccent.withOpacity(0.3)),
            boxShadow: BookingConstants.cardShadow,
          ),
          child: child,
        ),
      ],
    );
  }

  /// Common empty state widget
  static Widget buildEmptyState({
    required String message,
    required String subMessage,
    required IconData icon,
    VoidCallback? onActionPressed,
    String actionText = 'Explore Destinations',
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            subMessage,
            style: TextStyle(fontSize: 16, color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
          if (onActionPressed != null) ...[
            const SizedBox(height: 24),
            _buildActionButton(onPressed: onActionPressed, text: actionText),
          ],
        ],
      ),
    );
  }

  /// Common loading state widget
  static Widget buildLoadingState({String? message}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppLoadingIndicator(),
          const SizedBox(height: 16),
          Text(
            message ?? 'Loading...',
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  /// Common error state widget
  static Widget buildErrorState({
    required String message,
    VoidCallback? onRetry,
    String? title,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 80, color: Colors.red[300]),
          const SizedBox(height: 16),
          Text(
            title ?? 'Something went wrong',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: TextStyle(fontSize: 16, color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Common info row widget (icon + title + value)
  static Widget buildInfoRow({
    required String title,
    required String value,
    required IconData icon,
    Color? iconColor,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18, color: iconColor ?? Colors.blueAccent),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: BookingConstants.captionStyle),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Common passenger info widget
  static Widget buildPassengerInfo(int passengers) {
    return Row(
      children: [
        const Icon(Icons.person, size: 16, color: Colors.blueAccent),
        const SizedBox(width: 4),
        Text(
          '$passengers ${passengers == 1 ? 'Passenger' : 'Passengers'}',
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  /// Common price display widget
  static Widget buildPriceDisplay(double amount, {bool isLarge = false}) {
    return Text(
      '\$${amount.toStringAsFixed(0)}',
      style: TextStyle(
        fontSize: isLarge ? 20 : 18,
        fontWeight: FontWeight.bold,
        color: Colors.blueAccent,
      ),
    );
  }

  /// Common gradient app bar
  static PreferredSizeWidget buildGradientAppBar({
    required String title,
    VoidCallback? onBackPressed,
    List<Widget>? actions,
    PreferredSizeWidget? bottom,
  }) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24,
          color: Colors.white,
        ),
      ),
      flexibleSpace: Container(
        decoration: BoxDecoration(gradient: BookingConstants.primaryGradient),
      ),
      elevation: 0,
      centerTitle: true,
      leading:
          onBackPressed != null
              ? IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: onBackPressed,
              )
              : null,
      actions: actions,
      bottom: bottom,
      iconTheme: const IconThemeData(color: Colors.white),
    );
  }

  /// Common divider with custom styling
  static Widget buildDivider({double height = 1.0, Color? color}) {
    return Divider(
      height: height * 2,
      thickness: height,
      color: color ?? Colors.grey.withOpacity(0.3),
    );
  }

  /// Common action button for empty states
  static Widget _buildActionButton({
    required VoidCallback onPressed,
    required String text,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.blueAccent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.blueAccent.withOpacity(0.3)),
      ),
      child: GestureDetector(
        onTap: onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.explore, color: Colors.blueAccent, size: 20),
            const SizedBox(width: 8),
            Text(
              text,
              style: const TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Common card decoration
  static BoxDecoration getCardDecoration({
    Color? color,
    List<BoxShadow>? boxShadow,
    BorderRadius? borderRadius,
    Border? border,
  }) {
    return BoxDecoration(
      color: color ?? Colors.white,
      borderRadius: borderRadius ?? BookingConstants.cardRadius,
      boxShadow: boxShadow ?? BookingConstants.cardShadow,
      border: border,
    );
  }

  /// Common image with error handling
  static Widget buildNetworkImage({
    required String imageUrl,
    required double width,
    required double height,
    BoxFit fit = BoxFit.cover,
    BorderRadius? borderRadius,
  }) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(8),
      child: Image.network(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: borderRadius ?? BorderRadius.circular(8),
            ),
            child: const Icon(Icons.image, color: Colors.grey, size: 32),
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: borderRadius ?? BorderRadius.circular(8),
            ),
            child: const Center(child: AppLoadingIndicator()),
          );
        },
      ),
    );
  }
}
