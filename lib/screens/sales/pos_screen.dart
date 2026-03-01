import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import 'cart_screen.dart'; // You'll need to create this

class POSScreen extends StatefulWidget {
  const POSScreen({Key? key}) : super(key: key);

  @override
  State<POSScreen> createState() => _POSScreenState();
}

class _POSScreenState extends State<POSScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.point_of_sale, size: 80, color: AppColors.primaryGreen),
            const SizedBox(height: 16),
            const Text(
              'Point of Sale',
              style: TextStyle(fontSize: 24, color: AppColors.darkText),
            ),
            const SizedBox(height: 8),
            const Text(
              'Click the + button to start a new sale',
              style: TextStyle(fontSize: 16, color: AppColors.darkGrey),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to Cart screen to start new sale
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CartScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}