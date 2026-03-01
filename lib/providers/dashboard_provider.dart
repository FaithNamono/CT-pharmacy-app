import 'package:flutter/material.dart';
import '../services/api_service.dart';

class DashboardProvider with ChangeNotifier {
  Map<String, dynamic>? _dashboardData;
  Map<String, dynamic>? _salesChartData;
  bool _isLoading = false;
  String? _error;
  bool _isDisposed = false;

  // Getters
  Map<String, dynamic>? get dashboardData => _dashboardData;
  Map<String, dynamic>? get salesChartData => _salesChartData;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Load dashboard data
  Future<void> loadDashboard() async {
    if (_isDisposed) return;
    
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService.getDashboardData();

      if (!_isDisposed) {
        if (response['success'] == true) {
          _dashboardData = response['dashboard'];
          _error = null;
        } else {
          _error = response['message'] ?? 'Failed to load dashboard';
        }

        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      if (!_isDisposed) {
        _error = e.toString();
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  // Load sales chart data
  Future<void> loadSalesChart({int days = 7}) async {
    if (_isDisposed) return;
    
    try {
      final response = await ApiService.getSalesChart(days);

      if (!_isDisposed && response['success'] == true) {
        _salesChartData = response['chart'];
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading sales chart: $e');
    }
  }

  // Get today's sales
  double get todaySales {
    return _dashboardData?['sales']?['today']?['total']?.toDouble() ?? 0;
  }

  // Get today's sales count
  int get todaySalesCount {
    return _dashboardData?['sales']?['today']?['count'] ?? 0;
  }

  // Get week sales
  double get weekSales {
    return _dashboardData?['sales']?['week']?.toDouble() ?? 0;
  }

  // Get month sales
  double get monthSales {
    return _dashboardData?['sales']?['month']?.toDouble() ?? 0;
  }

  // Get total products
  int get totalProducts {
    return _dashboardData?['inventory']?['total_products'] ?? 0;
  }

  // Get low stock count
  int get lowStockCount {
    return _dashboardData?['inventory']?['low_stock'] ?? 0;
  }

  // Get expiring soon count
  int get expiringSoonCount {
    return _dashboardData?['inventory']?['expiring_soon'] ?? 0;
  }

  // Get pending prescriptions
  int get pendingPrescriptions {
    return _dashboardData?['prescriptions']?['pending'] ?? 0;
  }

  // Get recent sales
  List<dynamic> get recentSales {
    return _dashboardData?['recent_activity']?['sales'] ?? [];
  }

  // Get recent prescriptions
  List<dynamic> get recentPrescriptions {
    return _dashboardData?['recent_activity']?['prescriptions'] ?? [];
  }

  // Get top products
  List<dynamic> get topProducts {
    return _dashboardData?['top_products'] ?? [];
  }

  // Refresh dashboard
  Future<void> refreshDashboard() async {
    if (_isDisposed) return;
    await loadDashboard();
    await loadSalesChart();
  }

  // Clear error
  void clearError() {
    if (!_isDisposed) {
      _error = null;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}