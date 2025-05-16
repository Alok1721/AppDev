class Task {
  final int id;
  final String title;
  final String description;
  final bool status;
  final DateTime createdAt;
  final int priority;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.createdAt,
    required this.priority,
  });

  factory Task.fromJson(Map<String, dynamic> json) => Task(
    id: json['id'],
    title: json['title'],
    description: json['description'],
    status: json['status'],
    createdAt: DateTime.parse(json['created_at']),
    priority: json['priority'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'status': status,
    'created_at': createdAt.toIso8601String(),
    'priority': priority,
  };
}
