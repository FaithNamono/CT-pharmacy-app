import 'package:flutter/material.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // ========== FORM AND CONTROLLERS ==========
  // Global key to manage form state and validation
  final _formKey = GlobalKey<FormState>();
  
  // Text editing controllers to capture user input from text fields
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  // ========== STATE VARIABLES ==========
  bool _isLoading = false; // Tracks if registration is in progress
  bool _obscurePassword = true; // Controls password visibility
  bool _obscureConfirmPassword = true; // Controls confirm password visibility

  // ========== REGISTRATION METHOD ==========
  void _register() async {
    // DEBUG: Print registration attempt details for testing
    print('=== REGISTRATION BUTTON PRESSED ===');
    print('Full Name: ${_fullNameController.text}');
    print('Email: ${_emailController.text}');
    print('Phone: ${_phoneController.text}');
    
    // Validate all form fields using the form key
    if (!_formKey.currentState!.validate()) {
      print('❌ REGISTRATION FORM VALIDATION FAILED');
      return; // Stop execution if validation fails
    }
    print('✅ REGISTRATION FORM VALIDATION PASSED');

    // Check if password and confirm password match
    if (_passwordController.text != _confirmPasswordController.text) {
      print('❌ PASSWORDS DO NOT MATCH');
      // Show error message to user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passwords do not match'),
          backgroundColor: Colors.red,
        ),
      );
      return; // Stop execution if passwords don't match
    }
    print('✅ PASSWORDS MATCH');

    // Set loading state to true to show progress indicator
    setState(() {
      _isLoading = true;
      print('🔄 REGISTRATION IN PROGRESS - Showing loading spinner');
    });

    // Simulate API call delay (replace with actual API call in real app)
    await Future.delayed(const Duration(seconds: 2));

    // Mock registration success scenario
    print('✅ REGISTRATION SUCCESSFUL - Navigating to Login');
    
    // Check if widget is still mounted before updating state
    if (mounted) {
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registration successful! Please login.'),
          backgroundColor: Colors.green,
        ),
      );
      
      // Navigate to login screen and replace current screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }

    // Reset loading state if widget is still mounted
    if (mounted) {
      setState(() {
        _isLoading = false;
        print('🔄 REGISTRATION COMPLETED - Loading spinner hidden');
      });
    }
  }

  // ========== VALIDATION METHODS ==========
  
  // Generic required field validator
  String? _validateRequired(String? value, String fieldName) {
    // Check if field is empty or null
    if (value == null || value.isEmpty) {
      return 'Please enter $fieldName';
    }
    return null; // Return null if validation passes
  }

  // Email validation with regex pattern
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    // Regex pattern for basic email validation
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  // Phone number validation (10-15 digits)
  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }
    // Regex for phone number (digits only, 10-15 characters)
    if (!RegExp(r'^[0-9]{10,15}$').hasMatch(value)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  // Password validation (minimum 6 characters)
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    // Check minimum password length
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  // ========== CLEANUP METHOD ==========
  @override
  void dispose() {
    // Dispose all controllers to prevent memory leaks
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // ========== UI BUILD METHOD ==========
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
      appBar: AppBar(
        // Back button to navigate to previous screen
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            print('🔙 BACK BUTTON PRESSED - Returning to previous screen');
            Navigator.pop(context); // Pop current screen from navigation stack
          },
        ),
        backgroundColor: Colors.white, // Transparent app bar
        elevation: 0, // Remove shadow
      ),
      body: SafeArea(
        // Ensure content is within safe area (notch/status bar)
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24), // Add padding around content
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight, // Ensure minimum height
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Take only required height
                  children: [
                    // ========== HEADER SECTION ==========
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // App Logo/Icon Container
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: const Color(0xFF27AE60), // Green background
                              borderRadius: BorderRadius.circular(16), // Rounded corners
                            ),
                            child: const Icon(
                              Icons.person_add_alt_1, // Registration icon
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                          const SizedBox(height: 16), // Spacer between icon and title
                          
                          // Screen Title
                          const Text(
                            'Create Account',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2C3E50), // Dark blue-gray color
                            ),
                          ),
                          const SizedBox(height: 8), // Spacer between title and subtitle
                          
                          // Subtitle
                          const Text(
                            'Join CT Pharmacy today',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey, // Light gray color
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ========== REGISTRATION FORM ==========
                    Form(
                      key: _formKey, // Link form to global key for validation
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // ========== FULL NAME FIELD ==========
                          TextFormField(
                            controller: _fullNameController, // Link to controller
                            decoration: InputDecoration(
                              labelText: 'Full Name',
                              prefixIcon: const Icon(Icons.person_outline, color: Color(0xFF27AE60)), // Person icon
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12), // Rounded corners
                              ),
                              filled: true, // Enable background fill
                              fillColor: Colors.grey[50], // Light gray background
                            ),
                            validator: (value) => _validateRequired(value, 'full name'), // Validation
                          ),
                          const SizedBox(height: 16), // Spacer between fields
                          
                          // ========== EMAIL FIELD ==========
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: 'Email Address',
                              prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF27AE60)), // Email icon
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.grey[50],
                            ),
                            keyboardType: TextInputType.emailAddress, // Email keyboard
                            validator: _validateEmail, // Email validation
                          ),
                          const SizedBox(height: 16),
                          
                          // ========== PHONE FIELD ==========
                          TextFormField(
                            controller: _phoneController,
                            decoration: InputDecoration(
                              labelText: 'Phone Number',
                              prefixIcon: const Icon(Icons.phone_outlined, color: Color(0xFF27AE60)), // Phone icon
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.grey[50],
                            ),
                            keyboardType: TextInputType.phone, // Phone number keyboard
                            validator: _validatePhone, // Phone validation
                          ),
                          const SizedBox(height: 16),
                          
                          // ========== PASSWORD FIELD ==========
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword, // Hide/show password
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF27AE60)), // Lock icon
                              suffixIcon: IconButton(
                                icon: Icon(
                                  // Toggle between visibility icons
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: const Color(0xFF27AE60),
                                ),
                                onPressed: () {
                                  // Toggle password visibility
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.grey[50],
                            ),
                            validator: _validatePassword, // Password validation
                          ),
                          const SizedBox(height: 16),
                          
                          // ========== CONFIRM PASSWORD FIELD ==========
                          TextFormField(
                            controller: _confirmPasswordController,
                            obscureText: _obscureConfirmPassword,
                            decoration: InputDecoration(
                              labelText: 'Confirm Password',
                              prefixIcon: const Icon(Icons.lock_reset, color: Color(0xFF27AE60)), // Reset lock icon
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureConfirmPassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: const Color(0xFF27AE60),
                                ),
                                onPressed: () {
                                  // Toggle confirm password visibility
                                  setState(() {
                                    _obscureConfirmPassword = !_obscureConfirmPassword;
                                  });
                                },
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.grey[50],
                            ),
                            validator: _validatePassword, // Confirm password validation
                          ),
                          const SizedBox(height: 32), // Extra space before button
                          
                          // ========== CREATE ACCOUNT BUTTON ==========
                          SizedBox(
                            width: double.infinity, // Full width button
                            height: 56, // Fixed height
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _register, // Disable when loading
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF27AE60), // Green color
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16), // Rounded corners
                                ),
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white), // White spinner
                                      ),
                                    )
                                  : const Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.person_add, color: Colors.white), // Add person icon
                                        SizedBox(width: 8), // Space between icon and text
                                        Text(
                                          'Create Account',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                          const SizedBox(height: 24), // Space after button
                          
                          // ========== SIGN IN LINK ==========
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Already have an account?",
                                style: TextStyle(color: Colors.grey),
                              ),
                              const SizedBox(width: 8), // Space between texts
                              GestureDetector(
                                onTap: () {
                                  print('🔗 SIGN IN CLICKED - Navigating to Login');
                                  // Navigate to login screen
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                                  );
                                },
                                child: const Text(
                                  'Sign In',
                                  style: TextStyle(
                                    color: Color(0xFF27AE60), // Green color
                                    fontWeight: FontWeight.w600, // Bold text
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20), // Extra bottom padding for scroll
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}