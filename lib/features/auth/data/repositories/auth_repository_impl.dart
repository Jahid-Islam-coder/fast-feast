import '../datasources/auth_remote_data_source.dart';
import '../models/user_model.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Stream<UserEntity?> get userStream {
    return remoteDataSource.userStream.map((user) => user == null ? null : UserModel.fromFirebaseUser(user));
  }

  @override
  UserEntity? get currentUser {
    final user = remoteDataSource.currentUser;
    return user == null ? null : UserModel.fromFirebaseUser(user);
  }

  @override
  Future<void> login(String email, String password) async {
    await remoteDataSource.loginWithEmail(email, password);
  }

  @override
  Future<void> signUp(String email, String password) async {
    await remoteDataSource.signUpWithEmail(email, password);
  }

  @override
  Future<void> signOut() async {
    await remoteDataSource.signOut();
  }

  @override
  Future<void> resetPassword(String email) async {
    await remoteDataSource.resetPassword(email);
  }

  @override
  Future<void> signInWithGoogle() async {
    await remoteDataSource.signInWithGoogle();
  }
}
