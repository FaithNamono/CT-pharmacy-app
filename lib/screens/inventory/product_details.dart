import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product_model.dart';
import '../../providers/product_provider.dart';
import '../../utils/constants.dart';
import '../../utils/helpers.dart';
import '../../widgets/custom_button.dart';
import 'add_product_screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  final int productId;

  const ProductDetailsScreen({Key? key, required this.productId}) : super(key: key);

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final product = productProvider.getProductById(widget.productId);

    if (product == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Product Not Found'),
          backgroundColor: AppColors.primaryGreen,
        ),
        body: const Center(
          child: Text('Product not found'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        backgroundColor: AppColors.primaryGreen,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddProductScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: AppColors.warningRed),
            onPressed: () => _showDeleteConfirmation(context, product),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image Placeholder
            Center(
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: AppColors.lightGrey,
                  borderRadius: BorderRadius.circular(75),
                  border: Border.all(color: AppColors.primaryGreen, width: 3),
                ),
                child: Icon(
                  Icons.medical_services,
                  size: 70,
                  color: AppColors.primaryGreen.withOpacity(0.5),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Status Badges
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (product.isLowStock)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.warningOrange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.warningOrange),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.warning, size: 16, color: AppColors.warningOrange),
                        const SizedBox(width: 4),
                        Text(
                          'Low Stock',
                          style: TextStyle(
                            color: AppColors.warningOrange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                if (product.isExpired)
                  Container(
                    margin: const EdgeInsets.only(left: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.warningRed.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.warningRed),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.error, size: 16, color: AppColors.warningRed),
                        const SizedBox(width: 4),
                        Text(
                          'Expired',
                          style: TextStyle(
                            color: AppColors.warningRed,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                if (product.isExpiringSoon && !product.isExpired)
                  Container(
                    margin: const EdgeInsets.only(left: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.warningOrange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.warningOrange),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.timer, size: 16, color: AppColors.warningOrange),
                        const SizedBox(width: 4),
                        Text(
                          'Expiring Soon',
                          style: TextStyle(
                            color: AppColors.warningOrange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 24),

            _buildInfoSection('Basic Information', [
              _buildInfoRow('Product Name', product.name),
              _buildInfoRow('Generic Name', product.genericName ?? 'N/A'),
              _buildInfoRow('Category', product.category),
              _buildInfoRow('Batch Number', product.batchNumber),
            ]),

            const SizedBox(height: 16),
            _buildInfoSection('Pricing', [
              _buildInfoRow('Cost Price', 'UGX ${Helpers.formatNumber(product.costPrice)}'),
              _buildInfoRow('Selling Price', 'UGX ${Helpers.formatNumber(product.sellingPrice)}'),
              _buildInfoRow('Profit Margin', 'UGX ${Helpers.formatNumber(product.profitMargin)}'),
            ]),

            const SizedBox(height: 16),
            _buildInfoSection('Stock Information', [
              _buildInfoRow('Current Stock', '${product.quantity} units'),
              _buildInfoRow('Minimum Stock', '${product.minStockLevel} units'),
              _buildInfoRow('Total Value', 'UGX ${Helpers.formatNumber(product.totalValue)}'),
            ]),

            const SizedBox(height: 16),
            _buildInfoSection('Expiry Information', [
              _buildInfoRow('Expiry Date', Helpers.formatDate(product.expiryDate)),
              _buildInfoRow('Days Until Expiry', _getDaysUntilExpiry(product.expiryDate)),
            ]),

            const SizedBox(height: 16),
            _buildInfoSection('Supplier Information', [
              _buildInfoRow('Manufacturer', product.manufacturer ?? 'N/A'),
              _buildInfoRow('Supplier', product.supplier ?? 'N/A'),
            ]),

            if (product.description != null && product.description!.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildInfoSection('Description', [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    product.description!,
                    style: const TextStyle(color: AppColors.darkGrey),
                  ),
                ),
              ]),
            ],

            const SizedBox(height: 24),
            
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primaryGreen,
                      side: const BorderSide(color: AppColors.primaryGreen),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('BACK'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Add to sale
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Add to sale feature coming soon!'),
                          backgroundColor: AppColors.primaryGreen,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGreen,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('ADD TO SALE'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, List<Widget> children) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryGreen,
              ),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.darkGrey,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: AppColors.darkText,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getDaysUntilExpiry(DateTime expiryDate) {
    final days = expiryDate.difference(DateTime.now()).inDays;
    if (days < 0) return 'Expired';
    if (days == 0) return 'Today';
    return '$days days';
  }

  void _showDeleteConfirmation(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Product'),
        content: Text('Are you sure you want to delete ${product.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              setState(() => _isLoading = true);
              
              final productProvider = Provider.of<ProductProvider>(context, listen: false);
              final success = await productProvider.deleteProduct(product.id);
              
              if (success && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(AppStrings.productDeleted),
                    backgroundColor: AppColors.primaryGreen,
                  ),
                );
                Navigator.pop(context);
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.warningRed,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}