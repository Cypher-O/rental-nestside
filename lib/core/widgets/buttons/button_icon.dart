import 'package:flutter/material.dart';
import '../../constants/app_dimensions.dart';

class ButtonIcon extends StatelessWidget {
  const ButtonIcon.material(
    this.iconData, {
    super.key,
    this.color,
    this.size = AppDimensions.iconSmall20,
  })  : child = null,
        _type = _ButtonIconType.material;

  const ButtonIcon.custom(
    this.child, {
    super.key,
    this.color,
    this.size = AppDimensions.iconSmall20,
  })  : iconData = null,
        _type = _ButtonIconType.custom;

  final IconData? iconData;
  final Widget? child;
  final Color? color;
  final double size;
  final _ButtonIconType _type;

  @override
  Widget build(BuildContext context) {
    switch (_type) {
      case _ButtonIconType.material:
        return Icon(iconData, color: color, size: size);
      case _ButtonIconType.custom:
        return SizedBox(width: size, height: size, child: child);
    }
  }
}

enum _ButtonIconType { material, custom }
