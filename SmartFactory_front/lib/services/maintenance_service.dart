import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/maintenance_ticket.dart';
import 'auth_service.dart';

class MaintenanceService {
  static const String baseUrl = 'http://localhost:8000/maintenance';
  final _authService = AuthService();

  Future<Map<String, String>> _getHeaders() async {
    final token = await _authService.getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // Créer un ticket
  Future<MaintenanceTicket> createTicket({
    required int machineId,
    required String title,
    required String description,
    required String priority,
    int? assignedTo,
  }) async {
    try {
      final user = await _authService.getUser();
      if (user == null) throw Exception('User not authenticated');

      final response = await http.post(
        Uri.parse('$baseUrl/tickets'),
        headers: await _getHeaders(),
        body: jsonEncode({
          'machine_id': machineId,
          'title': title,
          'description': description,
          'priority': priority,
          'assigned_to': assignedTo,
          'created_by': user.id,
        }),
      );

      if (response.statusCode == 201) {
        return MaintenanceTicket.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to create ticket: ${response.body}');
      }
    } catch (e) {
      if (kDebugMode) debugPrint('Error creating ticket: $e');
      rethrow;
    }
  }

  // Récupérer tous les tickets
  Future<List<MaintenanceTicket>> getTickets({
    String? status,
    String? priority,
    int? machineId,
    int? assignedTo,
    int? createdBy,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (status != null) queryParams['status'] = status;
      if (priority != null) queryParams['priority'] = priority;
      if (machineId != null) queryParams['machine_id'] = machineId.toString();
      if (assignedTo != null) {
        queryParams['assigned_to'] = assignedTo.toString();
      }
      if (createdBy != null) queryParams['created_by'] = createdBy.toString();

      final uri = Uri.parse(
        '$baseUrl/tickets',
      ).replace(queryParameters: queryParams);
      final response = await http.get(uri, headers: await _getHeaders());

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => MaintenanceTicket.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load tickets');
      }
    } catch (e) {
      if (kDebugMode) debugPrint('Error fetching tickets: $e');
      return [];
    }
  }

  // Récupérer un ticket spécifique
  Future<MaintenanceTicket?> getTicket(int ticketId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/tickets/$ticketId'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        return MaintenanceTicket.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load ticket');
      }
    } catch (e) {
      if (kDebugMode) debugPrint('Error fetching ticket: $e');
      return null;
    }
  }

  // Mettre à jour un ticket
  Future<MaintenanceTicket> updateTicket(
    int ticketId,
    Map<String, dynamic> updates,
  ) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/tickets/$ticketId'),
        headers: await _getHeaders(),
        body: jsonEncode(updates),
      );

      if (response.statusCode == 200) {
        return MaintenanceTicket.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to update ticket');
      }
    } catch (e) {
      if (kDebugMode) debugPrint('Error updating ticket: $e');
      rethrow;
    }
  }

  // Mettre à jour le statut
  Future<MaintenanceTicket> updateStatus(int ticketId, String status) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/tickets/$ticketId/status'),
        headers: await _getHeaders(),
        body: jsonEncode({'status': status}),
      );

      if (response.statusCode == 200) {
        return MaintenanceTicket.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to update status');
      }
    } catch (e) {
      if (kDebugMode) debugPrint('Error updating status: $e');
      rethrow;
    }
  }

  // Assigner un ticket
  Future<MaintenanceTicket> assignTicket(int ticketId, int userId) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/tickets/$ticketId/assign'),
        headers: await _getHeaders(),
        body: jsonEncode({'assigned_to': userId}),
      );

      if (response.statusCode == 200) {
        return MaintenanceTicket.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to assign ticket');
      }
    } catch (e) {
      if (kDebugMode) debugPrint('Error assigning ticket: $e');
      rethrow;
    }
  }

  // Supprimer un ticket
  Future<void> deleteTicket(int ticketId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/tickets/$ticketId'),
        headers: await _getHeaders(),
      );

      if (response.statusCode != 204) {
        throw Exception('Failed to delete ticket');
      }
    } catch (e) {
      if (kDebugMode) debugPrint('Error deleting ticket: $e');
      rethrow;
    }
  }

  // Récupérer les tickets d'une machine
  Future<List<MaintenanceTicket>> getTicketsByMachine(int machineId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/tickets/machine/$machineId'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => MaintenanceTicket.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load machine tickets');
      }
    } catch (e) {
      if (kDebugMode) debugPrint('Error fetching machine tickets: $e');
      return [];
    }
  }

  // Récupérer les tickets d'un utilisateur
  Future<List<MaintenanceTicket>> getTicketsByUser(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/tickets/user/$userId'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => MaintenanceTicket.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load user tickets');
      }
    } catch (e) {
      if (kDebugMode) debugPrint('Error fetching user tickets: $e');
      return [];
    }
  }

  // Récupérer les statistiques
  Future<Map<String, dynamic>> getStats() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/tickets/stats'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load stats');
      }
    } catch (e) {
      if (kDebugMode) debugPrint('Error fetching stats: $e');
      return {
        'total': 0,
        'pending': 0,
        'in_progress': 0,
        'completed': 0,
        'cancelled': 0,
        'by_priority': {},
      };
    }
  }
}
