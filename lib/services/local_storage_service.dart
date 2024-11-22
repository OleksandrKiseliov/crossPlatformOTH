import 'dart:convert';
import 'dart:html' as html;

class LocalStorageService {
  final String _storageKey = 'users'; // Ключ для збереження користувачів у localStorage

  // Читання даних з localStorage
  Future<List<Map<String, dynamic>>> readUsers() async {
    final storedData = html.window.localStorage[_storageKey];
    if (storedData != null) {
      return List<Map<String, dynamic>>.from(json.decode(storedData));
    }
    return [];
  }

  // Додавання нового користувача в localStorage
  Future<void> addUser(Map<String, dynamic> user) async {
    final users = await readUsers();
    users.add(user);

    // Зберігаємо оновлений список користувачів у localStorage
    html.window.localStorage[_storageKey] = json.encode(users);
  }

  // Ініціалізація (створення порожнього масиву в localStorage, якщо його немає)
  Future<void> initializeStorage() async {
    final users = await readUsers();
    if (users.isEmpty) {
      // Якщо список порожній, зберігаємо порожній масив
      html.window.localStorage[_storageKey] = json.encode([]);
    }
  }

  // Завантаження користувачів у файл JSON
  Future<void> downloadUsersAsJson() async {
    final users = await readUsers();
    final jsonString = json.encode(users);
    
    // Створення Blob об'єкта з даними
    final blob = html.Blob([jsonString]);
    
    // Створення URL для Blob
    final url = html.Url.createObjectUrlFromBlob(blob);

    // Створення елементу для завантаження
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', 'users.json')
      ..click();
    
    // Очищаємо URL після використання
    html.Url.revokeObjectUrl(url);
  }
}
