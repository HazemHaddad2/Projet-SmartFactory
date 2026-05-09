import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/machine.dart';
import 'auth_service.dart';

class MachineService {
  final AuthService _authService = AuthService();

  // Récupérer toutes les machines
  Future<List<Machine>> getMachines() async {
    try {
      final headers = await _authService.getAuthHeaders();
      final response = await http.get(
        Uri.parse(ApiConfig.machines),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Machine.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      if (kDebugMode) debugPrint('Error fetching machines: $e');
      return [];
    }
  }

  // Récupérer une machine par ID
  Future<Machine?> getMachineById(int id) async {
    try {
      final headers = await _authService.getAuthHeaders();
      final response = await http.get(
        Uri.parse('${ApiConfig.machines}/$id'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return Machine.fromJson(jsonDecode(response.body));
      }
      return null;
    } catch (e) {
      if (kDebugMode) debugPrint('Error fetching machine: $e');
      return null;
    }
  }

  // Créer une machine
  Future<Machine?> createMachine(String name, String status) async {
    try {
      final headers = await _authService.getAuthHeaders();
      final response = await http.post(
        Uri.parse('${ApiConfig.machines}?name=$name&status=$status'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return Machine.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 403) {
        throw Exception(
          'Accès refusé. Seuls les administrateurs peuvent créer des machines.',
        );
      } else if (response.statusCode == 401) {
        throw Exception('Non authentifié. Veuillez vous reconnecter.');
      }
      throw Exception('Erreur lors de la création de la machine');
    } catch (e) {
      if (kDebugMode) debugPrint('Error creating machine: $e');
      rethrow;
    }
  }

  // Mettre à jour une machine
  Future<Machine?> updateMachine(
    int id, {
    String? status,
    double? temperature,
    int? uptime,
  }) async {
    try {
      final headers = await _authService.getAuthHeaders();

      // Construire les paramètres de query
      final params = <String>[];
      if (status != null) params.add('status=$status');
      if (temperature != null) params.add('temperature=$temperature');
      if (uptime != null) params.add('uptime=$uptime');

      final queryString = params.isNotEmpty ? '?${params.join('&')}' : '';

      final response = await http.patch(
        Uri.parse('${ApiConfig.machines}/$id$queryString'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return Machine.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 403) {
        throw Exception(
          'Accès refusé. Seuls les administrateurs peuvent modifier des machines.',
        );
      } else if (response.statusCode == 401) {
        throw Exception('Non authentifié. Veuillez vous reconnecter.');
      }
      throw Exception('Erreur lors de la modification de la machine');
    } catch (e) {
      if (kDebugMode) debugPrint('Error updating machine: $e');
      rethrow;
    }
  }

  // Supprimer une machine
  Future<bool> deleteMachine(int id) async {
    try {
      final headers = await _authService.getAuthHeaders();
      final response = await http.delete(
        Uri.parse('${ApiConfig.machines}/$id'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 403) {
        throw Exception(
          'Accès refusé. Seuls les administrateurs peuvent supprimer des machines.',
        );
      } else if (response.statusCode == 401) {
        throw Exception('Non authentifié. Veuillez vous reconnecter.');
      }
      throw Exception('Erreur lors de la suppression de la machine');
    } catch (e) {
      if (kDebugMode) debugPrint('Error deleting machine: $e');
      rethrow;
    }
  }

  // Statistiques des machines
  Future<Map<String, int>> getMachineStats() async {
    try {
      final machines = await getMachines();
      return {
        'total': machines.length,
        'active': machines.where((m) => m.isActive).length,
        'failed': machines.where((m) => m.isFailed).length,
        'maintenance': machines.where((m) => m.isInMaintenance).length,
      };
    } catch (e) {
      if (kDebugMode) debugPrint('Error fetching stats: $e');
      return {'total': 0, 'active': 0, 'failed': 0, 'maintenance': 0};
    }
  }
}
