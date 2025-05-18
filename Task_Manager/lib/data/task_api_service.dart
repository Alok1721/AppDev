import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../model/Task.dart';
import '../services/backendServices.dart';

class TaskApiService {
  String get baseUrl => BackendService.baseUrl + '/tasks';

  Future<List<Task>> fetchTasks() async {
    try {
      final response = await http.get(Uri.parse(baseUrl)).timeout(const Duration(seconds: 10));
      print('GET $baseUrl: ${response.statusCode} ${response.body}'); // Debug
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return data.map((json) => Task.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load tasks: ${response.statusCode}');
      }
    } catch (e) {
      if (e is SocketException) {
        throw Exception('No internet connection');
      } else if (e is TimeoutException) {
        throw Exception('Request timed out');
      }
      throw Exception('Failed to load tasks: $e');
    }
  }

  Future<void> createTask(Task task) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(task.toJson()),
      );
      print('POST $baseUrl: ${response.statusCode} ${response.body}'); // Debug
      if (response.statusCode != 201) {
        throw Exception('Failed to create task: ${response.statusCode}');
      }
    } catch (e) {
      if (e is SocketException) {
        throw Exception('No internet connection');
      } else if (e is TimeoutException) {
        throw Exception('Request timed out');
      }
      throw Exception('Failed to create task: $e');
    }
  }

  Future<void> updateTask(int id, Task task) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(task.toJson()),
      );
      print('PUT $baseUrl/$id: ${response.statusCode} ${response.body}'); // Debug
      if (response.statusCode != 200) {
        throw Exception('Failed to update task: ${response.statusCode}');
      }
    } catch (e) {
      if (e is SocketException) {
        throw Exception('No internet connection');
      } else if (e is TimeoutException) {
        throw Exception('Request timed out');
      }
      throw Exception('Failed to update task: $e');
    }
  }

  Future<void> deleteTask(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));
      print('DELETE $baseUrl/$id: ${response.statusCode} ${response.body}'); // Debug
      if (response.statusCode != 200) {
        throw Exception('Failed to delete task: ${response.statusCode}');
      }
    } catch (e) {
      if (e is SocketException) {
        throw Exception('No internet connection');
      } else if (e is TimeoutException) {
        throw Exception('Request timed out');
      }
      throw Exception('Failed to delete task: $e');
    }
  }
}