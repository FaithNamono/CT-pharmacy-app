import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../providers/product_provider.dart';
import '../../utils/constants.dart';
import '../../utils/validators.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  final _nameController = TextEditingController();
  final _genericNameController = TextEditingController();
  final _batchNumberController = TextEditingController();
  final _costPriceController = TextEditingController();
  final _sellingPriceController = TextEditingController();
  final _quantityController = TextEditingController();
  final _minStockController = TextEditingController();
  final _manufacturerController = TextEditingController();
  final _supplierController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  // Selected values
  String _selectedCategory = 'Pain Relief';
  final List<String> _categories = [
    'Pain Relief',
    'Antibiotics',
    'Antimalarials',
    'Vitamins',
    'Cough & Cold',
    'Diabetes',
    'Hypertension',
    'First Aid',
    'Other'
  ];
  
  DateTime? _selectedExpiryDate;
  File? _productImage;
  bool _isLoading = false;

  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _nameController.dispose();
    _genericNameController.dispose();
    _batchNumberController.dispose();
    _costPriceController.dispose();
    _sellingPriceController.dispose();
    _quantityController.dispose();
    _minStockController.dispose();
    _manufacturerController.dispose();
    _supplierController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _productImage = File(image.path);
      });
    }
  }

  Future<void> _selectExpiryDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
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
        _selectedExpiryDate = picked;
      });
    }
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (_selectedExpiryDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select expiry date'),
          backgroundColor: AppColors.warningRed,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final productData = {
      'name': _nameController.text.trim(),
      'generic_name': _genericNameController.text.trim(),
      'category': _selectedCategory,
      'batch_number': _batchNumberController.text.trim(),
      'cost_price': double.parse(_costPriceController.text),
      'selling_price': double.parse(_sellingPriceController.text),
      'quantity': int.parse(_quantityController.text),
      'min_stock_level': int.parse(_minStockController.text),
      'expiry_date': _selectedExpiryDate!.toIso8601String().split('T')[0],
      'manufacturer': _manufacturerController.text.trim(),
      'supplier': _supplierController.text.trim(),
      'description': _descriptionController.text.trim(),
    };

    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    final success = await productProvider.addProduct(productData);

    setState(() => _isLoading = false);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(AppStrings.productAdded),
          backgroundColor: AppColors.primaryGreen,
        ),
      );
      Navigator.pop(context, true);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(productProvider.error ?? 'Failed to add product'),
          backgroundColor: AppColors.warningRed,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Product'),
        backgroundColor: AppColors.primaryGreen,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: AppColors.lightGrey,
                      borderRadius: BorderRadius.circular(60),
                      border: Border.all(color: AppColors.primaryGreen, width: 2),
                    ),
                    child: _productImage != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(60),
                            child: Image.file(
                              _productImage!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_photo_alternate,
                                size: 40,
                                color: AppColors.primaryGreen.withOpacity(0.5),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Add Photo',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.primaryGreen,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Product Details Section
              const Text(
                'Product Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkText,
                ),
              ),
              const SizedBox(height: 16),

              CustomTextField(
                controller: _nameController,
                label: 'Product Name *',
                prefixIcon: Icons.medical_services,
                validator: (value) => Validators.validateRequired(value, 'Product name'),
              ),
              const SizedBox(height: 16),

              CustomTextField(
                controller: _genericNameController,
                label: 'Generic Name',
                prefixIcon: Icons.science,
              ),
              const SizedBox(height: 16),

              // Category Dropdown
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Category *',
                  prefixIcon: const Icon(Icons.category, color: AppColors.primaryGreen),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: AppColors.lightGrey,
                ),
                items: _categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
              ),
              const SizedBox(height: 16),

              CustomTextField(
                controller: _batchNumberController,
                label: 'Batch Number *',
                prefixIcon: Icons.qr_code,
                validator: (value) => Validators.validateRequired(value, 'Batch number'),
              ),
              const SizedBox(height: 16),

              // Expiry Date Picker
              GestureDetector(
                onTap: _selectExpiryDate,
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
                          _selectedExpiryDate == null
                              ? 'Expiry Date *'
                              : 'Expiry: ${_selectedExpiryDate!.day}/${_selectedExpiryDate!.month}/${_selectedExpiryDate!.year}',
                          style: TextStyle(
                            color: _selectedExpiryDate == null
                                ? AppColors.darkGrey
                                : AppColors.darkText,
                          ),
                        ),
                      ),
                      if (_selectedExpiryDate != null)
                        IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () {
                            setState(() {
                              _selectedExpiryDate = null;
                            });
                          },
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Pricing Section
              const Text(
                'Pricing Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkText,
                ),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _costPriceController,
                      label: 'Cost Price *',
                      prefixIcon: Icons.attach_money,
                      keyboardType: TextInputType.number,
                      validator: (value) => Validators.validatePrice(value),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomTextField(
                      controller: _sellingPriceController,
                      label: 'Selling Price *',
                      prefixIcon: Icons.attach_money,
                      keyboardType: TextInputType.number,
                      validator: (value) => Validators.validatePrice(value),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Stock Section
              const Text(
                'Stock Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkText,
                ),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _quantityController,
                      label: 'Quantity *',
                      prefixIcon: Icons.inventory,
                      keyboardType: TextInputType.number,
                      validator: (value) => Validators.validateQuantity(value),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomTextField(
                      controller: _minStockController,
                      label: 'Min Stock *',
                      prefixIcon: Icons.warning,
                      keyboardType: TextInputType.number,
                      validator: (value) => Validators.validateQuantity(value),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Supplier Section
              const Text(
                'Supplier Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkText,
                ),
              ),
              const SizedBox(height: 16),

              CustomTextField(
                controller: _manufacturerController,
                label: 'Manufacturer',
                prefixIcon: Icons.factory,
              ),
              const SizedBox(height: 16),

              CustomTextField(
                controller: _supplierController,
                label: 'Supplier',
                prefixIcon: Icons.business,
              ),
              const SizedBox(height: 16),

              CustomTextField(
                controller: _descriptionController,
                label: 'Description',
                prefixIcon: Icons.description,
                maxLines: 3,
              ),
              const SizedBox(height: 32),

              // Save Button
              CustomButton(
                text: 'SAVE PRODUCT',
                onPressed: _saveProduct,
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