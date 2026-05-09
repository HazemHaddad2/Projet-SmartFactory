import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import 'auth_service.dart';

class EventService {
  final AuthService _authService = AuthService();

  // Récupérer tous les événements
  Future<List<dynamic>> getEvents({
    int skip = 0,
    int limit = 100,
    int? machineId,
  }) async {
    try {
      final headers = await _authService.getAuthHeaders();

      // Construire les paramètres
      final params = <String>['skip=$skip', 'limit=$limit'];
      if (machineId != null) params.add('machine_id=$machineId');

      final queryString = params.join('&');

      final response = await http.get(
        Uri.parse('${ApiConfig.events}?$queryString'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data;
      }
      return [];
    } catch (e) {
      if (kDebugMode) debugPrint('Error fetching events: $e');
      return [];
    }
  }

  // Récupérer un événement par ID
  Future<Map<String, dynamic>?> getEventById(int id) async {
    try {
      final headers = await _authService.getAuthHeaders();
      final response = await http.get(
        Uri.parse('${ApiConfig.events}/$id'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      if (kDebugMode) debugPrint('Error fetching event: $e');
      return null;
    }
  }

  // Récupérer les événements d'une machine
  Future<List<dynamic>> getMachineEvents(
    int machineId, {
    int limit = 20,
  }) async {
    return getEvents(machineId: machineId, limit: limit);
  }

  // Récupérer les événements récents
  Future<List<dynamic>> getRecentEvents({int limit = 10}) async {
    return getEvents(limit: limit);
  }
}
