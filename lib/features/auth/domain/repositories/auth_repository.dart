import '../entities/user_entity.dart';

abstract class AuthRepository {
  Stream<UserEntity?> get userStream;
  UserEntity? get currentUser;
  Future<void> login(String email, String password);
  Future<void> signUp(String email, String password);
  Future<void> signOut();
  Future<void> resetPassword(String email);
  Future<void> signInWithGoogle();
}
