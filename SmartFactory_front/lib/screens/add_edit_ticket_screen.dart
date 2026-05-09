import 'package:flutter/material.dart';
import '../models/maintenance_ticket.dart';
import '../models/machine.dart';
import '../models/user.dart';
import '../services/maintenance_service.dart';
import '../services/machine_service.dart';
import '../services/user_service.dart';

class AddEditTicketScreen extends StatefulWidget {
  final MaintenanceTicket? ticket;

  const AddEditTicketScreen({super.key, this.ticket});

  @override
  State<AddEditTicketScreen> createState() => _AddEditTicketScreenState();
}

class _AddEditTicketScreenState extends State<AddEditTicketScreen> {
  final _formKey = GlobalKey<FormState>();
  final _maintenanceService = MaintenanceService();
  final _machineService = MachineService();
  final _userService = UserService();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  List<Machine> _machines = [];
  List<User> _technicians = [];
  int? _selectedMachineId;
  String _selectedPriority = 'medium';
  int? _selectedTechnicianId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadData();

    if (widget.ticket != null) {
      _titleController.text = widget.ticket!.title;
      _descriptionController.text = widget.ticket!.description;
      _selectedMachineId = widget.ticket!.machineId;
      _selectedPriority = widget.ticket!.priority;
      _selectedTechnicianId = widget.ticket!.assignedTo;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    _machines = await _machineService.getMachines();
    _technicians = await _userService.getTechnicians();
    setState(() {});
  }

  Future<void> _saveTicket() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedMachineId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez sélectionner une machine')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (widget.ticket == null) {
        // Créer un nouveau ticket
        await _maintenanceService.createTicket(
          machineId: _selectedMachineId!,
          title: _titleController.text,
          description: _descriptionController.text,
          priority: _selectedPriority,
          assignedTo: _selectedTechnicianId,
        );
      } else {
        // Mettre à jour le ticket existant
        await _maintenanceService.updateTicket(widget.ticket!.id, {
          'title': _titleController.text,
          'description': _descriptionController.text,
          'priority': _selectedPriority,
          'assigned_to': _selectedTechnicianId,
        });
      }

      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.ticket == null
                  ? 'Ticket créé avec succès'
                  : 'Ticket mis à jour',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erreur: $e')));
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.ticket == null ? 'Nouveau Ticket' : 'Modifier le Ticket',
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Machine
                    DropdownButtonFormField<int>(
                      initialValue: _selectedMachineId,
                      decoration: const InputDecoration(
                        labelText: 'Machine *',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.precision_manufacturing),
                      ),
                      items: _machines.map((machine) {
                        return DropdownMenuItem(
                          value: machine.id,
                          child: Text(machine.name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() => _selectedMachineId = value);
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Veuillez sélectionner une machine';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Titre
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Titre *',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.title),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer un titre';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Description
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description *',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.description),
                        alignLabelWithHint: true,
                      ),
                      maxLines: 5,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer une description';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Priorité
                    const Text(
                      'Priorité *',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        _buildPriorityChip('Basse', 'low', Colors.green),
                        _buildPriorityChip('Moyenne', 'medium', Colors.blue),
                        _buildPriorityChip('Haute', 'high', Colors.orange),
                        _buildPriorityChip('Urgente', 'urgent', Colors.red),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Assigner à
                    DropdownButtonFormField<int>(
                      initialValue: _selectedTechnicianId,
                      decoration: const InputDecoration(
                        labelText: 'Assigner à (optionnel)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                      items: [
                        const DropdownMenuItem(
                          value: null,
                          child: Text('Non assigné'),
                        ),
                        ..._technicians.map((user) {
                          return DropdownMenuItem(
                            value: user.id,
                            child: Text('${user.username} (${user.role})'),
                          );
                        }),
                      ],
                      onChanged: (value) {
                        setState(() => _selectedTechnicianId = value);
                      },
                    ),
                    const SizedBox(height: 24),

                    // Boutons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.all(16),
                            ),
                            child: const Text('Annuler'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _saveTicket,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(16),
                            ),
                            child: Text(
                              widget.ticket == null ? 'Créer' : 'Enregistrer',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildPriorityChip(String label, String value, Color color) {
    final isSelected = _selectedPriority == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() => _selectedPriority = value);
      },
      selectedColor: color.withOpacity(0.3),
      labelStyle: TextStyle(
        color: isSelected ? color : Colors.grey.shade700,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      side: BorderSide(
        color: isSelected ? color : Colors.grey.shade400,
        width: isSelected ? 2 : 1,
      ),
    );
  }
}
