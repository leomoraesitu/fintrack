import 'package:fintrack/features/auth/domain/entities/auth_user.dart';

abstract class AuthSessionEvent {
  const AuthSessionEvent();
}

class AuthSessionEnteredDemo extends AuthSessionEvent {
  const AuthSessionEnteredDemo();
}

class AuthSessionLoggedOut extends AuthSessionEvent {
  const AuthSessionLoggedOut();
}

class AuthSessionStarted extends AuthSessionEvent {
  const AuthSessionStarted();
}

class AuthSessionUserChanged extends AuthSessionEvent {
  final AuthUser? user;

  const AuthSessionUserChanged(this.user);
}
