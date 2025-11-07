import 'package:flutter/material.dart';
import 'onboarding_screen.dart'; // Import the next screen

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToOnboarding(); // Start navigation when screen loads
  }

  // Function to navigate to onboarding after a delay
  _navigateToOnboarding() async {
    // Wait for 3 seconds to show the splash screen
    await Future.delayed(const Duration(seconds: 3), () {});
    
    // Navigate to onboarding screen and remove splash from navigation stack
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const OnboardingScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Clean white background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center everything vertically
          children: [
            // Pharmacy Logo - Uses your logo.jpg file
            Container(
              width: 140,
              height: 140,
              child: Image.asset(
                'assets/images/logo.jpg', // Your pharmacy logo
                fit: BoxFit.contain, // Maintain aspect ratio
                errorBuilder: (context, error, stackTrace) {
                  // If image fails to load, show fallback icon
                  return Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF27AE60), // Green background
                      borderRadius: BorderRadius.circular(24), // Rounded corners
                    ),
                    child: const Icon(
                      Icons.medical_services, // Pharmacy icon
                      color: Colors.white,
                      size: 70,
                    ),
                  );
                },
              ),
            ),
            
            const SizedBox(height: 24), // Spacing between logo and text
            
            // App Name
            const Text(
              'CT Pharmacy',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF27AE60), // Green text
              ),
            ),
            
            const SizedBox(height: 8), // Small spacing
            
            // Pharmacy Full Name
            const Text(
              'Credibal Therauptics',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey, // Grey text
                fontWeight: FontWeight.w500, // Medium weight
              ),
            ),
            
            const SizedBox(height: 4), // Very small spacing
            
            // App Description
            const Text(
              'Management System',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey, // Grey text
              ),
            ),
            
            const SizedBox(height: 60), // Large spacing before loading indicator
            
            // Loading Indicator - Shows app is loading
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF27AE60)), // Green loading
            ),
            
            const SizedBox(height: 20), // Spacing
            
            // Loading Text
            const Text(
              'Loading...',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}