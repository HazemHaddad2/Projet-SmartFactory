import 'package:flutter/material.dart';
import '../models/maintenance_ticket.dart';
import '../services/maintenance_service.dart';
import 'add_edit_ticket_screen.dart';
import 'ticket_detail_screen.dart';

class MaintenanceTicketsScreen extends StatefulWidget {
  const MaintenanceTicketsScreen({super.key});

  @override
  State<MaintenanceTicketsScreen> createState() =>
      _MaintenanceTicketsScreenState();
}

class _MaintenanceTicketsScreenState extends State<MaintenanceTicketsScreen>
    with SingleTickerProviderStateMixin {
  final _maintenanceService = MaintenanceService();
  late AnimationController _animationController;

  List<MaintenanceTicket> _tickets = [];
  List<MaintenanceTicket> _filteredTickets = [];
  bool _isLoading = true;
  String _filter = 'all';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _loadData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    _tickets = await _maintenanceService.getTickets();
    _applyFilter();
    setState(() => _isLoading = false);
    _animationController.forward(from: 0);
  }

  void _applyFilter() {
    switch (_filter) {
      case 'pending':
        _filteredTickets = _tickets.where((t) => t.isPending).toList();
        break;
      case 'in_progress':
        _filteredTickets = _tickets.where((t) => t.isInProgress).toList();
        break;
      case 'completed':
        _filteredTickets = _tickets.where((t) => t.isCompleted).toList();
        break;
      default:
        _filteredTickets = _tickets;
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'urgent':
        return const Color(0xFFD32F2F);
      case 'high':
        return const Color(0xFFF57C00);
      case 'medium':
        return const Color(0xFF1976D2);
      case 'low':
        return const Color(0xFF388E3C);
      default:
        return Colors.grey;
    }
  }

  IconData _getPriorityIcon(String priority) {
    switch (priority.toLowerCase()) {
      case 'urgent':
        return Icons.warning_rounded;
      case 'high':
        return Icons.arrow_upward_rounded;
      case 'medium':
        return Icons.remove_rounded;
      case 'low':
        return Icons.arrow_downward_rounded;
      default:
        return Icons.help_outline_rounded;
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
        return const Color(0xFFF57C00);
      case 'in_progress':
        return const Color(0xFF1976D2);
      case 'completed':
        return const Color(0xFF388E3C);
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
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Tickets de Maintenance'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _loadData,
            tooltip: 'Actualiser',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Filtres avec design amélioré
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        _buildFilterChip('Tous', 'all', Icons.list_rounded),
                        const SizedBox(width: 12),
                        _buildFilterChip(
                          'En attente',
                          'pending',
                          Icons.schedule_rounded,
                        ),
                        const SizedBox(width: 12),
                        _buildFilterChip(
                          'En cours',
                          'in_progress',
                          Icons.engineering_rounded,
                        ),
                        const SizedBox(width: 12),
                        _buildFilterChip(
                          'Terminés',
                          'completed',
                          Icons.check_circle_rounded,
                        ),
                      ],
                    ),
                  ),
                ),

                // Liste des tickets
                Expanded(
                  child: _filteredTickets.isEmpty
                      ? _buildEmptyState()
                      : RefreshIndicator(
                          onRefresh: _loadData,
                          child: ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: _filteredTickets.length,
                            itemBuilder: (context, index) {
                              return AnimatedBuilder(
                                animation: _animationController,
                                builder: (context, child) {
                                  final delay = index * 0.1;
                                  final animValue = Curves.easeOut.transform(
                                    (_animationController.value - delay).clamp(
                                      0.0,
                                      1.0,
                                    ),
                                  );
                                  return Transform.translate(
                                    offset: Offset(0, 50 * (1 - animValue)),
                                    child: Opacity(
                                      opacity: animValue,
                                      child: child,
                                    ),
                                  );
                                },
                                child: _buildTicketCard(
                                  _filteredTickets[index],
                                ),
                              );
                            },
                          ),
                        ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddEditTicketScreen()),
          );
          if (result == true) _loadData();
        },
        icon: const Icon(Icons.add_rounded),
        label: const Text('Nouveau ticket'),
        elevation: 4,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.assignment_outlined,
              size: 64,
              color: Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Aucun ticket',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Créez votre premier ticket de maintenance',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value, IconData icon) {
    final isSelected = _filter == value;
    return Material(
      color: isSelected ? const Color(0xFF1976D2) : Colors.white,
      borderRadius: BorderRadius.circular(24),
      elevation: isSelected ? 4 : 0,
      shadowColor: const Color(0xFF1976D2).withValues(alpha: 0.3),
      child: InkWell(
        onTap: () {
          setState(() {
            _filter = value;
            _applyFilter();
          });
        },
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF1976D2)
                  : Colors.grey.shade300,
              width: isSelected ? 0 : 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected ? Colors.white : Colors.grey.shade700,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey.shade700,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTicketCard(MaintenanceTicket ticket) {
    final priorityColor = _getPriorityColor(ticket.priority);
    final statusColor = _getStatusColor(ticket.status);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () async {
          final result = await Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  TicketDetailScreen(ticketId: ticket.id),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position:
                            Tween<Offset>(
                              begin: const Offset(0.1, 0),
                              end: Offset.zero,
                            ).animate(
                              CurvedAnimation(
                                parent: animation,
                                curve: Curves.easeOut,
                              ),
                            ),
                        child: child,
                      ),
                    );
                  },
            ),
          );
          if (result == true) _loadData();
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, priorityColor.withValues(alpha: 0.02)],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // En-tête
                Row(
                  children: [
                    // Badge priorité
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            priorityColor,
                            priorityColor.withValues(alpha: 0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: priorityColor.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _getPriorityIcon(ticket.priority),
                            size: 16,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _getPriorityLabel(ticket.priority),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Badge statut
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: statusColor.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        _getStatusLabel(ticket.status),
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const Spacer(),
                    // ID
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '#${ticket.id}',
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Titre
                Text(
                  ticket.title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),

                // Informations
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      _buildInfoRow(
                        Icons.precision_manufacturing_rounded,
                        ticket.machineName,
                        Colors.grey.shade800,
                      ),
                      const SizedBox(height: 8),
                      _buildInfoRow(
                        Icons.person_rounded,
                        ticket.assignedToName ?? 'Non assigné',
                        ticket.assignedToName != null
                            ? Colors.grey.shade800
                            : const Color(0xFFF57C00),
                      ),
                      const SizedBox(height: 8),
                      _buildInfoRow(
                        Icons.access_time_rounded,
                        '${ticket.createdAt.day}/${ticket.createdAt.month}/${ticket.createdAt.year} ${ticket.createdAt.hour}:${ticket.createdAt.minute.toString().padLeft(2, '0')}',
                        Colors.grey.shade700,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, Color textColor) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade600),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
