import 'package:material_ui/material_ui.dart';

/// Token visual yang dipakai bersama oleh web dan aplikasi mobile portofolio.
abstract final class PortfolioColors {
  static const ink = Color(0xFF2D211C);
  static const paper = Color(0xFFF7F4F0);
  static const surface = Colors.white;
  static const walnut = Color(0xFF51372A);
  static const copper = Color(0xFFB6643D);
  static const cloud = Color(0xFF526F7A);
  static const cloudSoft = Color(0xFFEEF4F5);
  static const navy = Color(0xFF23354D);
  static const line = Color(0xFFD8CEC6);
  static const muted = Color(0xFF6D625C);
}

abstract final class PortfolioTheme {
  static const headingFont = 'SpaceGrotesk';
  static const radius = BorderRadius.all(Radius.circular(6));

  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      fontFamily: headingFont,
      colorScheme: ColorScheme.fromSeed(
        seedColor: PortfolioColors.navy,
        primary: PortfolioColors.walnut,
        onPrimary: PortfolioColors.surface,
        secondary: PortfolioColors.copper,
        onSecondary: PortfolioColors.ink,
        surface: PortfolioColors.surface,
        onSurface: PortfolioColors.ink,
      ),
      scaffoldBackgroundColor: PortfolioColors.paper,
      dividerColor: PortfolioColors.line,
    );

    return base.copyWith(
      textTheme: base.textTheme
          .apply(
            bodyColor: PortfolioColors.ink,
            displayColor: PortfolioColors.walnut,
          )
          .copyWith(
            headlineLarge: const TextStyle(
              fontFamily: headingFont,
              fontWeight: FontWeight.w700,
              fontSize: 48,
              height: 1.08,
              color: PortfolioColors.walnut,
            ),
            titleLarge: const TextStyle(
              fontFamily: headingFont,
              fontWeight: FontWeight.w700,
              fontSize: 26,
              color: PortfolioColors.walnut,
            ),
            bodyLarge: const TextStyle(
              fontFamily: headingFont,
              fontSize: 17,
              height: 1.6,
            ),
            bodyMedium: const TextStyle(
              fontFamily: headingFont,
              fontSize: 14,
              height: 1.5,
            ),
          ),
      appBarTheme: const AppBarTheme(
        backgroundColor: PortfolioColors.surface,
        foregroundColor: PortfolioColors.walnut,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        shape: Border(bottom: BorderSide(color: PortfolioColors.line)),
        titleTextStyle: TextStyle(
          fontFamily: headingFont,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: PortfolioColors.walnut,
        ),
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: PortfolioColors.navy,
        contentTextStyle: TextStyle(
          fontFamily: headingFont,
          color: Colors.white,
          fontSize: 14,
        ),
      ),
    );
  }
}
