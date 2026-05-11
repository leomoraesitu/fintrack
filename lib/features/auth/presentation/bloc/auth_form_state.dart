abstract class AuthFormState {
  const AuthFormState();
}

class AuthFormInitial extends AuthFormState {
  const AuthFormInitial();
}

class AuthFormSubmitting extends AuthFormState {
  const AuthFormSubmitting();
}

class AuthFormSuccess extends AuthFormState {
  const AuthFormSuccess();
}

class AuthFormError extends AuthFormState {
  const AuthFormError({required this.message});

  final String message;
}
