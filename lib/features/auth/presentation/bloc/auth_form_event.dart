abstract class AuthFormEvent {
  const AuthFormEvent();
}

class AuthFormSignInSubmitted extends AuthFormEvent {
  const AuthFormSignInSubmitted({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;
}

class AuthFormSignUpSubmitted extends AuthFormEvent {
  const AuthFormSignUpSubmitted({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;
}
