import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../backendProperties.dart';
import '../../models/products.dart';

class DashboardRepo {
  Future<DashboardResponse> fetchDashboardData() async {
    try {
      final response = await http.get(
        Uri.parse(BackendProperties.dashboard),
        headers: {'Content-Type': 'application/json'},
      );
      debugPrint('Dashboard API response: ${response.statusCode} ${response.body}');
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['data'] != null) {
          return DashboardResponse.fromJson(jsonData['data']);
        } else {
          throw Exception('No data field in response');
        }
      } else {
        throw Exception('Failed to fetch dashboard data: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('DashboardRepo error: $e');
      throw Exception('Error fetching dashboard data: $e');
    }
  }
}