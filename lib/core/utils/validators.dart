import 'package:flutter_application_1/core/constants/app_strings.dart';

/// Form validation utilities
class Validators {
  Validators._();

  /// Email validation regex
  static final RegExp _emailRegex = RegExp(
    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
  );

  /// Validate email
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.emailRequired;
    }
    if (!_emailRegex.hasMatch(value.trim())) {
      return AppStrings.emailInvalid;
    }
    return null;
  }

  /// Validate password
  static String? validatePassword(String? value, {int minLength = 6}) {
    if (value == null || value.isEmpty) {
      return AppStrings.passwordRequired;
    }
    if (value.length < minLength) {
      return AppStrings.passwordTooShort;
    }
    return null;
  }

  /// Validate confirm password
  static String? validateConfirmPassword(
    String? value,
    String originalPassword,
  ) {
    if (value == null || value.isEmpty) {
      return AppStrings.confirmPasswordRequired;
    }
    if (value != originalPassword) {
      return AppStrings.passwordNotMatch;
    }
    return null;
  }

  /// Validate name
  static String? validateName(String? value, {int minLength = 2}) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.nameRequired;
    }
    if (value.trim().length < minLength) {
      return AppStrings.nameTooShort;
    }
    return null;
  }

  /// Validate phone number
  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập số điện thoại';
    }
    
    // Remove all non-digit characters
    final phoneDigits = value.replaceAll(RegExp(r'[^\d]'), '');
    
    // Check if it's a valid Vietnamese phone number
    if (phoneDigits.length < 10 || phoneDigits.length > 11) {
      return 'Số điện thoại phải có 10-11 chữ số';
    }
    
    // Check if it starts with valid Vietnamese prefixes
    if (!phoneDigits.startsWith('0') && !phoneDigits.startsWith('84')) {
      return 'Số điện thoại không hợp lệ';
    }
    
    return null;
  }

  /// Validate required field
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập $fieldName';
    }
    return null;
  }
}


