import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CT Pharmacy',
      theme: ThemeData(
        primaryColor: const Color(0xFF27AE60), // Main green color for the app
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color(0xFF27AE60),
          secondary: const Color(0xFF2ECC71), // Lighter green for accents
        ),
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF27AE60), // Green app bar
          elevation: 0, // Remove shadow
          centerTitle: false,
        ),
      ),
      home: const SplashScreen(), // App starts with splash screen
      debugShowCheckedModeBanner: false, // Remove debug banner
    );
  }
}