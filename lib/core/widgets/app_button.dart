import 'package:flutter/material.dart';
import 'package:p1/core/themes/app_colors.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final bool isFullWidth;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final double? fontSize;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final double? elevation;
  final Widget? child;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.isFullWidth = true,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
    this.fontSize,
    this.borderRadius,
    this.padding,
    this.elevation,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final double defaultHeight = height ?? 52;
    final double defaultWidth = isFullWidth ? double.infinity : (width ?? 160);
    final Color defaultBgColor =
        backgroundColor ??
        (isOutlined ? Colors.transparent : AppColors.primary);
    final Color defaultTextColor =
        textColor ?? (isOutlined ? AppColors.primary : Colors.white);
    final BorderRadius defaultBorderRadius =
        borderRadius ?? BorderRadius.circular(12);
    final EdgeInsetsGeometry defaultPadding =
        padding ??
        EdgeInsets.symmetric(
          vertical: icon != null ? 12 : 16,
          horizontal: icon != null ? 16 : 24,
        );
    final double buttonElevation = elevation ?? (isOutlined ? 0 : 2);

    final ButtonStyle buttonStyle =
        isOutlined
            ? OutlinedButton.styleFrom(
              foregroundColor: defaultTextColor,
              side: BorderSide(color: defaultTextColor, width: 1.5),
              padding: defaultPadding,
              shape: RoundedRectangleBorder(borderRadius: defaultBorderRadius),
              elevation: buttonElevation,
            )
            : ElevatedButton.styleFrom(
              backgroundColor: defaultBgColor,
              foregroundColor: defaultTextColor,
              disabledBackgroundColor: defaultBgColor.withOpacity(0.6),
              disabledForegroundColor: defaultTextColor.withOpacity(0.7),
              elevation: buttonElevation,
              shadowColor: defaultBgColor.withOpacity(0.4),
              padding: defaultPadding,
              shape: RoundedRectangleBorder(borderRadius: defaultBorderRadius),
            );

    final Widget buttonChild =
        child ??
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20),
              const SizedBox(width: 8),
            ],
            if (isLoading) ...[
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  color: defaultTextColor,
                  strokeWidth: 2,
                ),
              ),
              const SizedBox(width: 12),
            ],
            Text(
              text,
              style: TextStyle(
                fontSize: fontSize ?? 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
                height: 1.2,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        );
    return SizedBox(
      width: defaultWidth,
      height: defaultHeight,
      child:
          isOutlined
              ? OutlinedButton(
                onPressed: isLoading ? null : onPressed,
                style: buttonStyle,
                child: buttonChild,
              )
              : ElevatedButton(
                onPressed: isLoading ? null : onPressed,
                style: buttonStyle,
                child: buttonChild,
              ),
    );
  }
}
