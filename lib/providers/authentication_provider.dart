import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  AuthProvider() {
    // ฟังการเปลี่ยนแปลงของสถานะล็อกอิน
    _auth.authStateChanges().listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  User? get user => _user;
  bool get isLoggedIn => _user != null;

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
