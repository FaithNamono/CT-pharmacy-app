import 'package:flutter/material.dart';
import '../../utils/constants.dart';  // Fixed: ../../ instead of ../
import '../../utils/helpers.dart';    // Fixed: ../../ instead of ../
import '../../widgets/custom_button.dart';  // Fixed: ../../ instead of ../
import '../../widgets/custom_textfield.dart';  // Fixed: ../../ instead of ../

class CheckoutScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final double total;

  const CheckoutScreen({
    Key? key,
    required this.cartItems,
    required this.total,
  }) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _selectedPaymentMethod = 'cash';
  double _amountPaid = 0;
  double _changeDue = 0;
  String? _customerName;
  String? _customerPhone;
  bool _isLoading = false;

  final List<String> _paymentMethods = [
    'cash',
    'mobile_money',
    'card',
  ];

  @override
  void initState() {
    super.initState();
    _amountPaid = widget.total;
    _changeDue = 0;
  }

  void _calculateChange(String value) {
    final paid = double.tryParse(value) ?? 0;
    setState(() {
      _amountPaid = paid;
      _changeDue = paid - widget.total;
    });
  }

  Future<void> _processPayment() async {
    if (_amountPaid < widget.total) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Amount paid is less than total'),
          backgroundColor: AppColors.warningRed,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Simulate payment processing
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Icon(Icons.check_circle, color: AppColors.primaryGreen, size: 60),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Payment Successful!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkText,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Total: UGX ${Helpers.formatNumber(widget.total)}',
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                'Paid: UGX ${Helpers.formatNumber(_amountPaid)}',
                style: const TextStyle(fontSize: 16),
              ),
              Text(
                'Change: UGX ${Helpers.formatNumber(_changeDue)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryGreen,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Receipt has been generated',
                style: TextStyle(color: AppColors.darkGrey),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Go back to cart
                Navigator.pop(context); // Go back to POS
              },
              child: const Text('Done'),
            ),
            TextButton(
              onPressed: () {
                // TODO: Print receipt
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Printing receipt...'),
                    backgroundColor: AppColors.primaryGreen,
                  ),
                );
              },
              child: const Text('Print Receipt'),
            ),
          ],
        ),
      );
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: AppColors.primaryGreen,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Summary
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Order Summary',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkText,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...widget.cartItems.map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${item['quantity']}x ${item['name']}',
                              style: const TextStyle(color: AppColors.darkText),
                            ),
                          ),
                          Text(
                            'UGX ${Helpers.formatNumber(item['price'] * item['quantity'])}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              color: AppColors.darkText,
                            ),
                          ),
                        ],
                      ),
                    )).toList(),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkText,
                          ),
                        ),
                        Text(
                          'UGX ${Helpers.formatNumber(widget.total)}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryGreen,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Customer Information (Optional)
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Customer Information (Optional)',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkText,
                      ),
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      controller: TextEditingController(),
                      label: 'Customer Name',
                      prefixIcon: Icons.person,
                      onChanged: (value) => _customerName = value,
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      controller: TextEditingController(),
                      label: 'Phone Number',
                      prefixIcon: Icons.phone,
                      keyboardType: TextInputType.phone,
                      onChanged: (value) => _customerPhone = value,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Payment Method
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Payment Method',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkText,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ..._paymentMethods.map((method) => RadioListTile<String>(
                      title: Text(
                        method.split('_').map((word) => 
                          word[0].toUpperCase() + word.substring(1)
                        ).join(' '),
                      ),
                      value: method,
                      groupValue: _selectedPaymentMethod,
                      onChanged: (value) {
                        setState(() {
                          _selectedPaymentMethod = value!;
                        });
                      },
                      activeColor: AppColors.primaryGreen,
                      contentPadding: EdgeInsets.zero,
                    )),
                    
                    if (_selectedPaymentMethod == 'mobile_money') ...[
                      const SizedBox(height: 12),
                      CustomTextField(
                        controller: TextEditingController(),
                        label: 'Mobile Money Number',
                        prefixIcon: Icons.phone_android,
                        keyboardType: TextInputType.phone,
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Payment
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    CustomTextField(
                      controller: TextEditingController(text: widget.total.toString()),
                      label: 'Amount Paid',
                      prefixIcon: Icons.attach_money,
                      keyboardType: TextInputType.number,
                      onChanged: _calculateChange,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Change Due:',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.darkText,
                          ),
                        ),
                        Text(
                          'UGX ${Helpers.formatNumber(_changeDue)}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: _changeDue >= 0 
                                ? AppColors.primaryGreen 
                                : AppColors.warningRed,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Complete Payment Button
            CustomButton(
              text: 'COMPLETE PAYMENT',
              onPressed: _processPayment,
              isLoading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }
}