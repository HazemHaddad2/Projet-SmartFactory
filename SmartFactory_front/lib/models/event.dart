class MachineEvent {
  final int id;
  final int machineId;
  final String status; // OK, FAIL, WARNING
  final String? message;
  final DateTime timestamp;
  final Map<String, dynamic>? metadata;

  MachineEvent({
    required this.id,
    required this.machineId,
    required this.status,
    this.message,
    required this.timestamp,
    this.metadata,
  });

  factory MachineEvent.fromJson(Map<String, dynamic> json) {
    return MachineEvent(
      id: json['id'],
      machineId: json['machine_id'],
      status: json['status'],
      message: json['message'],
      timestamp: DateTime.parse(json['timestamp']),
      metadata: json['metadata'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'machine_id': machineId,
      'status': status,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'metadata': metadata,
    };
  }

  bool get isFail => status == 'FAIL';
  bool get isWarning => status == 'WARNING';
  bool get isOk => status == 'OK';
}
