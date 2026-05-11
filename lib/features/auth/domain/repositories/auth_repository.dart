import 'package:fintrack/features/auth/domain/entities/auth_user.dart';

abstract class AuthRepository {
  Stream<AuthUser?> authStateChanges();

  Future<AuthUser> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<AuthUser> createUserWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<void> signOut();
}
