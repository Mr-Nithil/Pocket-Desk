import 'package:flutter/material.dart';
import 'package:pocket_desk/config/theme/color_palette.dart';

class AppTheme {
  static OutlineInputBorder _border(Color color) => OutlineInputBorder(
    borderSide: BorderSide(color: color, width: 1),
    borderRadius: BorderRadius.circular(16),
  );

  static ThemeData _buildTheme({
    required Brightness brightness,
    required Color scaffoldBackgroundColor,
    required Color secondaryBackgroundColor,
    required Color surfaceColor,
    required Color borderColor,
    required Color primaryTextColor,
    required Color secondaryTextColor,
    required Color disabledTextColor,
    required Color accentColor,
    required Color accentSoftColor,
    required Color chipBackgroundColor,
    required Color chipTextColor,
    required Color elevatedSurfaceColor,
  }) {
    final baseTheme = brightness == Brightness.dark
        ? ThemeData.dark(useMaterial3: true)
        : ThemeData.light(useMaterial3: true);

    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: accentColor,
      onPrimary: Colors.white,
      secondary: accentColor,
      onSecondary: Colors.white,
      error: ColorPalette.errorColor,
      onError: Colors.white,
      surface: surfaceColor,
      onSurface: primaryTextColor,
      surfaceContainerHighest: elevatedSurfaceColor,
      onSurfaceVariant: secondaryTextColor,
      outline: borderColor,
      outlineVariant: borderColor,
      tertiary: accentSoftColor,
      onTertiary: primaryTextColor,
      primaryContainer: accentSoftColor,
      onPrimaryContainer: primaryTextColor,
      secondaryContainer: accentSoftColor,
      onSecondaryContainer: primaryTextColor,
      surfaceTint: accentColor,
      inverseSurface: secondaryBackgroundColor,
      onInverseSurface: primaryTextColor,
      inversePrimary: accentColor,
      shadow: ColorPalette.shadowColor,
      scrim: Colors.black,
    );

    return baseTheme.copyWith(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      appBarTheme: AppBarTheme(
        backgroundColor: scaffoldBackgroundColor,
        foregroundColor: primaryTextColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: secondaryTextColor),
        titleTextStyle: TextStyle(
          color: primaryTextColor,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      cardTheme: CardThemeData(
        color: surfaceColor,
        elevation: brightness == Brightness.dark ? 0 : 1,
        shadowColor: ColorPalette.shadowColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: borderColor),
        ),
        margin: EdgeInsets.zero,
      ),
      dividerTheme: DividerThemeData(color: borderColor, thickness: 1),
      chipTheme: ChipThemeData(
        backgroundColor: chipBackgroundColor,
        selectedColor: accentSoftColor,
        labelStyle: TextStyle(
          color: chipTextColor,
          fontWeight: FontWeight.w600,
        ),
        side: BorderSide(color: borderColor),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: secondaryBackgroundColor,
        border: _border(borderColor),
        enabledBorder: _border(borderColor),
        focusedBorder: _border(accentColor),
        errorBorder: _border(ColorPalette.errorColor),
        focusedErrorBorder: _border(ColorPalette.errorColor),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        hintStyle: TextStyle(color: disabledTextColor),
        labelStyle: TextStyle(color: secondaryTextColor),
      ),
      textTheme: baseTheme.textTheme
          .apply(bodyColor: primaryTextColor, displayColor: primaryTextColor)
          .copyWith(
            bodyMedium: TextStyle(color: primaryTextColor, height: 1.5),
            bodySmall: TextStyle(color: secondaryTextColor, height: 1.4),
            titleLarge: TextStyle(
              color: primaryTextColor,
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
            titleMedium: TextStyle(
              color: primaryTextColor,
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
          ),
      iconTheme: IconThemeData(color: secondaryTextColor),
      primaryIconTheme: IconThemeData(color: accentColor),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentColor,
          foregroundColor: Colors.white,
          disabledBackgroundColor: accentColor.withOpacity(0.55),
          disabledForegroundColor: Colors.white.withOpacity(0.72),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryTextColor,
          side: BorderSide(color: borderColor),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: accentColor,
        foregroundColor: Colors.white,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: brightness == Brightness.dark
            ? const Color(0xFFF8FAFC)
            : const Color(0xFF111827),
        contentTextStyle: TextStyle(
          color: brightness == Brightness.dark
              ? const Color(0xFF0F172A)
              : const Color(0xFFFFFFFF),
          fontWeight: FontWeight.w500,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  static final lightThemeMode = _buildTheme(
    brightness: Brightness.light,
    scaffoldBackgroundColor: ColorPalette.lightBackground,
    secondaryBackgroundColor: ColorPalette.lightSecondaryBackground,
    surfaceColor: ColorPalette.lightSurface,
    borderColor: ColorPalette.lightBorder,
    primaryTextColor: ColorPalette.lightPrimaryText,
    secondaryTextColor: ColorPalette.lightSecondaryText,
    disabledTextColor: ColorPalette.lightDisabledText,
    accentColor: ColorPalette.lightAccent,
    accentSoftColor: ColorPalette.lightAccentSoft,
    chipBackgroundColor: ColorPalette.lightBorder,
    chipTextColor: ColorPalette.lightPrimaryText,
    elevatedSurfaceColor: ColorPalette.lightElevatedSurface,
  );

  static final darkThemeMode = _buildTheme(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: ColorPalette.darkBackground,
    secondaryBackgroundColor: ColorPalette.darkSecondaryBackground,
    surfaceColor: ColorPalette.darkSurface,
    borderColor: ColorPalette.darkBorder,
    primaryTextColor: ColorPalette.darkPrimaryText,
    secondaryTextColor: ColorPalette.darkSecondaryText,
    disabledTextColor: ColorPalette.darkDisabledText,
    accentColor: ColorPalette.darkAccent,
    accentSoftColor: ColorPalette.darkAccentSoft,
    chipBackgroundColor: ColorPalette.chipDarkBackground,
    chipTextColor: ColorPalette.chipDarkText,
    elevatedSurfaceColor: ColorPalette.darkElevatedSurface,
  );
}
