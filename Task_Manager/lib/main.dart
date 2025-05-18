import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/todos'));
      print("Data: ${response.body}");
    } catch (e) {
      print("error:$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    fetchData(); // Just to test
    return MaterialApp(
      home: Scaffold(
        body: Center(child: Text('Testing API')),
      ),
    );
  }
}
