import 'constants.dart';

class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.requiredField;
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return AppStrings.invalidEmail;
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.requiredField;
    }
    if (value.length < 6) {
      return AppStrings.passwordTooShort;
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return AppStrings.requiredField;
    }
    if (value != password) {
      return AppStrings.passwordsDoNotMatch;
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.requiredField;
    }
    final phoneRegex = RegExp(r'^[0-9]{10,15}$');
    if (!phoneRegex.hasMatch(value)) {
      return AppStrings.invalidPhone;
    }
    return null;
  }

  static String? validateRequired(String? value, [String fieldName = 'This field']) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? validateNumber(String? value, {bool isRequired = true, double min = 0}) {
    if (value == null || value.isEmpty) {
      return isRequired ? AppStrings.requiredField : null;
    }
    final number = double.tryParse(value);
    if (number == null) {
      return 'Please enter a valid number';
    }
    if (number < min) {
      return 'Number must be greater than $min';
    }
    return null;
  }

  static String? validatePrice(String? value, {bool isRequired = true}) {
    return validateNumber(value, isRequired: isRequired, min: 0);
  }

  static String? validateQuantity(String? value, {bool isRequired = true}) {
    if (value == null || value.isEmpty) {
      return isRequired ? AppStrings.requiredField : null;
    }
    final quantity = int.tryParse(value);
    if (quantity == null) {
      return 'Please enter a valid quantity';
    }
    if (quantity < 0) {
      return 'Quantity cannot be negative';
    }
    return null;
  }
}