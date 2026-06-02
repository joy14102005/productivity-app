import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../utils/constants.dart';

class AnalyticsService {
  FirebaseFirestore? _db;
  AnalyticsService() {
    try {
      if (Firebase.apps.isNotEmpty) _db = FirebaseFirestore.instance;
    } catch (_) {
      _db = null;
    }
  }

  CollectionReference? get _analytics => _db?.collection(Collections.analytics);

  Future<void> logSession(Map<String, dynamic> session) async {
    if (_analytics != null) {
      await _analytics!.add(session);
      return;
    }
    final box = Hive.box('focusflow');
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    box.put('session_$id', session);
  }
}
