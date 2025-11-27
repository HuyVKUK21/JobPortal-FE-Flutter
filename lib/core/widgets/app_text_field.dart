import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final String? helperText;
  final String? suffixText;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final double borderRadius;
  final Color fillColor;
  final Color borderColor;
  final Color focusedBorderColor;

  const AppTextField({
    super.key,
    required this.controller,
    this.hintText,
    this.helperText,
    this.suffixText,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.onChanged,
    this.borderRadius = 12,
    this.fillColor = Colors.white,
    this.borderColor = AppColors.borderLight,
    this.focusedBorderColor = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        helperText: helperText,
        suffixText: suffixText,
        filled: true,
        fillColor: fillColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: borderColor.withOpacity(0.5)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: borderColor.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: focusedBorderColor, width: 2),
        ),
      ),
    );
  }
}
