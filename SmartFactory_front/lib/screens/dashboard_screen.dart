import 'package:flutter/material.dart';
import '../services/machine_service.dart';
import '../services/auth_service.dart';
import '../models/user.dart';
import 'machines_screen.dart';
import 'alerts_screen.dart';
import 'users_management_screen.dart';
import 'maintenance_tickets_screen.dart';
import 'login_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _machineService = MachineService();
  final _authService = AuthService();

  User? _currentUser;
  Map<String, int> _stats = {
    'total': 0,
    'active': 0,
    'failed': 0,
    'maintenance': 0,
  };
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    _currentUser = await _authService.getUser();
    _stats = await _machineService.getMachineStats();

    setState(() => _isLoading = false);
  }

  Future<void> _logout() async {
    await _authService.logout();
    if (mounted) {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SmartFactory Dashboard'),
        actions: [
          if (_currentUser != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Center(
                child: Chip(
                  avatar: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Text(
                      _currentUser!.username[0].toUpperCase(),
                      style: TextStyle(color: Colors.blue.shade700),
                    ),
                  ),
                  label: Text(_currentUser!.username),
                ),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Déconnexion',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Bienvenue
                    Text(
                      'Bienvenue, ${_currentUser?.username ?? "Utilisateur"}!',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Rôle: ${_currentUser?.role ?? "N/A"}',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Statistiques
                    Text(
                      'Vue d\'ensemble',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Cartes de statistiques en ligne - largeur égale
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            'Total Machines',
                            _stats['total'].toString(),
                            Icons.precision_manufacturing,
                            const Color(0xFF1976D2),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            'Actives',
                            _stats['active'].toString(),
                            Icons.check_circle,
                            const Color(0xFF388E3C),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            'En Panne',
                            _stats['failed'].toString(),
                            Icons.error,
                            const Color(0xFFD32F2F),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            'Maintenance',
                            _stats['maintenance'].toString(),
                            Icons.build,
                            const Color(0xFFF57C00),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Actions rapides
                    Text(
                      'Actions rapides',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    _buildActionButton(
                      'Voir toutes les machines',
                      Icons.list,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const MachinesScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildActionButton('Alertes actives', Icons.warning, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AlertsScreen()),
                      );
                    }),

                    // Gestion des utilisateurs (Admin uniquement)
                    if (_currentUser?.isAdmin == true) ...[
                      const SizedBox(height: 12),
                      _buildActionButton(
                        'Gestion des utilisateurs',
                        Icons.people,
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const UsersManagementScreen(),
                            ),
                          );
                        },
                        color: Colors.blue,
                      ),
                    ],

                    const SizedBox(height: 12),
                    _buildActionButton(
                      'Tickets de maintenance',
                      Icons.assignment,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const MaintenanceTicketsScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color, color.withValues(alpha: 0.8)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: Colors.white),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    String title,
    IconData icon,
    VoidCallback onTap, {
    Color? color,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: color ?? Colors.blue.shade700),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
