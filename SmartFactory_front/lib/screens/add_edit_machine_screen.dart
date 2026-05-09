import 'package:flutter/material.dart';
import '../services/machine_service.dart';
import '../services/auth_service.dart';
import '../models/machine.dart';
import '../models/user.dart';

class AddEditMachineScreen extends StatefulWidget {
  final Machine? machine; // null = ajouter, non-null = modifier

  const AddEditMachineScreen({super.key, this.machine});

  @override
  State<AddEditMachineScreen> createState() => _AddEditMachineScreenState();
}

class _AddEditMachineScreenState extends State<AddEditMachineScreen> {
  final _formKey = GlobalKey<FormState>();
  final _machineService = MachineService();
  final _authService = AuthService();

  late TextEditingController _nameController;
  late String _selectedStatus;
  late TextEditingController _temperatureController;
  late TextEditingController _uptimeController;

  bool _isLoading = false;
  bool _isCheckingAuth = true;
  User? _currentUser;
  bool get _isEditing => widget.machine != null;

  @override
  void initState() {
    super.initState();
    _checkUserRole();
    _nameController = TextEditingController(text: widget.machine?.name ?? '');

    // Normaliser le statut en minuscules et mapper les valeurs
    String rawStatus = (widget.machine?.status ?? 'ok').toLowerCase();
    // Mapper les différentes variantes de statut
    if (rawStatus == 'active' || rawStatus == 'running') {
      _selectedStatus = 'ok';
    } else if (rawStatus == 'failed' ||
        rawStatus == 'error' ||
        rawStatus == 'en_panne') {
      _selectedStatus = 'fail';
    } else if (rawStatus == 'ok' ||
        rawStatus == 'fail' ||
        rawStatus == 'maintenance') {
      _selectedStatus = rawStatus;
    } else {
      _selectedStatus = 'ok'; // Valeur par défaut
    }

    _temperatureController = TextEditingController(
      text: widget.machine?.temperature.toString() ?? '0',
    );
    _uptimeController = TextEditingController(
      text: widget.machine?.uptime.toString() ?? '0',
    );
  }

  Future<void> _checkUserRole() async {
    _currentUser = await _authService.getUser();
    setState(() => _isCheckingAuth = false);

    // Si l'utilisateur n'est pas admin, afficher un message et revenir
    if (_currentUser?.isAdmin != true) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Accès refusé. Seuls les administrateurs peuvent gérer les machines.',
            ),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _temperatureController.dispose();
    _uptimeController.dispose();
    super.dispose();
  }

  Future<void> _saveMachine() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      if (_isEditing) {
        // Modifier
        await _machineService.updateMachine(
          widget.machine!.id,
          status: _selectedStatus,
          temperature: double.tryParse(_temperatureController.text),
          uptime: int.tryParse(_uptimeController.text),
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Machine modifiée avec succès'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true); // true = succès
        }
      } else {
        // Ajouter
        await _machineService.createMachine(
          _nameController.text,
          _selectedStatus,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Machine ajoutée avec succès'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true); // true = succès
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Afficher un loader pendant la vérification du rôle
    if (_isCheckingAuth) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            _isEditing ? 'Modifier la machine' : 'Ajouter une machine',
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Modifier la machine' : 'Ajouter une machine'),
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
                    // Nom
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nom de la machine',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.precision_manufacturing),
                      ),
                      enabled: !_isEditing, // Nom non modifiable en édition
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer un nom';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Statut
                    DropdownButtonFormField<String>(
                      initialValue: _selectedStatus,
                      decoration: const InputDecoration(
                        labelText: 'Statut',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.info),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'ok',
                          child: Text('OK - Actif'),
                        ),
                        DropdownMenuItem(
                          value: 'fail',
                          child: Text('FAIL - En panne'),
                        ),
                        DropdownMenuItem(
                          value: 'maintenance',
                          child: Text('Maintenance'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() => _selectedStatus = value!);
                      },
                    ),
                    const SizedBox(height: 16),

                    // Température
                    TextFormField(
                      controller: _temperatureController,
                      decoration: const InputDecoration(
                        labelText: 'Température (°C)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.thermostat),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          if (double.tryParse(value) == null) {
                            return 'Veuillez entrer un nombre valide';
                          }
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Temps de fonctionnement
                    TextFormField(
                      controller: _uptimeController,
                      decoration: const InputDecoration(
                        labelText: 'Temps de fonctionnement (secondes)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.access_time),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          if (int.tryParse(value) == null) {
                            return 'Veuillez entrer un nombre entier';
                          }
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),

                    // Bouton Enregistrer
                    ElevatedButton.icon(
                      onPressed: _saveMachine,
                      icon: const Icon(Icons.save),
                      label: Text(_isEditing ? 'Modifier' : 'Ajouter'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
