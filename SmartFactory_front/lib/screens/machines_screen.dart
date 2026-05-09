import 'package:flutter/material.dart';
import '../models/machine.dart';
import '../models/user.dart';
import '../services/machine_service.dart';
import '../services/auth_service.dart';
import 'add_edit_machine_screen.dart';
import 'machine_history_screen.dart';

class MachinesScreen extends StatefulWidget {
  const MachinesScreen({super.key});

  @override
  State<MachinesScreen> createState() => _MachinesScreenState();
}

class _MachinesScreenState extends State<MachinesScreen> {
  final _machineService = MachineService();
  final _authService = AuthService();
  List<Machine> _machines = [];
  bool _isLoading = true;
  String _filter = 'all'; // all, active, failed, maintenance
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _loadUserAndMachines();
  }

  Future<void> _loadUserAndMachines() async {
    _currentUser = await _authService.getUser();
    setState(() {}); // mettre à jour l'UI avec le bon utilisateur
    await _loadMachines();
  }

  Future<void> _loadMachines() async {
    setState(() => _isLoading = true);
    _machines = await _machineService.getMachines();
    setState(() => _isLoading = false);
  }

  List<Machine> get _filteredMachines {
    switch (_filter) {
      case 'active':
        return _machines.where((m) => m.isActive).toList();
      case 'failed':
        return _machines.where((m) => m.isFailed).toList();
      case 'maintenance':
        return _machines.where((m) => m.isInMaintenance).toList();
      default:
        return _machines;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'active':
        return Colors.green;
      case 'en_panne':
        return Colors.red;
      case 'maintenance':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'active':
        return 'Active';
      case 'en_panne':
        return 'En panne';
      case 'maintenance':
        return 'Maintenance';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Machines'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadMachines),
        ],
      ),
      body: Column(
        children: [
          // Filtres
          Container(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('Toutes', 'all'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Actives', 'active'),
                  const SizedBox(width: 8),
                  _buildFilterChip('En panne', 'failed'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Maintenance', 'maintenance'),
                ],
              ),
            ),
          ),

          // Liste des machines
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredMachines.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inbox,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Aucune machine trouvée',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _loadMachines,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _filteredMachines.length,
                      itemBuilder: (context, index) {
                        final machine = _filteredMachines[index];
                        return _buildMachineCard(machine, _currentUser);
                      },
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: _currentUser?.isAdmin == true
          ? FloatingActionButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AddEditMachineScreen(),
                  ),
                );
                if (result == true) {
                  _loadMachines(); // Recharger la liste
                }
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _filter == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _filter = value;
        });
      },
      selectedColor: Colors.blue.shade100,
      checkmarkColor: Colors.blue.shade700,
    );
  }

  Widget _buildMachineCard(Machine machine, User? currentUser) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          _showMachineDetails(machine, currentUser);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Icône
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _getStatusColor(
                        machine.status,
                      ).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.precision_manufacturing,
                      color: _getStatusColor(machine.status),
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Infos
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          machine.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          machine.statusLabel,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Status badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(machine.status),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _getStatusLabel(machine.status),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.thermostat, size: 16, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Text(
                    machine.temperatureLabel,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    machine.uptimeLabel,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMachineDetails(Machine machine, User? currentUser) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.75,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Poignée de drag
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // En-tête avec nom et statut
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          machine.name,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(machine.status),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _getStatusLabel(machine.status),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  const Divider(height: 1),
                  const SizedBox(height: 16),

                  // Informations en grille compacte
                  Row(
                    children: [
                      Expanded(
                        child: _buildCompactInfo(
                          'ID',
                          '#${machine.id}',
                          Icons.tag,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildCompactInfo(
                          'Température',
                          machine.temperatureLabel,
                          Icons.thermostat,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildCompactInfo(
                          'Temps actif',
                          machine.uptimeLabel,
                          Icons.access_time,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildCompactInfo(
                          'Créée le',
                          '${machine.createdAt.day}/${machine.createdAt.month}/${machine.createdAt.year}',
                          Icons.calendar_today,
                        ),
                      ),
                    ],
                  ),
                  if (machine.lastMaintenance != null) ...[
                    const SizedBox(height: 12),
                    _buildCompactInfo(
                      'Dernière maintenance',
                      '${machine.lastMaintenance!.day}/${machine.lastMaintenance!.month}/${machine.lastMaintenance!.year}',
                      Icons.build,
                    ),
                  ],

                  const SizedBox(height: 20),

                  // Boutons d'action
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    MachineHistoryScreen(machine: machine),
                              ),
                            );
                          },
                          icon: const Icon(Icons.history, size: 20),
                          label: const Text('Historique'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      if (currentUser?.isAdmin == true) ...[
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              Navigator.pop(context);
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      AddEditMachineScreen(machine: machine),
                                ),
                              );
                              if (result == true) {
                                _loadMachines();
                              }
                            },
                            icon: const Icon(Icons.edit, size: 20),
                            label: const Text('Modifier'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),

                  if (currentUser?.isAdmin == true) ...[
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => _confirmDeleteMachine(machine),
                        icon: const Icon(Icons.delete, size: 20),
                        label: const Text('Supprimer'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCompactInfo(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: Colors.grey.shade600),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDeleteMachine(Machine machine) async {
    Navigator.pop(context); // Fermer le bottom sheet

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: Text(
          'Êtes-vous sûr de vouloir supprimer la machine "${machine.name}" ?\n\nCette action est irréversible.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        final success = await _machineService.deleteMachine(machine.id);
        if (success && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Machine supprimée avec succès'),
              backgroundColor: Colors.green,
            ),
          );
          _loadMachines();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString().replaceAll('Exception: ', '')),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}
