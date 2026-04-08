abstract class AuthSessionState {
  const AuthSessionState();
}

class AuthSessionUnauthenticated extends AuthSessionState {
  const AuthSessionUnauthenticated();
}

class AuthSessionAuthenticated extends AuthSessionState {
  const AuthSessionAuthenticated();
}
