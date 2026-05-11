---
name: fintrack-firebase-workflow
description: Use quando a tarefa envolver Firebase Auth, Firestore, regras de segurança, integração local-remoto, migração de dados ou validação de backend no FinTrack.
---

## Objetivo

Padronizar tarefas relacionadas ao backend Firebase do FinTrack, preservando o desacoplamento entre domínio e infraestrutura.

## Quando usar

- Ajustar autenticação real por e-mail e senha.
- Implementar ou revisar CRUD remoto no Firestore.
- Revisar `firestore.rules`.
- Investigar sincronização, isolamento por usuário ou migração de dados locais.
- Validar se a integração Firebase respeita a arquitetura documentada.

## Quando não usar

- Quando a tarefa for apenas visual ou de layout.
- Quando a mudança estiver restrita a estado local sem integração remota.
- Quando não houver relação com Auth, Firestore ou segurança.

## Passos

1. Confirmar se a regra de negócio continua no domínio e a infraestrutura na camada `data`.
2. Localizar os pontos de integração em `lib/app/`, `lib/features/auth/` e `lib/features/transactions/`.
3. Verificar a documentação em `docs/engineering/firebase-setup.md` e `docs/adr/adr-006-adocao-firebase.md`.
4. Usar MCP `firebase` quando isso reduzir incerteza sobre regras, ambiente ou operações de backend.
5. Validar qualquer dado de MCP contra o código versionado antes de editar.
6. Revisar testes e documentação impactados.

## Regras do projeto

- O domínio não depende de Firebase.
- Auth e Firestore ficam encapsulados em repositórios e datasources da camada `data`.
- O caminho esperado para transações é `users/{userId}/transactions/{transactionId}`.
- Mudanças em segurança devem considerar `firestore.rules` e validação compatível.
- O modo demo local deve continuar coerente quando a mudança afetar o fluxo autenticado.

## Validação mínima

- Rodar `dart analyze`.
- Rodar testes focados em autenticação, repositórios ou fluxos afetados.
- Confirmar coerência com `docs/engineering/firebase-setup.md` e ADR-006.