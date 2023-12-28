import 'package:flutter/material.dart';
import 'package:polaris_assignment/core/theme/color_constants.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final double fontSize;
  final double? width;
  final double height;
  final GestureTapCallback? onPressed;
  final bool isLoading;
  final double borderRadius;
  final EdgeInsets? margin;
  final Widget? child;

  final double elevation;

  const PrimaryButton(
    this.text, {
    super.key,
    this.fontSize = 18,
    this.width,
    this.height = 48,
    this.onPressed,
    this.borderRadius = 8,
    this.margin = EdgeInsets.zero,
    this.isLoading = false,
    this.child,
    this.elevation = 4,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      margin: margin,
      height: height,
      decoration: BoxDecoration(
        color: ColorConstants.primary,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Material(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(borderRadius),
          ),
        ),
        color: onPressed == null ? const Color(0xFFCDCDCD) : Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          child: Align(
            child: !isLoading
                ? child ??
                    FittedBox(
                      child: Text(
                        text,
                        style: TextStyle(
                          fontSize: fontSize,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                      ),
                    )
                : const SizedBox.square(
                    dimension: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
