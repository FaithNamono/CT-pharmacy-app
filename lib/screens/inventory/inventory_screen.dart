import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/product_provider.dart';
import '../../utils/constants.dart';
import '../../utils/helpers.dart';
import '../../widgets/product_card.dart';
import '../../widgets/loading_widget.dart';
import 'add_product_screen.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({Key? key}) : super(key: key);

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  String _selectedFilter = 'all'; // all, low-stock, expiring

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    // Debounce search to avoid too many requests
    Future.delayed(const Duration(milliseconds: 500), () {
      if (_searchController.text == _searchController.text) {
        _loadProducts();
      }
    });
  }

  Future<void> _loadProducts({bool refresh = true}) async {
    final provider = Provider.of<ProductProvider>(context, listen: false);
    
    await provider.loadProducts(
      search: _searchController.text.isNotEmpty ? _searchController.text : null,
      lowStock: _selectedFilter == 'low-stock',
      expiringSoon: _selectedFilter == 'expiring',
      refresh: refresh,
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context);

    return Scaffold(
      body: Column(
        children: [
          // Search and Filter Bar
          Container(
            padding: const EdgeInsets.all(AppSizes.paddingMedium),
            color: AppColors.white,
            child: Column(
              children: [
                // Search Field
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search products...',
                    prefixIcon: const Icon(Icons.search, color: AppColors.primaryGreen),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: AppColors.darkGrey),
                            onPressed: () {
                              _searchController.clear();
                              _loadProducts();
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: AppColors.lightGrey,
                  ),
                ),
                const SizedBox(height: 12),
                
                // Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      FilterChip(
                        label: const Text('All'),
                        selected: _selectedFilter == 'all',
                        onSelected: (selected) {
                          setState(() {
                            _selectedFilter = 'all';
                          });
                          _loadProducts();
                        },
                        selectedColor: AppColors.primaryGreen,
                        checkmarkColor: AppColors.white,
                        labelStyle: TextStyle(
                          color: _selectedFilter == 'all' ? AppColors.white : AppColors.darkText,
                        ),
                      ),
                      const SizedBox(width: 8),
                      FilterChip(
                        label: const Text('Low Stock'),
                        selected: _selectedFilter == 'low-stock',
                        onSelected: (selected) {
                          setState(() {
                            _selectedFilter = 'low-stock';
                          });
                          _loadProducts();
                        },
                        selectedColor: AppColors.warningOrange,
                        checkmarkColor: AppColors.white,
                        labelStyle: TextStyle(
                          color: _selectedFilter == 'low-stock' ? AppColors.white : AppColors.darkText,
                        ),
                      ),
                      const SizedBox(width: 8),
                      FilterChip(
                        label: const Text('Expiring Soon'),
                        selected: _selectedFilter == 'expiring',
                        onSelected: (selected) {
                          setState(() {
                            _selectedFilter = 'expiring';
                          });
                          _loadProducts();
                        },
                        selectedColor: AppColors.warningRed,
                        checkmarkColor: AppColors.white,
                        labelStyle: TextStyle(
                          color: _selectedFilter == 'expiring' ? AppColors.white : AppColors.darkText,
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Category Filter
                      DropdownButton<String>(
                        value: _selectedCategory,
                        icon: const Icon(Icons.filter_list, color: AppColors.primaryGreen),
                        underline: const SizedBox(),
                        items: [
                          'All',
                          ...provider.categories,
                        ].map((category) {
                          return DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCategory = value ?? 'All';
                          });
                          _loadProducts();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Product List
          Expanded(
            child: provider.isLoading && provider.products.isEmpty
                ? const Center(child: LoadingWidget())
                : provider.products.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.inventory, size: 80, color: AppColors.mediumGrey),
                            SizedBox(height: 16),
                            Text(
                              'No products found',
                              style: TextStyle(fontSize: 18, color: AppColors.darkGrey),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () => _loadProducts(refresh: true),
                        color: AppColors.primaryGreen,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(AppSizes.paddingMedium),
                          itemCount: provider.products.length + (provider.hasMorePages ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == provider.products.length) {
                              if (provider.hasMorePages && !provider.isLoading) {
                                provider.loadMoreProducts(
                                  search: _searchController.text.isNotEmpty ? _searchController.text : null,
                                  lowStock: _selectedFilter == 'low-stock',
                                  expiringSoon: _selectedFilter == 'expiring',
                                );
                              }
                              return const Padding(
                                padding: EdgeInsets.all(16),
                                child: Center(child: CircularProgressIndicator()),
                              );
                            }
                            
                            final product = provider.products[index];
                            return ProductCard(
                              product: product,
                              onTap: () {
                                // Navigate to product details
                              },
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddProductScreen()),
          ).then((added) {
            if (added == true) {
              _loadProducts(refresh: true);
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}