import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Brand Colors
  static const Color primary = Color(0xFF1E3A5F); // Deep Navy Blue
  static const Color primaryLight = Color(0xFF2D5F9E);
  static const Color primaryDark = Color(0xFF0F1F35);
  static const Color accent = Color(0xFFD4880F); // Deep Premium Gold
  static const Color accentLight = Color(0xFFE8A028);
  static const Color accentDark = Color(0xFFB5700A);

  // Premium Gradient Colors
  static const Color gradientStart = Color(0xFF0F1F35);
  static const Color gradientMid = Color(0xFF1E3A5F);
  static const Color gradientEnd = Color(0xFF2D5FA0);
  static const Color purpleAccent = Color(0xFF6C63FF);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [gradientStart, gradientMid, gradientEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [accent, accentLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardOverlay = LinearGradient(
    colors: [Colors.transparent, Color(0xCC000000)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient heroOverlay = LinearGradient(
    colors: [Color(0x00000000), Color(0xE6000000)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Backgrounds
  static const Color background = Color(0xFFF5F6FA);
  static const Color backgroundWarm = Color(0xFFFAF9F7);
  static const Color backgroundDark = Color(0xFF0F1F35);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceElevated = Color(0xFFFDFDFD);
  static const Color cardBackground = Color(0xFFFFFFFF);

  // Text
  static const Color textPrimary = Color(0xFF0D1B2A);
  static const Color textSecondary = Color(0xFF6B7A8D);
  static const Color textLight = Color(0xFFAAB4BF);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textOnDark = Color(0xFFE8EFF7);

  // Status
  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFFD1FAE5);
  static const Color successDark = Color(0xFF059669);
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFFEE2E2);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFEF3C7);
  static const Color info = Color(0xFF3B82F6);
  static const Color infoLight = Color(0xFFDBEAFE);

  // UI
  static const Color border = Color(0xFFE8ECF4);
  static const Color borderFocused = Color(0xFF1E3A5F);
  static const Color divider = Color(0xFFF1F5F9);
  static const Color shadow = Color(0x0F000000);
  static const Color shadowMedium = Color(0x1A000000);
  static const Color shadowStrong = Color(0x33000000);
  static const Color shimmerBase = Color(0xFFE8ECF4);
  static const Color shimmerHighlight = Color(0xFFF8FAFC);

  // Input
  static const Color inputBackground = Color(0xFFF0F3FA);
  static const Color inputBackgroundFocused = Color(0xFFEBF0FF);

  // Booking Status
  static const Color pendingPayment = Color(0xFFF59E0B);
  static const Color confirmed = Color(0xFF10B981);
  static const Color cancelled = Color(0xFFEF4444);
  static const Color completed = Color(0xFF6B7A8D);

  // Transparent & Solids
  static const Color transparent = Colors.transparent;
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color overlay = Color(0x80000000);
  static const Color overlayLight = Color(0x40000000);
}
