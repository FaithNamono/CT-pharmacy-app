import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../utils/constants.dart';
import '../../utils/validators.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';

class AddPrescriptionScreen extends StatefulWidget {
  const AddPrescriptionScreen({Key? key}) : super(key: key);

  @override
  State<AddPrescriptionScreen> createState() => _AddPrescriptionScreenState();
}

class _AddPrescriptionScreenState extends State<AddPrescriptionScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  final _patientNameController = TextEditingController();
  final _patientPhoneController = TextEditingController();
  final _doctorNameController = TextEditingController();
  final _doctorContactController = TextEditingController();
  final _clinicNameController = TextEditingController();
  final _notesController = TextEditingController();
  
  DateTime? _dateIssued;
  File? _prescriptionImage;
  bool _isLoading = false;

  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _patientNameController.dispose();
    _patientPhoneController.dispose();
    _doctorNameController.dispose();
    _doctorContactController.dispose();
    _clinicNameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 80,
    );
    
    if (image == null) {
      // Try gallery if camera fails or user cancels
      final XFile? galleryImage = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );
      if (galleryImage != null) {
        setState(() {
          _prescriptionImage = File(galleryImage.path);
        });
      }
    } else {
      setState(() {
        _prescriptionImage = File(image.path);
      });
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryGreen,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dateIssued = picked;
      });
    }
  }

  Future<void> _savePrescription() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (_prescriptionImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please take or select a prescription image'),
          backgroundColor: AppColors.warningRed,
        ),
      );
      return;
    }

    if (_dateIssued == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select the date issued'),
          backgroundColor: AppColors.warningRed,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Simulate upload delay
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Prescription uploaded successfully!'),
          backgroundColor: AppColors.primaryGreen,
        ),
      );
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Prescription'),
        backgroundColor: AppColors.primaryGreen,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Capture Section
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: AppColors.lightGrey,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _prescriptionImage == null
                          ? AppColors.primaryGreen
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: _prescriptionImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            _prescriptionImage!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.camera_alt,
                              size: 60,
                              color: AppColors.primaryGreen.withOpacity(0.5),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Tap to take a photo',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.primaryGreen,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'or select from gallery',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.darkGrey,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 24),

              // Patient Information
              const Text(
                'Patient Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkText,
                ),
              ),
              const SizedBox(height: 16),

              CustomTextField(
                controller: _patientNameController,
                label: 'Patient Name *',
                prefixIcon: Icons.person,
                validator: (value) => Validators.validateRequired(value, 'Patient name'),
              ),
              const SizedBox(height: 16),

              CustomTextField(
                controller: _patientPhoneController,
                label: 'Patient Phone',
                prefixIcon: Icons.phone,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 24),

              // Prescription Details
              const Text(
                'Prescription Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkText,
                ),
              ),
              const SizedBox(height: 16),

              // Date Issued Picker
              GestureDetector(
                onTap: _selectDate,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(
                    color: AppColors.lightGrey,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, color: AppColors.primaryGreen),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _dateIssued == null
                              ? 'Date Issued *'
                              : 'Issued: ${_dateIssued!.day}/${_dateIssued!.month}/${_dateIssued!.year}',
                          style: TextStyle(
                            color: _dateIssued == null
                                ? AppColors.darkGrey
                                : AppColors.darkText,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              CustomTextField(
                controller: _doctorNameController,
                label: 'Doctor Name',
                prefixIcon: Icons.medical_services,
              ),
              const SizedBox(height: 16),

              CustomTextField(
                controller: _doctorContactController,
                label: 'Doctor Contact',
                prefixIcon: Icons.phone,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),

              CustomTextField(
                controller: _clinicNameController,
                label: 'Clinic/Hospital',
                prefixIcon: Icons.local_hospital,
              ),
              const SizedBox(height: 16),

              CustomTextField(
                controller: _notesController,
                label: 'Additional Notes',
                prefixIcon: Icons.note,
                maxLines: 3,
              ),
              const SizedBox(height: 32),

              // Upload Button
              CustomButton(
                text: 'UPLOAD PRESCRIPTION',
                onPressed: _savePrescription,
                isLoading: _isLoading,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}