import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AuthService {
  FirebaseAuth? _auth;

  AuthService() {
    try {
      if (Firebase.apps.isNotEmpty) {
        _auth = FirebaseAuth.instance;
      }
    } catch (_) {
      _auth = null;
    }
  }

  Stream<User?> authStateChanges() {
    if (_auth != null) return _auth!.authStateChanges();
    // No Firebase: return a closed stream with null
    return Stream<User?>.value(null);
  }

  Future<User?> signInWithEmail(String email, String password) async {
    if (_auth != null) {
      final cred = await _auth!.signInWithEmailAndPassword(email: email, password: password);
      return cred.user;
    }
    // Local fallback - check Hive
    final box = Hive.box('focusflow');
    final stored = box.get('local_user');
    if (stored != null && stored['email'] == email && stored['password'] == password) {
      // can't create Firebase User; return null but UI should treat as success via local check
      return null;
    }
    throw FirebaseAuthException(code: 'user-not-found', message: 'Local auth failed');
  }

  Future<User?> signUpWithEmail(String email, String password) async {
    if (_auth != null) {
      final cred = await _auth!.createUserWithEmailAndPassword(email: email, password: password);
      return cred.user;
    }
    final box = Hive.box('focusflow');
    box.put('local_user', {'email': email, 'password': password});
    return null;
  }

  Future<void> sendPasswordResetEmail(String email) async {
    if (_auth != null) {
      await _auth!.sendPasswordResetEmail(email: email);
      return;
    }
    throw Exception('Password reset not available in local mode');
  }

  Future<User?> signInWithGoogle() async {
    // Implementing Google Sign-In requires platform configuration and correct google_sign_in usage.
    // To avoid static API mismatches in this environment, this method is intentionally left unimplemented.
    throw UnimplementedError('Google Sign-In requires platform setup and is not implemented in this build');
  }

  Future<void> signOut() async {
    if (_auth != null) {
      await _auth!.signOut();
    }
    // clear local user only if exists
    final box = Hive.box('focusflow');
    if (box.get('local_user') != null) box.delete('local_user');
  }
}
