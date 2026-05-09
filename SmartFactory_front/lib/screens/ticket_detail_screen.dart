import 'package:flutter/material.dart';
import '../models/maintenance_ticket.dart';
import '../models/user.dart';
import '../services/maintenance_service.dart';
import '../services/auth_service.dart';
import 'add_edit_ticket_screen.dart';

class TicketDetailScreen extends StatefulWidget {
  final int ticketId;

  const TicketDetailScreen({super.key, required this.ticketId});

  @override
  State<TicketDetailScreen> createState() => _TicketDetailScreenState();
}

class _TicketDetailScreenState extends State<TicketDetailScreen> {
  final _maintenanceService = MaintenanceService();
  final _authService = AuthService();

  MaintenanceTicket? _ticket;
  User? _currentUser;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    _currentUser = await _authService.getUser();
    _ticket = await _maintenanceService.getTicket(widget.ticketId);

    setState(() => _isLoading = false);
  }

  Future<void> _updateStatus(String newStatus) async {
    try {
      await _maintenanceService.updateStatus(widget.ticketId, newStatus);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Statut mis à jour')));
        _loadData();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erreur: $e')));
      }
    }
  }

  Future<void> _deleteTicket() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: const Text('Voulez-vous vraiment supprimer ce ticket ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _maintenanceService.deleteTicket(widget.ticketId);
        if (mounted) {
          Navigator.pop(context, true);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Ticket supprimé')));
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Erreur: $e')));
        }
      }
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'urgent':
        return Colors.red;
      case 'high':
        return Colors.orange;
      case 'medium':
        return Colors.blue;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _getPriorityLabel(String priority) {
    switch (priority.toLowerCase()) {
      case 'urgent':
        return 'URGENT';
      case 'high':
        return 'Haute';
      case 'medium':
        return 'Moyenne';
      case 'low':
        return 'Basse';
      default:
        return priority;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'in_progress':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  String _getStatusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'En attente';
      case 'in_progress':
        return 'En cours';
      case 'completed':
        return 'Terminé';
      case 'cancelled':
        return 'Annulé';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ticket #${widget.ticketId}'),
        actions: [
          if (_currentUser?.isAdmin == true && _ticket != null) ...[
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddEditTicketScreen(ticket: _ticket),
                  ),
                );
                if (result == true) _loadData();
              },
              tooltip: 'Modifier',
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _deleteTicket,
              tooltip: 'Supprimer',
            ),
          ],
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _ticket == null
          ? const Center(child: Text('Ticket non trouvé'))
          : RefreshIndicator(
              onRefresh: _loadData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Priorité et Statut
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoCard(
                            'Priorité',
                            _getPriorityLabel(_ticket!.priority),
                            _getPriorityColor(_ticket!.priority),
                            Icons.flag,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildInfoCard(
                            'Statut',
                            _getStatusLabel(_ticket!.status),
                            _getStatusColor(_ticket!.status),
                            Icons.info,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Titre
                    Text(
                      _ticket!.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Description
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Description',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _ticket!.description,
                              style: const TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Informations
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Informations',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _buildDetailRow(
                              Icons.precision_manufacturing,
                              'Machine',
                              _ticket!.machineName,
                            ),
                            const Divider(),
                            _buildDetailRow(
                              Icons.person,
                              'Assigné à',
                              _ticket!.assignedToName ?? 'Non assigné',
                            ),
                            const Divider(),
                            _buildDetailRow(
                              Icons.person_outline,
                              'Créé par',
                              _ticket!.createdByName ?? 'Inconnu',
                            ),
                            const Divider(),
                            _buildDetailRow(
                              Icons.calendar_today,
                              'Créé le',
                              '${_ticket!.createdAt.day}/${_ticket!.createdAt.month}/${_ticket!.createdAt.year} à ${_ticket!.createdAt.hour}:${_ticket!.createdAt.minute.toString().padLeft(2, '0')}',
                            ),
                            if (_ticket!.completedAt != null) ...[
                              const Divider(),
                              _buildDetailRow(
                                Icons.check_circle,
                                'Terminé le',
                                '${_ticket!.completedAt!.day}/${_ticket!.completedAt!.month}/${_ticket!.completedAt!.year} à ${_ticket!.completedAt!.hour}:${_ticket!.completedAt!.minute.toString().padLeft(2, '0')}',
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Actions
                    if (!_ticket!.isCompleted &&
                        !_ticket!.status.toLowerCase().contains('cancelled'))
                      _buildActionsSection(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildInfoCard(
    String label,
    String value,
    Color color,
    IconData icon,
  ) {
    return Card(
      color: color.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey.shade600),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Actions',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        if (_ticket!.isPending)
          ElevatedButton.icon(
            onPressed: () => _updateStatus('in_progress'),
            icon: const Icon(Icons.play_arrow),
            label: const Text('Commencer l\'intervention'),
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
          ),
        if (_ticket!.isInProgress) ...[
          ElevatedButton.icon(
            onPressed: () => _updateStatus('completed'),
            icon: const Icon(Icons.check_circle),
            label: const Text('Marquer comme terminé'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.all(16),
            ),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () => _updateStatus('cancelled'),
            icon: const Icon(Icons.cancel),
            label: const Text('Annuler le ticket'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              padding: const EdgeInsets.all(16),
            ),
          ),
        ],
      ],
    );
  }
}
