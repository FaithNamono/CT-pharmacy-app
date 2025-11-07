import 'package:flutter/material.dart';
import 'authscreens/login_screen.dart'; // Import login screen from auth folder

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController(); // Controls page scrolling
  int _currentPage = 0; // Tracks which page is currently visible

  // Data for each onboarding page
  final List<OnboardingPage> _onboardingPages = [
    OnboardingPage(
      title: 'Smart Inventory Management',
      description: 'Track your pharmacy stock in real-time with automatic expiry alerts and low stock notifications.',
      icon: Icons.inventory, // Inventory icon
      color: Color(0xFF27AE60), // Green color
    ),
    OnboardingPage(
      title: 'Fast Sales & POS',
      description: 'Process sales quickly with barcode scanning, generate digital receipts, and track daily revenue.',
      icon: Icons.point_of_sale, // POS icon
      color: Color(0xFF27AE60), // Green color
    ),
    OnboardingPage(
      title: 'Digital Prescription Tracking',
      description: 'Securely store and manage customer prescriptions with easy search and retrieval features.',
      icon: Icons.medical_services, // Medical icon
      color: Color(0xFF27AE60), // Green color
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Skip Button - Top right corner
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // Skip all onboarding and go directly to login
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                },
                child: Text(
                  'Skip',
                  style: TextStyle(
                    color: Colors.grey[600], // Grey text
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            
            // Page View - Main content area
            Expanded(
              flex: 3, // Takes 3/4 of available space
              child: PageView.builder(
                controller: _pageController, // Controls page scrolling
                itemCount: _onboardingPages.length, // Number of pages
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page; // Update current page when user swipes
                  });
                },
                itemBuilder: (context, index) {
                  return OnboardingPageWidget(page: _onboardingPages[index]);
                },
              ),
            ),
            
            // Page Indicator Dots - Shows current page position
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _onboardingPages.length,
                (index) => Container(
                  margin: const EdgeInsets.all(4), // Space between dots
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == index 
                        ? const Color(0xFF27AE60) // Active dot - green
                        : Colors.grey[300], // Inactive dot - light grey
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 30), // Spacing between dots and button
            
            // Next/Get Started Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              child: SizedBox(
                width: double.infinity, // Full width button
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (_currentPage == _onboardingPages.length - 1) {
                      // Last page - navigate to login
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                      );
                    } else {
                      // Go to next page with smooth animation
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.ease,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF27AE60), // Green button
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // Rounded corners
                    ),
                  ),
                  child: Text(
                    _currentPage == _onboardingPages.length - 1 
                        ? 'Get Started' // Last page shows "Get Started"
                        : 'Next', // Other pages show "Next"
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Data model for each onboarding page
class OnboardingPage {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  OnboardingPage({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}

// Widget that builds individual onboarding page
class OnboardingPageWidget extends StatelessWidget {
  final OnboardingPage page;

  const OnboardingPageWidget({Key? key, required this.page}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon Container with circular background
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: page.color.withOpacity(0.1), // Light background color
              shape: BoxShape.circle,
            ),
            child: Icon(
              page.icon,
              size: 60,
              color: page.color, // Icon color matches theme
            ),
          ),
          
          const SizedBox(height: 40), // Spacing between icon and title
          
          // Page Title
          Text(
            page.title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: page.color, // Title color matches theme
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 20), // Spacing between title and description
          
          // Page Description
          Text(
            page.description,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey, // Grey description text
              height: 1.5, // Line height for better readability
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}