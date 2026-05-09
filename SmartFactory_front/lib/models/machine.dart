class Machine {
  final int id;
  final String name;
  final String status; // ok, fail, maintenance
  final double temperature;
  final int uptime;
  final DateTime? lastMaintenance;
  final DateTime createdAt;
  final DateTime updatedAt;

  Machine({
    required this.id,
    required this.name,
    required this.status,
    required this.temperature,
    required this.uptime,
    this.lastMaintenance,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Machine.fromJson(Map<String, dynamic> json) {
    return Machine(
      id: json['id'],
      name: json['name'],
      status: json['status'],
      temperature: (json['temperature'] ?? 0.0).toDouble(),
      uptime: json['uptime'] ?? 0,
      lastMaintenance: json['last_maintenance'] != null
          ? DateTime.parse(json['last_maintenance'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'temperature': temperature,
      'uptime': uptime,
      'last_maintenance': lastMaintenance?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // Statuts : ok, fail, maintenance
  bool get isActive => status.toLowerCase() == 'ok';
  bool get isFailed => status.toLowerCase() == 'fail';
  bool get isInMaintenance => status.toLowerCase() == 'maintenance';

  String get statusLabel {
    switch (status.toLowerCase()) {
      case 'ok':
        return 'Actif';
      case 'fail':
        return 'En panne';
      case 'maintenance':
        return 'Maintenance';
      default:
        return status;
    }
  }

  String get temperatureLabel => '${temperature.toStringAsFixed(1)}°C';

  String get uptimeLabel {
    final hours = uptime ~/ 3600;
    final minutes = (uptime % 3600) ~/ 60;
    return '${hours}h ${minutes}m';
  }
}
