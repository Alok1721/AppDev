class Task {
  final int id;
  final String title;
  final String? description;
  final bool status;
  final DateTime createdAt;
  final int priority;
  final DateTime targetDateTime;

  Task({
    required this.id,
    required this.title,
    this.description,
    required this.status,
    required this.createdAt,
    required this.priority,
    required this.targetDateTime,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString(),
      status: json['status'] is bool ? json['status'] : false,
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ?? DateTime.now(),
      priority: json['priority'] is int ? json['priority'] : int.tryParse(json['priority']?.toString() ?? '0') ?? 0,
      targetDateTime: DateTime.tryParse(json['target_date_time']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'priority': priority,
      'target_date_time': targetDateTime.toIso8601String(),
    };
  }
}