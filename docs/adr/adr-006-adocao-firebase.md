# ADR-006 - Adoção do Firebase como Backend

## Status

Aceita

## Contexto

Com a evolução do FinTrack, surgiu a necessidade de autenticação real, sincronização multi-dispositivo e persistência segura dos dados do usuário. O armazenamento local limita a escalabilidade, colaboração e backup dos dados.

## Decisão

Adotar o Firebase como backend principal para:

- Autenticação de usuários (e-mail/senha, provedores sociais futuramente)
- Persistência de transações financeiras
- Sincronização de categorias e dados entre dispositivos
- Regras de segurança e isolamento por usuário

## Alternativas consideradas

- Manter apenas armazenamento local (limitado para multi-dispositivo e backup)
- Backend próprio (maior custo de manutenção e infraestrutura)

## Impactos

- Refatoração da camada de dados para integração com Firebase
- Novos fluxos de autenticação e migração de dados locais
- Novas dependências no projeto Flutter
- Necessidade de regras de segurança no Firestore

## Resultado inicial

- Firebase inicializado em `lib/main.dart` com `DefaultFirebaseOptions`.
- Autenticacao real implementada via `FirebaseAuthRepository`.
- Login/cadastro por e-mail e senha integrados ao formulario de autenticacao.
- CRUD remoto de transacoes implementado em `FirebaseTransactionRepository`.
- Dados remotos isolados por usuario em `users/{userId}/transactions`.
- Catalogo remoto de categorias provisionado em `users/{userId}/categories`, preservando o conjunto padrao do MVP por usuario autenticado.
- Regras de seguranca versionadas em `firestore.rules`.
- Migracao explicita de transacoes locais para Firestore ao entrar com usuario real,
  ignorando transacoes cujo `transactionId` ja exista no remoto.
- Sincronizacao basica da listagem de transacoes autenticadas por stream do Firestore.
- Edicao remota com deteccao explicita de conflito por `updatedAt`, evitando sobrescrita silenciosa quando a mesma transacao muda em outro dispositivo.
- Formulario de edicao com banner de conflito, opcao de recarregar a versao remota e orientacao explicita para fechar a tela quando a transacao tiver sido removida no backend.

## Próximos passos

- Evoluir a UX de resolucao de conflito alem do bloqueio atual por versao, oferecendo comparacao ou escolha de reconciliacao ao usuario.
