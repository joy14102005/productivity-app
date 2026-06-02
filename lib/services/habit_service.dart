import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../utils/constants.dart';
import '../models/habit_model.dart';

class HabitService {
  FirebaseFirestore? _db;
  HabitService() {
    try {
      if (Firebase.apps.isNotEmpty) _db = FirebaseFirestore.instance;
    } catch (_) {
      _db = null;
    }
  }

  CollectionReference? get _habits => _db?.collection(Collections.habits);

  Future<void> addHabit(HabitModel habit) async {
    if (_habits != null) {
      await _habits!.add(habit.toMap());
      return;
    }
    final box = Hive.box('focusflow');
    box.put('habit_${habit.id}', habit.toMap());
  }

  Future<void> updateHabit(HabitModel habit) async {
    if (_habits != null) {
      await _habits!.doc(habit.id).update(habit.toMap());
      return;
    }
    final box = Hive.box('focusflow');
    box.put('habit_${habit.id}', habit.toMap());
  }

  Future<void> deleteHabit(String id) async {
    if (_habits != null) {
      await _habits!.doc(id).delete();
      return;
    }
    final box = Hive.box('focusflow');
    box.delete('habit_$id');
  }

  Stream<List<HabitModel>> streamUserHabits(String userId) {
    if (_habits != null) {
      return _habits!.where('userId', isEqualTo: userId).snapshots().map((snap) => snap.docs.map((d) => HabitModel.fromMap(d.data() as Map<String, dynamic>)).toList());
    }
    final box = Hive.box('focusflow');
    return Stream<List<HabitModel>>.periodic(const Duration(seconds: 1), (_) {
      final keys = box.keys.where((k) => k.toString().startsWith('habit_'));
      final list = keys.map((k) => HabitModel.fromMap(Map<String, dynamic>.from(box.get(k)))).toList();
      return list;
    }).asBroadcastStream();
  }
}
