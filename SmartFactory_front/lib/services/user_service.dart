import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import 'auth_service.dart';

class UserService {
  static const String baseUrl = 'http://localhost:8000';
  final _authService = AuthService();

  Future<Map<String, String>> _getHeaders() async {
    final token = await _authService.getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // Récupérer tous les utilisateurs
  Future<List<User>> getUsers() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => User.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      if (kDebugMode) debugPrint('Error fetching users: $e');
      return [];
    }
  }

  // Récupérer les techniciens uniquement
  Future<List<User>> getTechnicians() async {
    try {
      final users = await getUsers();
      return users
          .where(
            (user) =>
                user.role.toLowerCase() == 'technicien' ||
                user.role.toLowerCase() == 'admin',
          )
          .toList();
    } catch (e) {
      if (kDebugMode) debugPrint('Error fetching technicians: $e');
      return [];
    }
  }

  // Récupérer un utilisateur spécifique
  Future<User?> getUser(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users/$userId'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        return User.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load user');
      }
    } catch (e) {
      if (kDebugMode) debugPrint('Error fetching user: $e');
      return null;
    }
  }
}
