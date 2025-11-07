import 'package:flutter/material.dart';
import 'login_screen.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String email;
  
  const OTPVerificationScreen({
    Key? key,
    required this.email,
  }) : super(key: key);

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final List<TextEditingController> _otpControllers =
      List.generate(4, (index) => TextEditingController());
  final List<FocusNode> _otpFocusNodes = List.generate(4, (index) => FocusNode());
  bool _isLoading = false;
  bool _canResend = false;
  int _resendTimer = 30;

  final String _correctOTP = "1234";

  void _verifyOTP() async {
    // DEBUG: Print OTP verification attempt
    print('=== VERIFY OTP BUTTON PRESSED ===');
    String enteredOTP = _otpControllers.map((controller) => controller.text).join();
    print('Entered OTP: $enteredOTP');
    
    // Check if all 4 digits are entered
    if (enteredOTP.length != 4) {
      print('❌ INCOMPLETE OTP - Only ${enteredOTP.length} digits entered');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter the complete OTP'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    print('✅ COMPLETE OTP ENTERED - 4 digits');

    setState(() {
      _isLoading = true;
      print('🔄 VERIFYING OTP - Showing loading spinner');
    });

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));

    if (enteredOTP == _correctOTP) {
      // OTP verification successful
      print('✅ OTP VERIFICATION SUCCESSFUL - Correct OTP entered');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password reset successful!'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Navigate back to login screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    } else {
      // Invalid OTP
      print('❌ OTP VERIFICATION FAILED - Incorrect OTP');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid OTP. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
        print('🔄 OTP VERIFICATION COMPLETED - Loading spinner hidden');
      });
    }
  }

  void _resendOTP() {
    if (!_canResend) return;

    print('🔄 RESENDING OTP');
    setState(() {
      _canResend = false;
      _resendTimer = 30;
    });

    // Clear all OTP fields
    for (var controller in _otpControllers) {
      controller.clear();
    }

    _startResendTimer();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('OTP has been resent to your email'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _startResendTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _resendTimer--;
        });
        
        if (_resendTimer > 0) {
          _startResendTimer();
        } else {
          setState(() {
            _canResend = true;
            print('✅ RESEND TIMER EXPIRED - Can resend OTP now');
          });
        }
      }
    });
  }

  void _handleOTPChange(String value, int index) {
    print('📝 OTP Field $index changed: "$value"');
    if (value.length == 1 && index < 3) {
      // Move to next field when digit is entered
      _otpFocusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      // Move to previous field when digit is deleted
      _otpFocusNodes[index - 1].requestFocus();
    }
  }

  @override
  void initState() {
    super.initState();
    print('🕒 STARTING RESEND TIMER - 30 seconds');
    _startResendTimer();
  }

  @override
  void dispose() {
    // Clean up controllers and focus nodes to prevent memory leaks
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var focusNode in _otpFocusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            print('🔙 BACK BUTTON PRESSED - Returning to Forgot Password');
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top,
            ),
            child: IntrinsicHeight(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ========== ILLUSTRATION SECTION ==========
                  Container(
                    height: 200,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Verification Icon
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: const Color(0xFF27AE60).withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.verified_user,
                            color: Color(0xFF27AE60),
                            size: 60,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Title
                        const Text(
                          'OTP Verification',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2C3E50),
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Description with dynamic email
                        Text(
                          "Enter the 4-digit code sent to ${widget.email}",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  // ========== OTP INPUT SECTION ==========
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // OTP Input Fields Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(4, (index) {
                            return SizedBox(
                              width: 60,
                              height: 60,
                              child: TextFormField(
                                controller: _otpControllers[index],
                                focusNode: _otpFocusNodes[index],
                                textAlign: TextAlign.center,
                                maxLength: 1,
                                keyboardType: TextInputType.number,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                decoration: InputDecoration(
                                  counterText: '',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[50],
                                ),
                                onChanged: (value) => _handleOTPChange(value, index),
                              ),
                            );
                          }),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Resend Code Section
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Didn't receive code?",
                              style: TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(width: 8),
                            _canResend
                                ? TextButton(
                                    onPressed: _resendOTP,
                                    child: const Text(
                                      'Resend',
                                      style: TextStyle(
                                        color: Color(0xFF27AE60),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  )
                                : Text(
                                    'Resend in $_resendTimer s',
                                    style: const TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                          ],
                        ),
                        
                        const SizedBox(height: 32),
                        
                        // ========== VERIFY BUTTON ==========
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _verifyOTP,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF27AE60),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : const Text(
                                    'Verify & Continue',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 20), // Extra bottom padding
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}