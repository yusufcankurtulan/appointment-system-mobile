import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

class GlassContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final Color? fillColor;

  const GlassContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius = 24,
    this.fillColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: fillColor ?? AppColors.cardFill,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: AppColors.cardStroke),
      ),
      child: child,
    );
  }
}
