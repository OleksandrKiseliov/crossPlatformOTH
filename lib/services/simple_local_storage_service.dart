import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import '../models/user.dart';

class SimpleLocalStorageService {
  static const String _localFileName = 'users.json';

  // Отримання файлу
  Future<File> _getLocalFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$_localFileName');
  }

  // Додавання користувача до JSON-файлу
  Future<void> addUser(User user) async {
    try {
      final file = await _getLocalFile();

      // Читання існуючих даних
      List<dynamic> users = [];
      if (await file.exists()) {
        final content = await file.readAsString();
        if (content.isNotEmpty) {
          users = json.decode(content);
        }
      }

      // Додаємо нового користувача
      users.add(user.toJson());

      // Зберігаємо дані
      await file.writeAsString(json.encode(users), flush: true);
      if (kDebugMode) {
        print('Користувач успішно збережений: ${file.path}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Помилка при збереженні: $e');
      }
      throw Exception('Не вдалося зберегти користувача');
    }
  }

  // Завантаження всіх користувачів
  Future<List<User>> loadUsers() async {
    try {
      final file = await _getLocalFile();
      if (await file.exists()) {
        final content = await file.readAsString();
        if (content.isNotEmpty) {
          final List<dynamic> usersJson = json.decode(content);
          return usersJson.map((json) => User.fromJson(json)).toList();
        }
      }
      return [];
    } catch (e) {
      if (kDebugMode) {
        print('Помилка при завантаженні користувачів: $e');
      }
      throw Exception('Не вдалося завантажити користувачів');
    }
  }
}
