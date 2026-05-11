class AuthUser {
  final String id;
  final String? email;
  final String? name;

  const AuthUser({
    required this.id,
    required this.email,
    this.name,
  });

  String? get userName {
    final currentEmail = email;
    if (currentEmail == null || !currentEmail.contains('@')) {
      return null;
    }

    return currentEmail.split('@').first;
  }

  String? get displayName {
    final currentName = name?.trim();
    if (currentName != null && currentName.isNotEmpty) {
      return currentName;
    }

    return userName;
  }
}
