import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../model/Task.dart';

class BackendService {
  static const String baseUrl = 'https://server-9d8j.onrender.com/';

  static Future<List<Task>> getTasks() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/tasks')).timeout(const Duration(seconds: 10));
      print('GET $baseUrl/tasks: ${response.statusCode} ${response.body}'); // Debug
      if (response.statusCode == 200) {
        List data = json.decode(response.body);
        return data.map((item) => Task.fromJson(item)).toList();
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

  static Future<void> createTask(Task task) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/tasks'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(task.toJson()),
      );
      print('POST $baseUrl/tasks: ${response.statusCode} ${response.body}'); // Debug
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

  static Future<void> updateTask(int id, Task task) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/tasks/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(task.toJson()),
      );
      print('PUT $baseUrl/tasks/$id: ${response.statusCode} ${response.body}'); // Debug
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

  static Future<void> deleteTask(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/tasks/$id'));
      print('DELETE $baseUrl/tasks/$id: ${response.statusCode} ${response.body}'); // Debug
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