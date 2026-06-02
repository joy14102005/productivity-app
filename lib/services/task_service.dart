import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/task_model.dart';
import '../utils/constants.dart';

class TaskService {
  FirebaseFirestore? _db;
  TaskService() {
    try {
      if (Firebase.apps.isNotEmpty) _db = FirebaseFirestore.instance;
    } catch (_) {
      _db = null;
    }
  }

  CollectionReference? get _tasks => _db?.collection(Collections.tasks);

  Future<void> addTask(TaskModel task) async {
    if (_tasks != null) {
      await _tasks!.add(task.toMap());
      return;
    }
    final box = Hive.box('focusflow');
    box.put('task_${task.id}', task.toMap());
  }

  Future<void> updateTask(TaskModel task) async {
    if (_tasks != null) {
      await _tasks!.doc(task.id).update(task.toMap());
      return;
    }
    final box = Hive.box('focusflow');
    box.put('task_${task.id}', task.toMap());
  }

  Future<void> deleteTask(String id) async {
    if (_tasks != null) {
      await _tasks!.doc(id).delete();
      return;
    }
    final box = Hive.box('focusflow');
    box.delete('task_$id');
  }

  Stream<List<TaskModel>> streamUserTasks(String userId) {
    if (_tasks != null) {
      return _tasks!.where('userId', isEqualTo: userId).snapshots().map((snap) => snap.docs.map((d) => TaskModel.fromDoc(d)).toList());
    }
    // local hive stream: emit once and whenever box changes
    final box = Hive.box('focusflow');
    return Stream<List<TaskModel>>.periodic(const Duration(seconds: 1), (_) {
      final keys = box.keys.where((k) => k.toString().startsWith('task_'));
      final list = keys.map((k) => TaskModel.fromMap(Map<String, dynamic>.from(box.get(k)))).toList();
      return list;
    }).asBroadcastStream();
  }
}
