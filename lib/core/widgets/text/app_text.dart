import 'package:flutter/material.dart';
import '../../constants/app_typography.dart';

class AppText extends StatelessWidget {
  const AppText(
    this.text, {
    super.key,
    this.style,
    this.fontSize = 14,
    this.fontWeight = FontWeight.w400,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.height,
    this.letterSpacing,
    this.fontStyle,
    this.decoration,
    this.decorationColor,
    this.decorationStyle,
    this.decorationThickness,
    this.fontFamily,
  });

  final String text;
  final TextStyle? style;
  final double fontSize;
  final FontWeight fontWeight;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? height;
  final double? letterSpacing;
  final FontStyle? fontStyle;
  final TextDecoration? decoration;
  final Color? decorationColor;
  final TextDecorationStyle? decorationStyle;
  final double? decorationThickness;
  final String? fontFamily;

  factory AppText.heading(
    String text, {
    Key? key,
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) =>
      AppText(
        text,
        key: key,
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: color,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
      );

  factory AppText.subheading(
    String text, {
    Key? key,
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) =>
      AppText(
        text,
        key: key,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: color,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
      );

  factory AppText.body(
    String text, {
    Key? key,
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) =>
      AppText(
        text,
        key: key,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: color,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
      );

  factory AppText.caption(
    String text, {
    Key? key,
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) =>
      AppText(
        text,
        key: key,
        fontSize: 12,
        fontWeight: FontWeight.w300,
        color: color,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
      );

  factory AppText.button(
    String text, {
    Key? key,
    Color? color,
  }) =>
      AppText(
        text,
        key: key,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        color: color,
      );

  @override
  Widget build(BuildContext context) {
    final effectiveStyle = style ??
        TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          height: height,
          letterSpacing: letterSpacing,
          fontStyle: fontStyle,
          decoration: decoration,
          decorationColor: decorationColor,
          decorationStyle: decorationStyle,
          decorationThickness: decorationThickness,
          fontFamily: fontFamily ?? AppTypography.defaultFontFamily,
        );
    return Text(
      text,
      style: effectiveStyle,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
