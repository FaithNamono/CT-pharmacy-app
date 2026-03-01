import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors - Matching your logo #76BE53
  static const Color primaryGreen = Color(0xFF76BE53);
  static const Color darkGreen = Color(0xFF5C9E3F);
  static const Color lightGreen = Color(0xFFA8D88C);
  
  // Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color lightGrey = Color(0xFFF8F9FA);
  static const Color mediumGrey = Color(0xFFE0E0E0);
  static const Color darkGrey = Color(0xFF828282);
  static const Color darkText = Color(0xFF333333);
  
  // Status Colors
  static const Color warningRed = Color(0xFFEB5757);
  static const Color infoBlue = Color(0xFF2D9CDB);
  static const Color warningOrange = Color(0xFFF2994A);
  static const Color successGreen = Color(0xFF27AE60);
  
  // Chart Colors
  static const List<Color> chartColors = [
    Color(0xFF76BE53),
    Color(0xFF5C9E3F),
    Color(0xFFA8D88C),
    Color(0xFF2D9CDB),
    Color(0xFFF2994A),
  ];
}

class ApiConstants {
  // FOR WEB/CHROME - use 127.0.0.1
  static const String baseUrl = 'http://127.0.0.1:8000/api';
  
  // For iOS Simulator
  // static const String baseUrl = 'http://127.0.0.1:8000/api';
  
  // For Physical Device - use your PC's ACTUAL IP address
  // Example: static const String baseUrl = 'http://192.168.1.100:8000/api';
  
  // Test endpoint
  static String get test => '$baseUrl/test';
  
  // Auth Endpoints (v1 prefix)
  static String get login => '$baseUrl/v1/login';
  static String get register => '$baseUrl/v1/register';
  static String get logout => '$baseUrl/v1/logout';
  static String get profile => '$baseUrl/v1/profile';
  
  // Product Endpoints (v1 prefix)
  static String get products => '$baseUrl/v1/products';
  static String get productStats => '$baseUrl/v1/products/stats';
  
  // Sale Endpoints (v1 prefix)
  static String get sales => '$baseUrl/v1/sales';
  static String get salesSummary => '$baseUrl/v1/sales/summary';
  
  // Prescription Endpoints (v1 prefix)
  static String get prescriptions => '$baseUrl/v1/prescriptions';
  static String get prescriptionSummary => '$baseUrl/v1/prescriptions/summary/overview';
  
  // Dashboard Endpoints (v1 prefix)
  static String get dashboard => '$baseUrl/v1/dashboard';
  static String get salesChart => '$baseUrl/v1/dashboard/charts/sales';
}

class StorageKeys {
  static const String token = 'auth_token';
  static const String user = 'user_data';
  static const String rememberMe = 'remember_me';
  static const String firstLaunch = 'first_launch';
}

class AppStrings {
  static const String appName = 'CT Pharmacy';
  static const String fullName = 'Credibal Therauptics';
  static const String tagline = 'Manage your pharmacy efficiently';
  
  // Error Messages
  static const String networkError = 'Network error. Please check your connection.';
  static const String serverError = 'Server error. Please try again later.';
  static const String unauthorizedError = 'Session expired. Please login again.';
  static const String unknownError = 'An unknown error occurred.';
  
  // Validation Messages
  static const String requiredField = 'This field is required';
  static const String invalidEmail = 'Please enter a valid email';
  static const String invalidPhone = 'Please enter a valid phone number';
  static const String passwordTooShort = 'Password must be at least 6 characters';
  static const String passwordsDoNotMatch = 'Passwords do not match';
  
  // Success Messages
  static const String loginSuccess = 'Login successful!';
  static const String logoutSuccess = 'Logged out successfully';
  static const String registerSuccess = 'Registration successful!';
  static const String productAdded = 'Product added successfully';
  static const String productUpdated = 'Product updated successfully';
  static const String productDeleted = 'Product deleted successfully';
  static const String saleCompleted = 'Sale completed successfully';
  static const String prescriptionUploaded = 'Prescription uploaded successfully';
  
  // Test Credentials
  static const String testEmail = 'admin@ctpharmacy.com';
  static const String testPassword = 'password123';
}

class AppDurations {
  static const Duration splashDuration = Duration(seconds: 3);
  static const Duration snackBarDuration = Duration(seconds: 3);
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration animationDuration = Duration(milliseconds: 300);
}

class AppSizes {
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingExtraLarge = 32.0;
  
  static const double borderRadiusSmall = 8.0;
  static const double borderRadiusMedium = 12.0;
  static const double borderRadiusLarge = 16.0;
  
  static const double buttonHeight = 56.0;
  static const double iconSizeSmall = 20.0;
  static const double iconSizeMedium = 24.0;
  static const double iconSizeLarge = 32.0;
}