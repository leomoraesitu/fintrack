# Setup do Firebase no FinTrack

## 1. Criar projeto no Firebase Console
- Acesse https://console.firebase.google.com/
- Crie um novo projeto (ex: FinTrack)
- Ative o Google Analytics se desejar

## 2. Ativar serviços necessários
- Authentication (e-mail/senha, Google, etc.)
- Firestore Database
- (Opcional) Storage para recibos ou anexos

## 3. Adicionar apps ao projeto
- Android: registre o pacote, baixe google-services.json e coloque em android/app/
- iOS: registre o bundle, baixe GoogleService-Info.plist e coloque em ios/Runner/
- Web: copie as configurações para web/index.html

## 4. Adicionar dependências no pubspec.yaml
```
dependencies:
  firebase_core: ^latest
  firebase_auth: ^latest
  cloud_firestore: ^latest
```

## 5. Inicializar Firebase no Flutter
No main.dart:
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const FinTrackApp());
}
```

## 6. Regras de segurança básicas (Firestore)
```
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId}/... {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

## 7. Testar integração
- Rode o app em modo debug
- Teste login/cadastro
- Teste CRUD de dados

## 8. Referências

- [Documentação oficial Firebase Flutter](https://firebase.flutter.dev/docs/overview)
- [ADR-006 - Adoção do Firebase](../adr/adr-006-adocao-firebase.md)

---

## Regras de Segurança do Firestore

Exemplo de regra para isolar dados por usuário:

```
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId}/... {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

**Boas práticas:**
- Sempre valide o UID do usuário autenticado.
- Não exponha coleções globais sem filtro de autenticação.
- Teste regras no simulador do Firebase antes de liberar em produção.
