class MaintenanceTicket {
  final int id;
  final int machineId;
  final String machineName;
  final String title;
  final String description;
  final String status; // pending, in_progress, completed, cancelled
  final String priority; // low, medium, high, urgent
  final int? assignedTo;
  final String? assignedToName;
  final int createdBy;
  final String? createdByName;
  final DateTime createdAt;
  final DateTime? completedAt;

  MaintenanceTicket({
    required this.id,
    required this.machineId,
    required this.machineName,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    this.assignedTo,
    this.assignedToName,
    required this.createdBy,
    this.createdByName,
    required this.createdAt,
    this.completedAt,
  });

  factory MaintenanceTicket.fromJson(Map<String, dynamic> json) {
    return MaintenanceTicket(
      id: json['id'],
      machineId: json['machine_id'],
      machineName: json['machine_name'] ?? 'Unknown',
      title: json['title'],
      description: json['description'],
      status: json['status'],
      priority: json['priority'],
      assignedTo: json['assigned_to'],
      assignedToName: json['assigned_to_name'],
      createdBy: json['created_by'],
      createdByName: json['created_by_name'],
      createdAt: DateTime.parse(json['created_at']),
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'machine_id': machineId,
      'machine_name': machineName,
      'title': title,
      'description': description,
      'status': status,
      'priority': priority,
      'assigned_to': assignedTo,
      'assigned_to_name': assignedToName,
      'created_by': createdBy,
      'created_by_name': createdByName,
      'created_at': createdAt.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
    };
  }

  bool get isPending => status == 'pending';
  bool get isInProgress => status == 'in_progress';
  bool get isCompleted => status == 'completed';
  bool get isUrgent => priority == 'urgent';
}
