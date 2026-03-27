import 'package:flutter/material.dart';

class ButtonTextStyle {
  const ButtonTextStyle({
    this.fontSize = 16,
    this.fontWeight = FontWeight.w600,
    this.letterSpacing = 0,
  });

  final double fontSize;
  final FontWeight fontWeight;
  final double letterSpacing;

  static const ButtonTextStyle defaultStyle = ButtonTextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
  );

  static const ButtonTextStyle small = ButtonTextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
  );

  TextStyle toTextStyle({required Color color}) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
      color: color,
    );
  }
}
