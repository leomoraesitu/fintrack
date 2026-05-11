import 'package:fintrack/features/auth/domain/entities/auth_user.dart';

abstract class AuthSessionState {
  const AuthSessionState();
}

class AuthSessionUnauthenticated extends AuthSessionState {
  const AuthSessionUnauthenticated();
}

class AuthSessionAuthenticated extends AuthSessionState {
  const AuthSessionAuthenticated({required this.user, this.isDemo = false});

  const AuthSessionAuthenticated.demo() : user = null, isDemo = true;

  final AuthUser? user;
  final bool isDemo;

  String? get userName => user?.userName;

  String? get displayName => user?.displayName;
}
