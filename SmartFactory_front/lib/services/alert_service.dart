import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import 'auth_service.dart';

class AlertService {
  final AuthService _authService = AuthService();

  // Récupérer toutes les alertes
  Future<List<dynamic>> getAlerts({
    int skip = 0,
    int limit = 100,
    String? status,
    int? machineId,
  }) async {
    try {
      final headers = await _authService.getAuthHeaders();

      // Construire les paramètres
      final params = <String>['skip=$skip', 'limit=$limit'];
      if (status != null) params.add('status=$status');
      if (machineId != null) params.add('machine_id=$machineId');

      final queryString = params.join('&');

      final response = await http.get(
        Uri.parse('${ApiConfig.alerts}?$queryString'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data;
      }
      return [];
    } catch (e) {
      if (kDebugMode) debugPrint('Error fetching alerts: $e');
      return [];
    }
  }

  // Récupérer une alerte par ID
  Future<Map<String, dynamic>?> getAlertById(int id) async {
    try {
      final headers = await _authService.getAuthHeaders();
      final response = await http.get(
        Uri.parse('${ApiConfig.alerts}/$id'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      if (kDebugMode) debugPrint('Error fetching alert: $e');
      return null;
    }
  }

  // Mettre à jour le statut d'une alerte
  Future<Map<String, dynamic>?> updateAlertStatus(int id, String status) async {
    try {
      final headers = await _authService.getAuthHeaders();
      final response = await http.patch(
        Uri.parse('${ApiConfig.alerts}/$id?status=$status'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      if (kDebugMode) debugPrint('Error updating alert: $e');
      return null;
    }
  }

  // Récupérer les statistiques des alertes
  Future<Map<String, dynamic>?> getAlertStats() async {
    try {
      final headers = await _authService.getAuthHeaders();
      final response = await http.get(
        Uri.parse('${ApiConfig.alerts}/stats/summary'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      if (kDebugMode) debugPrint('Error fetching alert stats: $e');
      return null;
    }
  }

  // Récupérer les alertes actives
  Future<List<dynamic>> getActiveAlerts() async {
    return getAlerts(status: 'active');
  }

  // Récupérer les alertes critiques
  Future<List<dynamic>> getCriticalAlerts() async {
    try {
      final alerts = await getAlerts();
      return alerts.where((alert) => alert['severity'] == 'critical').toList();
    } catch (e) {
      if (kDebugMode) debugPrint('Error fetching critical alerts: $e');
      return [];
    }
  }
}
