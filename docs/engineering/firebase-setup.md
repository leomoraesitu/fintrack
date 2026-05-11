# Setup do Firebase no FinTrack

## Status atual

O projeto esta configurado com Firebase para autenticacao por e-mail/senha e CRUD remoto de transacoes no Firestore. O modo demo continua disponivel e usa persistencia local via `shared_preferences`.

Ao autenticar com usuario real, o app executa uma migracao explicita das transacoes locais para `users/{userId}/transactions`, salvando apenas documentos cujo `transactionId` ainda nao exista no Firestore. A rotina nao apaga os dados locais, preservando o modo demo.

No mesmo fluxo autenticado, o app garante a existencia do catalogo padrao de categorias em `users/{userId}/categories`, preservando categorias remotas ja existentes e completando apenas os ids padrao ausentes.

## 1. Criar projeto no Firebase Console

- Acesse [Firebase Console](https://console.firebase.google.com/)
- Crie um novo projeto (ex: FinTrack)
- Ative o Google Analytics se desejar

## 2. Ativar serviços necessários

- Authentication (e-mail/senha, Google, etc.)
- Firestore Database
- (Opcional) Storage para recibos ou anexos

## 3. Adicionar apps ao projeto

- Android: registre o pacote, baixe `google-services.json` e coloque em `android/app/`
- iOS: registre o bundle, baixe `GoogleService-Info.plist` e coloque em `ios/Runner/`
- Web/desktop: gere `lib/firebase_options.dart` com FlutterFire CLI e copie apenas as API keys para `.env/firebase_dev.json`

## 4. Dependencias usadas no pubspec.yaml

```yaml
dependencies:
  firebase_core: ^4.7.0
  firebase_auth: ^6.4.0
  cloud_firestore: ^6.3.0
```

## 5. Inicializar Firebase no Flutter

Em `lib/main.dart`:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(FinTrackApp(...));
}
```

## 5.1 Configuracao local das API keys

As Google API Keys nao ficam mais versionadas em `lib/firebase_options.dart`. O projeto le esses valores por `--dart-define-from-file` a partir de um arquivo local ignorado pelo Git.

Crie `.env/firebase_dev.json` a partir do exemplo versionado em `.env/firebase_dev.example.json`.

Estrutura esperada:

```json
{
  "FIREBASE_WEB_API_KEY": "sua-chave-web",
  "FIREBASE_ANDROID_API_KEY": "sua-chave-android",
  "FIREBASE_APPLE_API_KEY": "sua-chave-ios-e-macos"
}
```

As configuracoes de debug do VS Code ja carregam esse arquivo automaticamente. No terminal, use:

```bash
flutter run --dart-define-from-file=.env/firebase_dev.json
```

## 6. Regras de segurança básicas (Firestore)

As regras estao versionadas em [../../firestore.rules](../../firestore.rules).

Estrutura usada pelas transacoes:

```text
users/{userId}/transactions/{transactionId}
users/{userId}/categories/{categoryId}
```

A regra permite leitura e escrita apenas quando `request.auth.uid == userId` e bloqueia qualquer outro caminho. O schema de categorias aceita apenas `label` e `type` (`income` ou `expense`).

## 7. Validar regras no Firebase Emulator

As regras do Firestore possuem testes automatizados em `test/firebase/firestore.rules.test.mjs`.

Pre-requisitos locais:

- Node.js e npm.
- Java disponivel no `PATH` para executar o Firestore Emulator.

Instale as dependencias de teste:

```bash
npm install
```

Execute:

```bash
npm run test:firestore-rules
```

O teste sobe o Firestore Emulator com o projeto demo `demo-fintrack` e valida:

- usuario autenticado acessa apenas `users/{uid}/transactions`
- usuario autenticado acessa apenas `users/{uid}/categories`
- usuario anonimo nao acessa transacoes
- paths fora da colecao de transacoes permanecem bloqueados
- documentos de transacao respeitam o schema esperado
- documentos de categoria respeitam o schema esperado

## 8. Testar integração

- Rode o app em modo debug
- Teste login/cadastro
- Teste CRUD de dados
- Confirme que o catalogo remoto de categorias foi provisionado para o usuario autenticado
- Confirme que transacoes locais sao migradas apos login/cadastro real sem duplicar `transactionId`
- Rode `flutter analyze`
- Rode `flutter test`

## 9. Referências

- [Documentação oficial Firebase Flutter](https://firebase.flutter.dev/docs/overview)
- [ADR-006 - Adoção do Firebase](../adr/adr-006-adocao-firebase.md)

## Boas praticas

- Sempre valide o UID do usuario autenticado.
- Nao exponha colecoes globais sem filtro de autenticacao.
- Teste regras no simulador do Firebase antes de liberar em producao.
- Evite salvar transacoes fora do caminho `users/{userId}/transactions`.
- Evite salvar categorias fora do caminho `users/{userId}/categories`.
- Nao versione API keys em arquivos Dart ou JSON rastreados pelo Git.
