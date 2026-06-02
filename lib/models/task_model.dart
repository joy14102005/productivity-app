import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  final String id;
  final String userId;
  final String title;
  final String? description;
  final DateTime? dueDate;
  final int priority; // 0 low,1 medium,2 high
  final bool completed;
  final String? category;

  TaskModel({required this.id, required this.userId, required this.title, this.description, this.dueDate, this.priority = 1, this.completed = false, this.category});

  factory TaskModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TaskModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      title: data['title'] ?? '',
      description: data['description'],
      dueDate: data['dueDate'] != null ? (data['dueDate'] as Timestamp).toDate() : null,
      priority: data['priority'] ?? 1,
      completed: data['completed'] ?? false,
      category: data['category'],
    );
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      title: map['title'] ?? '',
      description: map['description'],
      dueDate: map['dueDate'] != null ? DateTime.parse(map['dueDate']) : null,
      priority: map['priority'] ?? 1,
      completed: map['completed'] ?? false,
      category: map['category'],
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'userId': userId,
        'title': title,
        'description': description,
        'dueDate': dueDate != null ? dueDate!.toIso8601String() : null,
        'priority': priority,
        'completed': completed,
        'category': category,
      };
}
