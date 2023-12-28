import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:polaris_assignment/core/theme/color_constants.dart';

class CustomTextField extends StatelessWidget {
  final String? labelText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool isNumber;
  final int? maxLength;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final int maxLines;
  final bool isAutoFocus;
  final VoidCallback? onTap;
  final double? height;
  final double? width;
  final double? spacing;
  final List<TextInputFormatter>? inputFormatters;
  final TextStyle? textStyle;
  final EdgeInsets? contentPadding;
  final Function(String)? textWatcher;

  const CustomTextField(
      {super.key,
      this.labelText,
      this.controller,
      this.focusNode,
      this.isNumber = false,
      this.maxLength,
      this.keyboardType,
      this.maxLines = 1,
      this.textCapitalization = TextCapitalization.none,
      this.isAutoFocus = false,
      this.onTap,
      this.height = 45,
      this.width,
      this.spacing,
      this.inputFormatters,
      this.textStyle,
      this.contentPadding,
      this.textWatcher});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: TextField(
        key: UniqueKey(),
        controller: controller,
        focusNode: focusNode,
        autofocus: isAutoFocus,
        keyboardType: isNumber ? TextInputType.number : keyboardType,
        textCapitalization: textCapitalization,
        cursorColor: ColorConstants.primary,
        onTap: onTap,
        inputFormatters: [
          if (inputFormatters != null)
            ...?inputFormatters
          else if (isNumber)
            FilteringTextInputFormatter.digitsOnly,
        ],
        maxLength: maxLength,
        maxLines: maxLines,
        scrollPadding: const EdgeInsets.only(bottom: 180),
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: ColorConstants.primary),
          ),
          counterText: "",
          alignLabelWithHint: true,
          labelStyle: const TextStyle(fontWeight: FontWeight.w300),
          floatingLabelStyle: const TextStyle(
              fontWeight: FontWeight.w300, color: ColorConstants.primary),
          labelText: labelText,
          contentPadding: contentPadding ??
              EdgeInsets.symmetric(
                horizontal: 12,
                vertical: maxLines <= 1 ? 10 : 4,
              ),
        ),
        onChanged: (value) {
          if (textWatcher != null) {
            textWatcher!(value);
          }
        },
      ),
    );
  }
}
