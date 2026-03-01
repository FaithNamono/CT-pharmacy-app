import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'onboarding_screen.dart';
import 'auth/login_screen.dart';
import '../utils/constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    await Future.delayed(AppDurations.splashDuration);
    
    final prefs = await SharedPreferences.getInstance();
    final bool isFirstLaunch = prefs.getBool(StorageKeys.firstLaunch) ?? true;
    final String? token = prefs.getString(StorageKeys.token);
    
    if (isFirstLaunch) {
      // First time user - show onboarding
      await prefs.setBool(StorageKeys.firstLaunch, false);
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const OnboardingScreen()),
        );
      }
    } else if (token != null) {
      // User already logged in - go to home
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } else {
      // Not logged in - go to login
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // YOUR LOGO - Shows your actual logo.jpg
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(70),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(70),
                child: Image.asset(
                  'assets/images/logo.jpg',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback if logo.jpg not found - shows CT Pharmacy icon
                    return Container(
                      decoration: BoxDecoration(
                        color: AppColors.primaryGreen,
                        borderRadius: BorderRadius.circular(70),
                      ),
                      child: const Icon(
                        Icons.medical_services,
                        color: AppColors.white,
                        size: 70,
                      ),
                    );
                  },
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // CT Pharmacy Text - Fixed to show both parts
            RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: 'CT ',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                  TextSpan(
                    text: 'Pharmacy',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkText,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Full Name
            const Text(
              AppStrings.fullName,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.primaryGreen,
                fontWeight: FontWeight.w500,
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Tagline
            const Text(
              AppStrings.tagline,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.darkGrey,
              ),
            ),
            
            const SizedBox(height: 50),
            
            // Loading Indicator
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryGreen),
            ),
            
            const SizedBox(height: 20),
            
            const Text(
              'Loading...',
              style: TextStyle(
                color: AppColors.darkGrey,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}