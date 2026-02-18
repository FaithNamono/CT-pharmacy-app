import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';
import '../models/user_model.dart';
import '../models/product_model.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // Get auth token from storage
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(StorageKeys.token);
  }

  // Get headers with auth token
  static Future<Map<String, String>> _getHeaders() async {
    final token = await _getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // Handle API response
  static dynamic _handleResponse(http.Response response) {
    final data = jsonDecode(response.body);
    
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data;
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized: Please login again');
    } else if (response.statusCode == 422) {
      throw Exception(data['message'] ?? 'Validation error');
    } else if (response.statusCode == 500) {
      throw Exception('Server error: Please try again later');
    } else {
      throw Exception(data['message'] ?? 'An error occurred');
    }
  }

  // AUTHENTICATION ENDPOINTS
  // ========================

  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.login),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      ).timeout(AppDurations.apiTimeout);

      final data = jsonDecode(response.body);
      
      if (response.statusCode == 200 && data['success'] == true) {
        // Save token
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(StorageKeys.token, data['data']['token']);
        
        return {
          'success': true,
          'user': User.fromJson(data['data']['user']),
          'token': data['data']['token'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Login failed',
        };
      }
    } on http.ClientException catch (e) {
      debugPrint('Network error: $e');
      return {
        'success': false,
        'message': 'Network error: ${e.message}',
      };
    } catch (e) {
      debugPrint('Login error: $e');
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    String role = 'staff',
  }) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.register),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'phone': phone,
          'password': password,
          'password_confirmation': password,
          'role': role,
        }),
      ).timeout(AppDurations.apiTimeout);

      final data = jsonDecode(response.body);
      
      if (response.statusCode == 201 && data['success'] == true) {
        // Save token
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(StorageKeys.token, data['data']['token']);
        
        return {
          'success': true,
          'user': User.fromJson(data['data']['user']),
          'token': data['data']['token'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Registration failed',
        };
      }
    } catch (e) {
      debugPrint('Register error: $e');
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  static Future<Map<String, dynamic>> getProfile() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse(ApiConstants.profile),
        headers: headers,
      ).timeout(AppDurations.apiTimeout);

      final data = jsonDecode(response.body);
      
      if (response.statusCode == 200 && data['success'] == true) {
        return {
          'success': true,
          'user': User.fromJson(data['data']),
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to load profile',
        };
      }
    } catch (e) {
      debugPrint('Get profile error: $e');
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  static Future<void> logout() async {
    try {
      final headers = await _getHeaders();
      await http.post(
        Uri.parse(ApiConstants.logout),
        headers: headers,
      );
    } catch (e) {
      debugPrint('Logout error: $e');
    } finally {
      // Always clear token
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(StorageKeys.token);
      await prefs.remove(StorageKeys.user);
    }
  }

  // PRODUCT ENDPOINTS
  // =================

  static Future<Map<String, dynamic>> getProducts({
    String? search,
    String? category,
    bool? lowStock,
    bool? expiringSoon,
    int page = 1,
  }) async {
    try {
      final headers = await _getHeaders();
      
      // Build query parameters
      final queryParams = <String, String>{};
      if (search != null && search.isNotEmpty) queryParams['search'] = search;
      if (category != null && category.isNotEmpty) queryParams['category'] = category;
      if (lowStock == true) queryParams['low_stock'] = 'true';
      if (expiringSoon == true) queryParams['expiring_soon'] = 'true';
      queryParams['page'] = page.toString();
      
      final uri = Uri.parse(ApiConstants.products).replace(queryParameters: queryParams);
      
      final response = await http.get(
        uri,
        headers: headers,
      ).timeout(AppDurations.apiTimeout);

      final data = jsonDecode(response.body);
      
      if (response.statusCode == 200 && data['success'] == true) {
        final List<Product> products = (data['data']['data'] as List)
            .map((item) => Product.fromJson(item))
            .toList();
        
        return {
          'success': true,
          'products': products,
          'current_page': data['data']['current_page'] ?? 1,
          'last_page': data['data']['last_page'] ?? 1,
          'total': data['data']['total'] ?? 0,
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to load products',
        };
      }
    } catch (e) {
      debugPrint('Get products error: $e');
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  static Future<Map<String, dynamic>> createProduct(Map<String, dynamic> productData) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse(ApiConstants.products),
        headers: headers,
        body: jsonEncode(productData),
      ).timeout(AppDurations.apiTimeout);

      final data = jsonDecode(response.body);
      
      if (response.statusCode == 201 && data['success'] == true) {
        return {
          'success': true,
          'product': Product.fromJson(data['data']),
          'message': data['message'] ?? 'Product created',
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to create product',
          'errors': data['errors'] ?? {},
        };
      }
    } catch (e) {
      debugPrint('Create product error: $e');
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  static Future<Map<String, dynamic>> updateProduct(int id, Map<String, dynamic> productData) async {
    try {
      final headers = await _getHeaders();
      final response = await http.put(
        Uri.parse('${ApiConstants.products}/$id'),
        headers: headers,
        body: jsonEncode(productData),
      ).timeout(AppDurations.apiTimeout);

      final data = jsonDecode(response.body);
      
      if (response.statusCode == 200 && data['success'] == true) {
        return {
          'success': true,
          'product': Product.fromJson(data['data']),
          'message': data['message'] ?? 'Product updated',
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to update product',
        };
      }
    } catch (e) {
      debugPrint('Update product error: $e');
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  static Future<Map<String, dynamic>> deleteProduct(int id) async {
    try {
      final headers = await _getHeaders();
      final response = await http.delete(
        Uri.parse('${ApiConstants.products}/$id'),
        headers: headers,
      ).timeout(AppDurations.apiTimeout);

      final data = jsonDecode(response.body);
      
      if (response.statusCode == 200 && data['success'] == true) {
        return {
          'success': true,
          'message': data['message'] ?? 'Product deleted',
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to delete product',
        };
      }
    } catch (e) {
      debugPrint('Delete product error: $e');
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  static Future<Map<String, dynamic>> getProductStats() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse(ApiConstants.productStats),
        headers: headers,
      ).timeout(AppDurations.apiTimeout);

      final data = jsonDecode(response.body);
      
      if (response.statusCode == 200 && data['success'] == true) {
        return {
          'success': true,
          'stats': data['data'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to load stats',
        };
      }
    } catch (e) {
      debugPrint('Get product stats error: $e');
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  // SALES ENDPOINTS
  // ===============

  static Future<Map<String, dynamic>> createSale(Map<String, dynamic> saleData) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse(ApiConstants.sales),
        headers: headers,
        body: jsonEncode(saleData),
      ).timeout(AppDurations.apiTimeout);

      final data = jsonDecode(response.body);
      
      if (response.statusCode == 201 && data['success'] == true) {
        return {
          'success': true,
          'sale': data['data']['sale'],
          'receipt': data['data']['receipt'],
          'message': data['message'] ?? 'Sale completed',
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to process sale',
        };
      }
    } catch (e) {
      debugPrint('Create sale error: $e');
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  static Future<Map<String, dynamic>> getSales({
    String? fromDate,
    String? toDate,
    String? paymentMethod,
    int page = 1,
  }) async {
    try {
      final headers = await _getHeaders();
      
      final queryParams = <String, String>{};
      if (fromDate != null) queryParams['from_date'] = fromDate;
      if (toDate != null) queryParams['to_date'] = toDate;
      if (paymentMethod != null) queryParams['payment_method'] = paymentMethod;
      queryParams['page'] = page.toString();
      
      final uri = Uri.parse(ApiConstants.sales).replace(queryParameters: queryParams);
      
      final response = await http.get(
        uri,
        headers: headers,
      ).timeout(AppDurations.apiTimeout);

      final data = jsonDecode(response.body);
      
      if (response.statusCode == 200 && data['success'] == true) {
        return {
          'success': true,
          'sales': data['data']['data'],
          'current_page': data['data']['current_page'] ?? 1,
          'last_page': data['data']['last_page'] ?? 1,
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to load sales',
        };
      }
    } catch (e) {
      debugPrint('Get sales error: $e');
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  static Future<Map<String, dynamic>> getSalesSummary() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse(ApiConstants.salesSummary),
        headers: headers,
      ).timeout(AppDurations.apiTimeout);

      final data = jsonDecode(response.body);
      
      if (response.statusCode == 200 && data['success'] == true) {
        return {
          'success': true,
          'summary': data['data'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to load sales summary',
        };
      }
    } catch (e) {
      debugPrint('Get sales summary error: $e');
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  static Future<Map<String, dynamic>> voidSale(int id) async {
    try {
      final headers = await _getHeaders();
      final response = await http.post(
        Uri.parse('${ApiConstants.sales}/$id/void'),
        headers: headers,
      ).timeout(AppDurations.apiTimeout);

      final data = jsonDecode(response.body);
      
      if (response.statusCode == 200 && data['success'] == true) {
        return {
          'success': true,
          'message': data['message'] ?? 'Sale voided',
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to void sale',
        };
      }
    } catch (e) {
      debugPrint('Void sale error: $e');
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  // PRESCRIPTION ENDPOINTS
  // ======================

  static Future<Map<String, dynamic>> uploadPrescription({
    required int customerId,
    required String doctorName,
    required String dateIssued,
    required File image,
    String? notes,
  }) async {
    try {
      final headers = await _getHeaders();
      // Remove content-type for multipart request
      headers.remove('Content-Type');
      
      var request = http.MultipartRequest('POST', Uri.parse(ApiConstants.prescriptions));
      request.headers.addAll(headers);
      
      request.fields['customer_id'] = customerId.toString();
      request.fields['doctor_name'] = doctorName;
      request.fields['date_issued'] = dateIssued;
      if (notes != null) request.fields['notes'] = notes;
      
      request.files.add(await http.MultipartFile.fromPath('image', image.path));
      
      var streamedResponse = await request.send().timeout(AppDurations.apiTimeout);
      var response = await http.Response.fromStream(streamedResponse);
      
      final data = jsonDecode(response.body);
      
      if (response.statusCode == 201 && data['success'] == true) {
        return {
          'success': true,
          'prescription': data['data'],
          'message': data['message'] ?? 'Prescription uploaded',
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to upload prescription',
        };
      }
    } catch (e) {
      debugPrint('Upload prescription error: $e');
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  static Future<Map<String, dynamic>> getPrescriptions({String? status, int page = 1}) async {
    try {
      final headers = await _getHeaders();
      
      final queryParams = <String, String>{};
      if (status != null) queryParams['status'] = status;
      queryParams['page'] = page.toString();
      
      final uri = Uri.parse(ApiConstants.prescriptions).replace(queryParameters: queryParams);
      
      final response = await http.get(
        uri,
        headers: headers,
      ).timeout(AppDurations.apiTimeout);

      final data = jsonDecode(response.body);
      
      if (response.statusCode == 200 && data['success'] == true) {
        return {
          'success': true,
          'prescriptions': data['data']['data'],
          'current_page': data['data']['current_page'] ?? 1,
          'last_page': data['data']['last_page'] ?? 1,
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to load prescriptions',
        };
      }
    } catch (e) {
      debugPrint('Get prescriptions error: $e');
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  static Future<Map<String, dynamic>> updatePrescriptionStatus(int id, String status) async {
    try {
      final headers = await _getHeaders();
      final response = await http.put(
        Uri.parse('${ApiConstants.prescriptions}/$id/status'),
        headers: headers,
        body: jsonEncode({'status': status}),
      ).timeout(AppDurations.apiTimeout);

      final data = jsonDecode(response.body);
      
      if (response.statusCode == 200 && data['success'] == true) {
        return {
          'success': true,
          'prescription': data['data'],
          'message': data['message'] ?? 'Status updated',
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to update status',
        };
      }
    } catch (e) {
      debugPrint('Update prescription error: $e');
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  static Future<Map<String, dynamic>> getPrescriptionSummary() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse(ApiConstants.prescriptionSummary),
        headers: headers,
      ).timeout(AppDurations.apiTimeout);

      final data = jsonDecode(response.body);
      
      if (response.statusCode == 200 && data['success'] == true) {
        return {
          'success': true,
          'summary': data['data'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to load summary',
        };
      }
    } catch (e) {
      debugPrint('Get prescription summary error: $e');
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  // DASHBOARD ENDPOINTS
  // ===================

  static Future<Map<String, dynamic>> getDashboardData() async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse(ApiConstants.dashboard),
        headers: headers,
      ).timeout(AppDurations.apiTimeout);

      final data = jsonDecode(response.body);
      
      if (response.statusCode == 200 && data['success'] == true) {
        return {
          'success': true,
          'dashboard': data['data'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to load dashboard',
        };
      }
    } catch (e) {
      debugPrint('Get dashboard error: $e');
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  static Future<Map<String, dynamic>> getSalesChart(int days) async {
    try {
      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('${ApiConstants.salesChart}?days=$days'),
        headers: headers,
      ).timeout(AppDurations.apiTimeout);

      final data = jsonDecode(response.body);
      
      if (response.statusCode == 200 && data['success'] == true) {
        return {
          'success': true,
          'chart': data['data'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to load chart',
        };
      }
    } catch (e) {
      debugPrint('Get sales chart error: $e');
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }
}