import 'package:flutter/material.dart';
import 'package:kenic/core/utils/fonts/inter.dart';
import 'package:kenic/core/utils/theme/app_pallete.dart';

class RoundedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final Color? backgroundColor;
  final Color? textColor;
  final double height;
  final double width;
  final double fontsize;
  final bool border;
  final Color? borderColor;
  final double? borderWidth;
  final double? borderRadius;
  final bool isLoading; // 👈 New param

  const RoundedButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.height = 54,
    this.width = double.maxFinite,
    this.border = false,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.fontsize = 20,
    this.borderWidth,
    this.borderRadius,
    this.isLoading = false, // 👈 Default to false
  });

  @override
  Widget build(BuildContext context) {
    final Color effectiveBackgroundColor =
        backgroundColor ?? AppPallete.kenicRed;
    final Color effectiveTextColor =
        textColor ?? Theme.of(context).colorScheme.surface;
    final Color effectiveBorderColor =
        borderColor ?? Theme.of(context).colorScheme.surface;
    final double effectiveBorderWidth = borderWidth ?? 1.5;
    final double effectiveBorderRadius = borderRadius ?? 7.0;

    return ElevatedButton(
      onPressed: isLoading ? null : onPressed, // 👈 disable while loading
      style: ElevatedButton.styleFrom(
        foregroundColor: textColor,
        backgroundColor: effectiveBackgroundColor,
        padding: const EdgeInsets.all(0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(effectiveBorderRadius),
        ),
      ),
      child: Container(
        height: height,
        alignment: Alignment.center,
        width: width,
        decoration:
            border
                ? BoxDecoration(
                  borderRadius: BorderRadius.circular(effectiveBorderRadius),
                  border: Border.all(
                    color: effectiveBorderColor,
                    width: effectiveBorderWidth,
                  ),
                )
                : null,
        child:
            isLoading
                ? SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      effectiveTextColor,
                    ),
                  ),
                )
                : Inter(
                  text: label,
                  fontSize: fontsize,
                  textColor: effectiveTextColor,
                ),
      ),
    );
  }
}
