import 'package:fintrack/features/auth/domain/entities/auth_user.dart';
import 'package:fintrack/features/auth/domain/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth _firebaseAuth;

  const FirebaseAuthRepository(this._firebaseAuth);

  @override
  Stream<AuthUser?> authStateChanges() {
    return _firebaseAuth.authStateChanges().map(_mapUser);
  }

  AuthUser? _mapUser(User? user) {
    if (user == null) return null;

    return AuthUser(
      id: user.uid,
      email: user.email,
      name: user.displayName,
    );
  }

  @override
  Future<AuthUser> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final authUser = _mapUser(userCredential.user);

      if (authUser == null) {
        throw Exception('User not found');
      }

      return authUser;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? e.code);
    }
  }

  @override
  Future<AuthUser> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final authUser = _mapUser(userCredential.user);

      if (authUser == null) {
        throw Exception('User not created');
      }

      return authUser;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? e.code);
    }
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
