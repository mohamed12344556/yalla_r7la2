import 'package:flutter/material.dart';

class AppColors {
  //Private constructor to prevent instantiation
  AppColors._();

  // ===== PRIMARY BRAND COLORS =====
  /// Main brand color - Teal/Turquoise from the app interface
  static const Color primary = Color(0xFF00BCD4);

  /// Secondary brand color - Darker teal for variety
  static const Color secondary = Color(0xFF0097A7);

  /// Tertiary color - Light teal for accents
  static const Color tertiary = Color(0xFF4DD0E1);

  // ===== MATERIAL 3 COLOR SCHEME =====
  // Primary colors
  static const Color primaryContainer = Color(0xFFE0F7FA);
  static const Color onPrimary = Colors.white;
  static const Color onPrimaryContainer = Color(0xFF006064);

  // Secondary colors
  static const Color secondaryContainer = Color(0xFFE0F2F1);
  static const Color onSecondary = Colors.white;
  static const Color onSecondaryContainer = Color(0xFF004D40);

  // Tertiary colors
  static const Color tertiaryContainer = Color(0xFFE1F5FE);
  static const Color onTertiary = Color(0xFF0D47A1);
  static const Color onTertiaryContainer = Color(0xFF01579B);

  // ===== SURFACE COLORS =====
  // Light theme surfaces
  static const Color surface = Color(0xFFFAFAFA);
  static const Color surfaceVariant = Color(0xFFF5F5F5);
  static const Color surfaceContainer = Color(0xFFFFFFFF);
  static const Color surfaceContainerHighest = Color(0xFFEEEEEE);
  static const Color onSurface = Color(0xFF212121);
  static const Color onSurfaceVariant = Color(0xFF424242);

  // Dark theme surfaces
  static const Color surfaceDark = Color(0xFF111111);
  static const Color surfaceVariantDark = Color(0xFF1e1e1e);
  static const Color surfaceContainerDark = Color(0xFF1a1a1a);
  static const Color surfaceContainerHighestDark = Color(0xFF2c2c2c);
  static const Color onSurfaceDark = Color(0xFFe6e1e5);
  static const Color onSurfaceVariantDark = Color(0xFFcac4d0);

  // ===== BACKGROUND COLORS =====
  static const Color background = Color(0xFFFAFAFA);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color onBackground = Color(0xFF212121);
  static const Color onBackgroundDark = Color(0xFFE0E0E0);

  // ===== TEXT COLORS =====
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textTertiary = Color(0xFF9E9E9E);
  static const Color textHint = Color(0xFFBDBDBD);

  // Dark theme text
  static const Color textPrimaryDark = Color(0xFFe6e1e5);
  static const Color textSecondaryDark = Color(0xFFcac4d0);
  static const Color textTertiaryDark = Color(0xFF938f99);
  static const Color textHintDark = Color(0xFF625b71);

  // ===== OUTLINE & BORDER COLORS =====
  static const Color outline = Color(0xFF79747e);
  static const Color outlineVariant = Color(0xFFcac4d0);
  static const Color outlineDark = Color(0xFF938f99);
  static const Color outlineVariantDark = Color(0xFF49454f);

  // Legacy border colors for compatibility
  static const Color border = Color(0xFFe0e0e0);
  static const Color divider = Color(0xFFeeeeee);
  static const Color dividerDark = Color(0xFF2c2c2c);

  // ===== STATUS & SEMANTIC COLORS =====
  static const Color success = Color(0xFF4caf50);
  static const Color successContainer = Color(0xFFe8f5e8);
  static const Color onSuccess = Colors.white;
  static const Color onSuccessContainer = Color(0xFF1b5e1f);

  static const Color warning = Color(0xFFff9800);
  static const Color warningContainer = Color(0xFFfff3e0);
  static const Color onWarning = Colors.white;
  static const Color onWarningContainer = Color(0xFF663c00);

  static const Color error = Color(0xFFe53935);
  static const Color errorContainer = Color(0xFFffebe9);
  static const Color onError = Colors.white;
  static const Color onErrorContainer = Color(0xFF5f1415);

  static const Color info = Color(0xFF2196f3);
  static const Color infoContainer = Color(0xFFe3f2fd);
  static const Color onInfo = Colors.white;
  static const Color onInfoContainer = Color(0xFF0d47a1);

  // ===== INTERACTION STATES =====
  static const Color pressed = Color(0x1F000000); // 12% black overlay
  static const Color hover = Color(0x14000000); // 8% black overlay
  static const Color focused = Color(0x1F00BCD4); // 12% primary overlay
  static const Color selected = Color(0x1F00BCD4); // 12% primary overlay
  static const Color disabled = Color(0x61000000); // 38% black overlay
  static const Color disabledContainer = Color(0x1F000000); // 12% black overlay

  // Dark theme interaction states
  static const Color pressedDark = Color(0x1FFFFFFF); // 12% white overlay
  static const Color hoverDark = Color(0x14FFFFFF); // 8% white overlay
  static const Color focusedDark = Color(0x1F00BCD4); // 12% primary overlay
  static const Color selectedDark = Color(0x1F00BCD4); // 12% primary overlay
  static const Color disabledDark = Color(0x61FFFFFF); // 38% white overlay
  static const Color disabledContainerDark = Color(
    0x1FFFFFFF,
  ); // 12% white overlay

  // ===== INPUT & FORM COLORS =====
  static const Color inputFill = Color(0xFFFFFFFF);
  static const Color inputFillDark = Color(0xFF2C2C2C);
  static const Color inputBorder = Color(0xFFE0E0E0);
  static const Color inputBorderDark = Color(0xFF424242);

  // ===== CHIP COLORS =====
  static const Color chipSelected = primary;
  static const Color chipSelectedContainer = primaryContainer;
  static const Color chipUnselected = surface;
  static const Color chipUnselectedDark = surfaceVariantDark;

  // ===== LEGACY COLORS (for backward compatibility) =====
  @deprecated
  static const Color lightGrey = Color(0xFFe9ecef);
  @deprecated
  static const Color darkBackground = backgroundDark;
  @deprecated
  static const Color darkSurface = surfaceDark;
  @deprecated
  static const Color darkSecondary = surfaceVariantDark;
  @deprecated
  static const Color text = textPrimary;
  @deprecated
  static const Color selectedChip = chipSelected;
  @deprecated
  static const Color unselectedChip = chipUnselected;
  @deprecated
  static const Color buttonColor = tertiary;

  // ===== TRANSPARENT OVERLAYS =====
  static const Color black12 = Color(0x1F000000);
  static const Color black26 = Color(0x42000000);
  static const Color black38 = Color(0x61000000);
  static const Color black54 = Color(0x8A000000);
  static const Color white10 = Color(0x1AFFFFFF);
  static const Color white12 = Color(0x1FFFFFFF);
  static const Color white70 = Color(0xB3FFFFFF);

  // ===== HELPER METHODS =====
  /// Returns appropriate text color based on background brightness
  static Color getTextColorForBackground(Color backgroundColor) {
    return ThemeData.estimateBrightnessForColor(backgroundColor) ==
            Brightness.dark
        ? textPrimaryDark
        : textPrimary;
  }

  /// Returns appropriate surface color based on theme brightness
  static Color getSurfaceColor(Brightness brightness) {
    return brightness == Brightness.dark ? surfaceDark : surface;
  }

  /// Returns appropriate outline color based on theme brightness
  static Color getOutlineColor(Brightness brightness) {
    return brightness == Brightness.dark ? outlineDark : outline;
  }
}
