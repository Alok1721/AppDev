import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../backendProperties.dart';
import '../../models/products.dart';

class DashboardRepo {
  Future<DashboardResponse> fetchDashboardData() async {
    try {
      final response = await http.get(Uri.parse(BackendProperties.dashboard));
      if (response.statusCode == 200) {
        return DashboardResponse.fromJson(jsonDecode(response.body)['data']);
      } else {
        throw Exception('Failed to fetch dashboard data: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching dashboard data: $e');
    }
  }
}