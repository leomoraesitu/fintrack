abstract class AuthSessionEvent {
  const AuthSessionEvent();
}

class AuthSessionEnteredDemo extends AuthSessionEvent {
  const AuthSessionEnteredDemo();
}

class AuthSessionLoggedOut extends AuthSessionEvent {
  const AuthSessionLoggedOut();
}
