import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/auth_services/auth_service.dart';

// handles auth state and operations with firebase
class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;
  bool _isLoading = false;

  // current user or null if logged out
  User? get user => _user;

  bool get isLoading => _isLoading;

  AuthProvider() {
    _authService.userStream.listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // login with email pass
  Future<void> login(String email, String password) async {
    _setLoading(true);
    try {
      await _authService.loginWithEmail(email, password);
    } finally {
      _setLoading(false);
    }
  }

  // send reset email link
  Future<void> resetPassword(String email) async {
    _setLoading(true);
    try {
      await _authService.resetPassword(email);
    } finally {
      _setLoading(false);
    }
  }

  // sign up new user
  Future<void> signUp(String email, String password, String name) async {
    _setLoading(true);
    try {
      final credential = await _authService.signUpWithEmail(email, password);
      if (credential?.user != null) {
        // user account created
      }
    } finally {
      _setLoading(false);
    }
  }

  // google sign in flow
  Future<void> googleSignIn() async {
    _setLoading(true);
    try {
      await _authService.signInWithGoogle();
    } finally {
      _setLoading(false);
    }
  }

  // sign out user
  Future<void> logout() async {
    await _authService.signOut();
  }
}
