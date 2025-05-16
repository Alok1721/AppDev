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
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String?,
      status: json['status'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      priority: json['priority'] as int,
      targetDateTime: DateTime.parse(json['target_date_time'] as String),
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