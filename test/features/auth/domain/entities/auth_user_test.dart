import 'package:fintrack/features/auth/domain/entities/auth_user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthUser.displayName', () {
    test('prioriza o nome explicito do perfil quando existir', () {
      const user = AuthUser(
        id: 'user-1',
        email: 'joao@email.com',
        name: 'Joao Silva',
      );

      expect(user.displayName, 'Joao Silva');
    });

    test('usa o prefixo do email como fallback', () {
      const user = AuthUser(
        id: 'user-1',
        email: 'joao@email.com',
      );

      expect(user.displayName, 'joao');
    });
  });
}