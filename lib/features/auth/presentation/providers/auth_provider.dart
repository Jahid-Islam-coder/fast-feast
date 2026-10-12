import 'package:flutter/material.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/login_use_case.dart';
import '../../domain/usecases/sign_up_use_case.dart';
import '../../domain/usecases/sign_out_use_case.dart';
import '../../domain/usecases/reset_password_use_case.dart';
import '../../domain/usecases/google_sign_in_use_case.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final LoginUseCase loginUseCase;
  final SignUpUseCase signUpUseCase;
  final SignOutUseCase signOutUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;
  final GoogleSignInUseCase googleSignInUseCase;
  final AuthRepository authRepository;

  UserEntity? _user;
  bool _isLoading = false;

  UserEntity? get user => _user;
  bool get isLoading => _isLoading;

  AuthProvider({
    required this.loginUseCase,
    required this.signUpUseCase,
    required this.signOutUseCase,
    required this.resetPasswordUseCase,
    required this.googleSignInUseCase,
    required this.authRepository,
  }) {
    _user = authRepository.currentUser;
    authRepository.userStream.listen((UserEntity? user) {
      _user = user;
      notifyListeners();
    });
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    _setLoading(true);
    try {
      await loginUseCase(email, password);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> resetPassword(String email) async {
    _setLoading(true);
    try {
      await resetPasswordUseCase(email);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signUp(String email, String password, String name) async {
    _setLoading(true);
    try {
      await signUpUseCase(email, password);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> googleSignIn() async {
    _setLoading(true);
    try {
      await googleSignInUseCase();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    await signOutUseCase();
  }
}
