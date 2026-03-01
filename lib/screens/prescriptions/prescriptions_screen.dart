import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class PrescriptionsScreen extends StatefulWidget {
  const PrescriptionsScreen({Key? key}) : super(key: key);

  @override
  State<PrescriptionsScreen> createState() => _PrescriptionsScreenState();
}

class _PrescriptionsScreenState extends State<PrescriptionsScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.medical_services, size: 80, color: AppColors.primaryGreen),
          SizedBox(height: 16),
          Text(
            'Prescription Management',
            style: TextStyle(fontSize: 24, color: AppColors.darkText),
          ),
          SizedBox(height: 8),
          Text(
            'Coming Soon',
            style: TextStyle(fontSize: 16, color: AppColors.darkGrey),
          ),
        ],
      ),
    );
  }
}