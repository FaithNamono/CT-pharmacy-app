import 'package:flutter/material.dart';
import '../../utils/constants.dart';  // Fixed: ../../utils/constants.dart
import '../../utils/helpers.dart';    // Fixed: ../../utils/helpers.dart
import '../../widgets/sale_item_card.dart';  // Fixed: ../../widgets/sale_item_card.dart

class SalesHistoryScreen extends StatefulWidget {
  const SalesHistoryScreen({Key? key}) : super(key: key);

  @override
  State<SalesHistoryScreen> createState() => _SalesHistoryScreenState();
}

class _SalesHistoryScreenState extends State<SalesHistoryScreen> {
  String _selectedFilter = 'all'; // all, today, week, month
  String _selectedPaymentFilter = 'all';
  DateTime? _startDate;
  DateTime? _endDate;
  bool _showFilters = false;

  // Sample data - replace with actual data from API
  final List<Map<String, dynamic>> _sales = [
    {
      'id': 'INV-202601-0001',
      'date': DateTime.now().subtract(const Duration(hours: 2)),
      'customer': 'John Doe',
      'items': 3,
      'total': 45000,
      'payment_method': 'cash',
      'status': 'completed',
    },
    {
      'id': 'INV-202601-0002',
      'date': DateTime.now().subtract(const Duration(days: 1)),
      'customer': 'Jane Smith',
      'items': 2,
      'total': 28000,
      'payment_method': 'mobile_money',
      'status': 'completed',
    },
    {
      'id': 'INV-202601-0003',
      'date': DateTime.now().subtract(const Duration(days: 2)),
      'customer': 'Peter Jones',
      'items': 5,
      'total': 127000,
      'payment_method': 'card',
      'status': 'completed',
    },
    {
      'id': 'INV-202601-0004',
      'date': DateTime.now().subtract(const Duration(days: 3)),
      'customer': 'Mary Johnson',
      'items': 1,
      'total': 8500,
      'payment_method': 'cash',
      'status': 'voided',
    },
    {
      'id': 'INV-202601-0005',
      'date': DateTime.now().subtract(const Duration(days: 5)),
      'customer': 'Dr. Mugisha',
      'items': 4,
      'total': 89500,
      'payment_method': 'mobile_money',
      'status': 'completed',
    },
  ];

  List<Map<String, dynamic>> get _filteredSales {
    return _sales.where((sale) {
      // Filter by date
      if (_selectedFilter == 'today') {
        if (!Helpers.isToday(sale['date'])) return false;
      } else if (_selectedFilter == 'week') {
        if (!Helpers.isThisWeek(sale['date'])) return false;
      } else if (_selectedFilter == 'month') {
        if (!Helpers.isThisMonth(sale['date'])) return false;
      }

      // Filter by payment method
      if (_selectedPaymentFilter != 'all' && 
          sale['payment_method'] != _selectedPaymentFilter) {
        return false;
      }

      return true;
    }).toList();
  }

  double get _totalSales {
    return _filteredSales.fold(0, (sum, sale) => sum + sale['total']);
  }

  int get _totalTransactions {
    return _filteredSales.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales History'),
        backgroundColor: AppColors.primaryGreen,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              setState(() {
                _showFilters = !_showFilters;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Summary Cards
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.white,
            child: Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    'Total Sales',
                    'UGX ${Helpers.formatNumber(_totalSales)}',
                    Icons.attach_money,
                    AppColors.primaryGreen,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSummaryCard(
                    'Transactions',
                    _totalTransactions.toString(),
                    Icons.receipt,
                    AppColors.infoBlue,
                  ),
                ),
              ],
            ),
          ),

          // Filters
          if (_showFilters)
            Container(
              padding: const EdgeInsets.all(16),
              color: AppColors.lightGrey,
              child: Column(
                children: [
                  // Date Filter Chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterChip('All', 'all'),
                        _buildFilterChip('Today', 'today'),
                        _buildFilterChip('This Week', 'week'),
                        _buildFilterChip('This Month', 'month'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Payment Method Filter
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildPaymentFilterChip('All', 'all'),
                        _buildPaymentFilterChip('Cash', 'cash'),
                        _buildPaymentFilterChip('Mobile Money', 'mobile_money'),
                        _buildPaymentFilterChip('Card', 'card'),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          // Sales List
          Expanded(
            child: _filteredSales.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.receipt,
                          size: 80,
                          color: AppColors.mediumGrey,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No sales found',
                          style: TextStyle(fontSize: 18, color: AppColors.darkGrey),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredSales.length,
                    itemBuilder: (context, index) {
                      final sale = _filteredSales[index];
                      return SaleItemCard(
                        sale: sale,
                        onTap: () {
                          _showSaleDetails(context, sale);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.darkGrey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: _selectedFilter == value,
        onSelected: (selected) {
          setState(() {
            _selectedFilter = value;
          });
        },
        selectedColor: AppColors.primaryGreen,
        checkmarkColor: AppColors.white,
        labelStyle: TextStyle(
          color: _selectedFilter == value ? AppColors.white : AppColors.darkText,
        ),
      ),
    );
  }

  Widget _buildPaymentFilterChip(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: _selectedPaymentFilter == value,
        onSelected: (selected) {
          setState(() {
            _selectedPaymentFilter = value;
          });
        },
        selectedColor: AppColors.infoBlue,
        checkmarkColor: AppColors.white,
        labelStyle: TextStyle(
          color: _selectedPaymentFilter == value ? AppColors.white : AppColors.darkText,
        ),
      ),
    );
  }

  void _showSaleDetails(BuildContext context, Map<String, dynamic> sale) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.mediumGrey,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      sale['id'],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkText,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: sale['status'] == 'completed'
                            ? AppColors.primaryGreen.withOpacity(0.1)
                            : AppColors.warningRed.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        sale['status'].toString().toUpperCase(),
                        style: TextStyle(
                          color: sale['status'] == 'completed'
                              ? AppColors.primaryGreen
                              : AppColors.warningRed,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  Helpers.formatDateTime(sale['date']),
                  style: const TextStyle(color: AppColors.darkGrey),
                ),
                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 20),
                
                // Customer Info
                _buildDetailRow('Customer', sale['customer']),
                _buildDetailRow('Payment Method', 
                  sale['payment_method'].split('_').map((word) => 
                    word[0].toUpperCase() + word.substring(1)
                  ).join(' ')
                ),
                _buildDetailRow('Items', sale['items'].toString()),
                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 20),
                
                // Total
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Amount',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkText,
                      ),
                    ),
                    Text(
                      'UGX ${Helpers.formatNumber(sale['total'])}',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryGreen,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                
                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.print),
                        label: const Text('Print Receipt'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primaryGreen,
                          side: const BorderSide(color: AppColors.primaryGreen),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    if (sale['status'] != 'voided')
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            _showVoidConfirmation(context, sale['id']);
                          },
                          icon: const Icon(Icons.cancel),
                          label: const Text('Void Sale'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.warningRed,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.darkGrey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: AppColors.darkText,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showVoidConfirmation(BuildContext context, String saleId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Void Sale'),
        content: Text('Are you sure you want to void sale $saleId?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Close bottom sheet
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Sale voided successfully'),
                  backgroundColor: AppColors.primaryGreen,
                ),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.warningRed,
            ),
            child: const Text('Void'),
          ),
        ],
      ),
    );
  }
}