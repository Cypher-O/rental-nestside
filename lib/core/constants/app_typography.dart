import 'package:flutter/material.dart';

class AppTypography {
  AppTypography._();

  static const String defaultFontFamily = 'Poppins';

  // Font sizes
  static const double fontSize10 = 10;
  static const double fontSize12 = 12;
  static const double fontSize13 = 13;
  static const double fontSize14 = 14;
  static const double fontSize15 = 15;
  static const double fontSize16 = 16;
  static const double fontSize18 = 18;
  static const double fontSize20 = 20;
  static const double fontSize22 = 22;
  static const double fontSize24 = 24;
  static const double fontSize28 = 28;
  static const double fontSize32 = 32;

  // Font weights
  static const FontWeight weightLight = FontWeight.w300;
  static const FontWeight weightRegular = FontWeight.w400;
  static const FontWeight weightMedium = FontWeight.w500;
  static const FontWeight weightSemiBold = FontWeight.w600;
  static const FontWeight weightBold = FontWeight.w700;
  static const FontWeight weightExtraBold = FontWeight.w800;

  // Predefined styles
  static const TextStyle h1 = TextStyle(
    fontSize: fontSize32,
    fontWeight: weightBold,
    fontFamily: defaultFontFamily,
  );
  static const TextStyle h2 = TextStyle(
    fontSize: fontSize24,
    fontWeight: weightBold,
    fontFamily: defaultFontFamily,
  );
  static const TextStyle h3 = TextStyle(
    fontSize: fontSize20,
    fontWeight: weightSemiBold,
    fontFamily: defaultFontFamily,
  );
  static const TextStyle h4 = TextStyle(
    fontSize: fontSize18,
    fontWeight: weightSemiBold,
    fontFamily: defaultFontFamily,
  );
  static const TextStyle bodyLarge = TextStyle(
    fontSize: fontSize16,
    fontWeight: weightRegular,
    fontFamily: defaultFontFamily,
  );
  static const TextStyle bodyMedium = TextStyle(
    fontSize: fontSize14,
    fontWeight: weightRegular,
    fontFamily: defaultFontFamily,
  );
  static const TextStyle bodySmall = TextStyle(
    fontSize: fontSize13,
    fontWeight: weightRegular,
    fontFamily: defaultFontFamily,
  );
  static const TextStyle labelLarge = TextStyle(
    fontSize: fontSize14,
    fontWeight: weightMedium,
    fontFamily: defaultFontFamily,
  );
  static const TextStyle labelMedium = TextStyle(
    fontSize: fontSize12,
    fontWeight: weightMedium,
    fontFamily: defaultFontFamily,
  );
  static const TextStyle caption = TextStyle(
    fontSize: fontSize12,
    fontWeight: weightRegular,
    fontFamily: defaultFontFamily,
  );
  static const TextStyle button = TextStyle(
    fontSize: fontSize16,
    fontWeight: weightSemiBold,
    fontFamily: defaultFontFamily,
  );

  static double lineHeightFromPixels({
    required double fontSize,
    required double lineHeight,
  }) =>
      lineHeight / fontSize;
}
