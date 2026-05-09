import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import 'auth_service.dart';

class DashboardService {
  final AuthService _authService = AuthService();

  // Récupérer l'aperçu du dashboard
  Future<Map<String, dynamic>?> getDashboardOverview() async {
    try {
      final headers = await _authService.getAuthHeaders();
      final response = await http.get(
        Uri.parse('${ApiConfig.dashboard}/overview'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      if (kDebugMode) debugPrint('Error fetching dashboard overview: $e');
      return null;
    }
  }

  // Récupérer le dashboard d'une machine
  Future<Map<String, dynamic>?> getMachineDashboard(int machineId) async {
    try {
      final headers = await _authService.getAuthHeaders();
      final response = await http.get(
        Uri.parse('${ApiConfig.dashboard}/machine/$machineId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      if (kDebugMode) debugPrint('Error fetching machine dashboard: $e');
      return null;
    }
  }
}
