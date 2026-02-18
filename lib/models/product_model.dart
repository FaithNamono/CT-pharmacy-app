class Product {
  final int id;
  final String name;
  final String? genericName;
  final String category;
  final String batchNumber;
  final double costPrice;
  final double sellingPrice;
  final int quantity;
  final int minStockLevel;
  final DateTime expiryDate;
  final String? manufacturer;
  final String? supplier;
  final String? description;
  final String? barcode;
  final bool isActive;
  final int userId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Product({
    required this.id,
    required this.name,
    this.genericName,
    required this.category,
    required this.batchNumber,
    required this.costPrice,
    required this.sellingPrice,
    required this.quantity,
    required this.minStockLevel,
    required this.expiryDate,
    this.manufacturer,
    this.supplier,
    this.description,
    this.barcode,
    required this.isActive,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      genericName: json['generic_name'],
      category: json['category'] ?? '',
      batchNumber: json['batch_number'] ?? '',
      costPrice: (json['cost_price'] ?? 0).toDouble(),
      sellingPrice: (json['selling_price'] ?? 0).toDouble(),
      quantity: json['quantity'] ?? 0,
      minStockLevel: json['min_stock_level'] ?? 10,
      expiryDate: DateTime.parse(json['expiry_date'] ?? DateTime.now().toIso8601String()),
      manufacturer: json['manufacturer'],
      supplier: json['supplier'],
      description: json['description'],
      barcode: json['barcode'],
      isActive: json['is_active'] ?? true,
      userId: json['user_id'] ?? 0,
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updated_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'generic_name': genericName,
      'category': category,
      'batch_number': batchNumber,
      'cost_price': costPrice,
      'selling_price': sellingPrice,
      'quantity': quantity,
      'min_stock_level': minStockLevel,
      'expiry_date': expiryDate.toIso8601String().split('T')[0],
      'manufacturer': manufacturer,
      'supplier': supplier,
      'description': description,
      'barcode': barcode,
    };
  }

  // Check if product is low in stock
  bool get isLowStock => quantity <= minStockLevel;

  // Check if product is expired
  bool get isExpired => expiryDate.isBefore(DateTime.now());

  // Check if product is expiring soon (within 30 days)
  bool get isExpiringSoon {
    final daysUntilExpiry = expiryDate.difference(DateTime.now()).inDays;
    return daysUntilExpiry <= 30 && daysUntilExpiry > 0;
  }

  // Get profit margin per unit
  double get profitMargin => sellingPrice - costPrice;

  // Get total value in stock
  double get totalValue => quantity * costPrice;
}