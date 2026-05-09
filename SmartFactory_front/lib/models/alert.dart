class Alert {
  final int id;
  final int machineId;
  final String machineName;
  final String severity; // low, medium, high, critical
  final String message;
  final bool isResolved;
  final DateTime createdAt;
  final DateTime? resolvedAt;

  Alert({
    required this.id,
    required this.machineId,
    required this.machineName,
    required this.severity,
    required this.message,
    required this.isResolved,
    required this.createdAt,
    this.resolvedAt,
  });

  factory Alert.fromJson(Map<String, dynamic> json) {
    return Alert(
      id: json['id'],
      machineId: json['machine_id'],
      machineName: json['machine_name'] ?? 'Unknown',
      severity: json['severity'],
      message: json['message'],
      isResolved: json['is_resolved'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
      resolvedAt: json['resolved_at'] != null
          ? DateTime.parse(json['resolved_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'machine_id': machineId,
      'machine_name': machineName,
      'severity': severity,
      'message': message,
      'is_resolved': isResolved,
      'created_at': createdAt.toIso8601String(),
      'resolved_at': resolvedAt?.toIso8601String(),
    };
  }

  bool get isCritical => severity == 'critical';
  bool get isHigh => severity == 'high';
}
