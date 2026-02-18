import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/api_service.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  Map<String, dynamic>? _stats;
  bool _isLoading = false;
  String? _error;
  int _currentPage = 1;
  int _lastPage = 1;
  int _total = 0;

  // Getters
  List<Product> get products => _products;
  Map<String, dynamic>? get stats => _stats;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get currentPage => _currentPage;
  int get lastPage => _lastPage;
  int get total => _total;
  bool get hasMorePages => _currentPage < _lastPage;

  // Load products with filters
  Future<void> loadProducts({
    String? search,
    String? category,
    bool? lowStock,
    bool? expiringSoon,
    bool refresh = false,
  }) async {
    if (refresh) {
      _currentPage = 1;
      _products.clear();
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    final response = await ApiService.getProducts(
      search: search,
      category: category,
      lowStock: lowStock,
      expiringSoon: expiringSoon,
      page: _currentPage,
    );

    if (response['success'] == true) {
      if (refresh) {
        _products = response['products'];
      } else {
        _products.addAll(response['products']);
      }
      _currentPage = response['current_page'] + 1;
      _lastPage = response['last_page'];
      _total = response['total'];
      _error = null;
    } else {
      _error = response['message'] ?? 'Failed to load products';
    }

    _isLoading = false;
    notifyListeners();
  }

  // Load more products (pagination)
  Future<void> loadMoreProducts({
    String? search,
    String? category,
    bool? lowStock,
    bool? expiringSoon,
  }) async {
    if (!hasMorePages || _isLoading) return;
    await loadProducts(
      search: search,
      category: category,
      lowStock: lowStock,
      expiringSoon: expiringSoon,
    );
  }

  // Load product statistics
  Future<void> loadStats() async {
    final response = await ApiService.getProductStats();
    if (response['success'] == true) {
      _stats = response['stats'];
      notifyListeners();
    }
  }

  // Add new product
  Future<bool> addProduct(Map<String, dynamic> productData) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final response = await ApiService.createProduct(productData);

    if (response['success'] == true) {
      await loadProducts(refresh: true);
      await loadStats();
      _isLoading = false;
      notifyListeners();
      return true;
    } else {
      _error = response['message'] ?? 'Failed to add product';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Update product
  Future<bool> updateProduct(int id, Map<String, dynamic> productData) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final response = await ApiService.updateProduct(id, productData);

    if (response['success'] == true) {
      // Update local list
      final index = _products.indexWhere((p) => p.id == id);
      if (index != -1) {
        _products[index] = response['product'];
      }
      await loadStats();
      _isLoading = false;
      notifyListeners();
      return true;
    } else {
      _error = response['message'] ?? 'Failed to update product';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Delete product
  Future<bool> deleteProduct(int id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final response = await ApiService.deleteProduct(id);

    if (response['success'] == true) {
      _products.removeWhere((p) => p.id == id);
      await loadStats();
      _isLoading = false;
      notifyListeners();
      return true;
    } else {
      _error = response['message'] ?? 'Failed to delete product';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Get product by id
  Product? getProductById(int id) {
    try {
      return _products.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Refresh all data
  Future<void> refreshAll() async {
    await Future.wait([
      loadProducts(refresh: true),
      loadStats(),
    ]);
  }

  // Get low stock products
  List<Product> get lowStockProducts {
    return _products.where((p) => p.isLowStock).toList();
  }

  // Get expiring soon products
  List<Product> get expiringSoonProducts {
    return _products.where((p) => p.isExpiringSoon).toList();
  }

  // Get products by category
  List<Product> getProductsByCategory(String category) {
    return _products.where((p) => p.category == category).toList();
  }

  // Get all categories
  List<String> get categories {
    return _products.map((p) => p.category).toSet().toList();
  }

  // Get total inventory value
  double get totalInventoryValue {
    return _products.fold(0, (sum, product) => sum + product.totalValue);
  }
}