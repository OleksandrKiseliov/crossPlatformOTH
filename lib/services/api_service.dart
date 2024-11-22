import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class ApiService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  Future<List<User>> fetchUsers() async {
    final response = await http.get(Uri.parse('$baseUrl/users'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<User> addUser(User user) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users'),
      headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({
        'name': user.name,
        'email': user.email,
        'phone': user.phone,
      }),
    );
    if (response.statusCode == 201) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to add user');
    }
  }

  // Ось новий метод для видалення користувача
  Future<void> deleteUser(int userId) async {
    final response = await http.delete(Uri.parse('$baseUrl/users/$userId'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete user');
    }
  }
}