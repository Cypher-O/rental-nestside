import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../constants/app_dimensions.dart';
import 'button_config.dart';
import 'button_icon.dart';

enum ButtonStyleType { primary, secondary, outlined, destructive, text }

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.config,
    this.gradient,
    this.icon,
    this.trailingIcon,
    this.isLoading = false,
    this.isDisabled = false,
    this.width,
    this.height = AppDimensions.buttonHeightLarge,
    this.borderRadius = AppDimensions.radiusMedium,
  });

  final String text;
  final VoidCallback? onPressed;
  final ButtonConfig config;
  final Gradient? gradient;
  final ButtonIcon? icon;
  final ButtonIcon? trailingIcon;
  final bool isLoading;
  final bool isDisabled;
  final double? width;
  final double height;
  final double borderRadius;

  factory CustomButton.primary({
    Key? key,
    required String text,
    required VoidCallback? onPressed,
    ButtonIcon? icon,
    ButtonIcon? trailingIcon,
    bool isLoading = false,
    bool isDisabled = false,
    double? width,
    double height = AppDimensions.buttonHeightLarge,
  }) =>
      CustomButton(
        key: key,
        text: text,
        onPressed: onPressed,
        config: ButtonConfig.primary,
        icon: icon,
        trailingIcon: trailingIcon,
        isLoading: isLoading,
        isDisabled: isDisabled,
        width: width,
        height: height,
      );

  factory CustomButton.secondary({
    Key? key,
    required String text,
    required VoidCallback? onPressed,
    ButtonIcon? icon,
    ButtonIcon? trailingIcon,
    bool isLoading = false,
    bool isDisabled = false,
    double? width,
    double height = AppDimensions.buttonHeightLarge,
  }) =>
      CustomButton(
        key: key,
        text: text,
        onPressed: onPressed,
        config: ButtonConfig.secondary,
        gradient: const LinearGradient(
          colors: [Color(0xFF1E3A5F), Color(0xFF2D5FA0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        icon: icon,
        trailingIcon: trailingIcon,
        isLoading: isLoading,
        isDisabled: isDisabled,
        width: width,
        height: height,
      );

  factory CustomButton.outlined({
    Key? key,
    required String text,
    required VoidCallback? onPressed,
    ButtonIcon? icon,
    ButtonIcon? trailingIcon,
    bool isLoading = false,
    bool isDisabled = false,
    double? width,
    double height = AppDimensions.buttonHeightLarge,
  }) =>
      CustomButton(
        key: key,
        text: text,
        onPressed: onPressed,
        config: ButtonConfig.outlined,
        icon: icon,
        trailingIcon: trailingIcon,
        isLoading: isLoading,
        isDisabled: isDisabled,
        width: width,
        height: height,
      );

  factory CustomButton.destructive({
    Key? key,
    required String text,
    required VoidCallback? onPressed,
    ButtonIcon? icon,
    ButtonIcon? trailingIcon,
    bool isLoading = false,
    bool isDisabled = false,
    double? width,
    double height = AppDimensions.buttonHeightLarge,
  }) =>
      CustomButton(
        key: key,
        text: text,
        onPressed: onPressed,
        config: ButtonConfig.destructive,
        icon: icon,
        trailingIcon: trailingIcon,
        isLoading: isLoading,
        isDisabled: isDisabled,
        width: width,
        height: height,
      );

  factory CustomButton.text({
    Key? key,
    required String text,
    required VoidCallback? onPressed,
    ButtonIcon? icon,
    bool isLoading = false,
    bool isDisabled = false,
    double? width,
    double height = AppDimensions.buttonHeightLarge,
  }) =>
      CustomButton(
        key: key,
        text: text,
        onPressed: onPressed,
        config: ButtonConfig.text,
        icon: icon,
        isLoading: isLoading,
        isDisabled: isDisabled,
        width: width,
        height: height,
      );

  @override
  Widget build(BuildContext context) {
    final isActive = !isDisabled && !isLoading;
    final effectiveConfig = isActive ? config : ButtonConfig.disabled;
    final effectiveOnPressed = isActive ? onPressed : null;
    final effectiveGradient = isActive ? gradient : null;

    Widget child;
    if (isLoading) {
      child = SizedBox(
        width: 22,
        height: 22,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          color: effectiveConfig.textColor,
        ),
      );
    } else {
      child = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            ButtonIcon.material(
              icon!.iconData ?? Icons.circle,
              color: effectiveConfig.textColor,
              size: AppDimensions.iconSmall20,
            ),
            const SizedBox(width: AppDimensions.spacing8),
          ],
          Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: effectiveConfig.textColor,
              letterSpacing: 0.1,
            ),
          ),
          if (trailingIcon != null) ...[
            const SizedBox(width: AppDimensions.spacing8),
            ButtonIcon.material(
              trailingIcon!.iconData ?? Icons.circle,
              color: effectiveConfig.textColor,
              size: AppDimensions.iconSmall20,
            ),
          ],
        ],
      );
    }

    final hasBorder = effectiveConfig.borderColor != null;
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      side: hasBorder
          ? BorderSide(
              color: effectiveConfig.borderColor!,
              width: effectiveConfig.borderWidth,
            )
          : BorderSide.none,
    );

    if (effectiveGradient != null) {
      return GestureDetector(
        onTap: effectiveOnPressed,
        child: Container(
          width: width ?? double.infinity,
          height: height,
          decoration: BoxDecoration(
            gradient: effectiveGradient,
            borderRadius: BorderRadius.circular(borderRadius),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: AppColors.primary.withAlpha(80),
                      blurRadius: 14,
                      offset: const Offset(0, 5),
                    ),
                  ]
                : [],
          ),
          child: Center(child: child),
        ),
      );
    }

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: Material(
        color: effectiveConfig.backgroundColor,
        elevation: effectiveConfig.elevation,
        shape: shape,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: effectiveOnPressed,
          child: Center(child: child),
        ),
      ),
    );
  }
}
