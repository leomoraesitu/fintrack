# CHANGELOG

Este documento consolida as modificações do FinTrack desde o primeiro release tag identificado no repositório: `v0.4.0`.

## [Unreleased]

- Sem mudanças não consolidadas após a preparação da release `v0.5.0`.

## [v0.5.0] - 2026-05-09

## Visão Geral

Após a release `v0.4.0`, o projeto avançou da base do MVP local para uma Sprint 5 centrada em backend, sincronização inicial, autenticação real e amadurecimento da documentação. Este changelog considera tanto os commits já registrados após o tag quanto as alterações presentes no estado atual do branch.

## Escopo Entregue

- Integração inicial do Firebase ao aplicativo Flutter.
- Autenticação real por e-mail e senha com preservação do modo demo local.
- CRUD remoto de transações no Firestore para usuários autenticados.
- Provisionamento e gestão inicial de categorias em `users/{userId}/categories`.
- Migração explícita de transações locais para a conta autenticada após login ou cadastro.
- Sincronização básica da listagem de transações autenticadas via stream do Firestore.
- Detecção básica de conflito remoto por `updatedAt` na edição de transações.
- Reaplicação orientada do rascunho local após recarga da versão remota.
- Centralização da lógica de formatação e parsing de moeda.
- Personalização do shell com `displayName` do usuário autenticado.
- Correção responsiva da toolbar de transações para manter ações na mesma linha em largura estreita.
- Ampliação relevante da cobertura de testes unitários, de widget e de regras Firestore.
- Revisão e alinhamento da documentação técnica, de produto e de design ao estado real do projeto.

## Backend e Dados

- `FirebaseAuthRepository` passou a encapsular autenticação real e mapear `User.displayName` para o domínio.
- `FirebaseTransactionRepository` e os datasources remotos de transações foram adicionados para persistência em Firestore.
- O schema remoto passou a usar `users/{userId}/transactions/{transactionId}` com `categoryId`, `categoryLabel`, `categoryType` e `updatedAt`.
- Foi criada a infraestrutura remota de categorias com mapper, datasource, repositório e serviço de sincronização de catálogo.
- O app autentica, sincroniza catálogo padrão e migra transações locais sem duplicar `transactionId` já existente no backend.
- O modo demo continua operando com persistência local via `shared_preferences`.
- O storage local ficou mais resiliente a JSON corrompido e a itens inválidos durante reconstrução de transações.

## UX e Fluxos

- A tela de login evoluiu de fluxo mock para fluxo híbrido com login, cadastro e entrada demo.
- O greeting da shell passou a consumir `displayName` da sessão autenticada, preferindo nome real do perfil Firebase e usando prefixo do e-mail como fallback.
- O formulário de transações ganhou tratamento explícito para conflito remoto, com banner, recarga da versão remota, resumo das diferenças e reaplicação do rascunho local.
- O formulário também passou a permitir criação inline de categorias para contas autenticadas.
- Foi adicionada uma página simples de categorias para listar o catálogo e criar novas categorias fora do formulário.
- A toolbar de transações foi ajustada para manter `Filtros`, `Categorias` e `Ordenação` na mesma linha mesmo em largura estreita.

## Arquitetura e Infraestrutura

- A camada `data` foi expandida para suportar Auth e Firestore sem contaminar o domínio com dependências de Firebase.
- O repositório de dashboard passou a trabalhar de forma assíncrona para acomodar fontes de dados remotas.
- O `TransactionListBloc` passou a observar streams do repositório, refletindo mudanças remotas na listagem.
- O `FinTrackApp` ganhou escopo autenticado para comutar entre repositórios locais e remotos conforme o tipo de sessão.
- Foram versionados `firebase.json`, `firestore.rules`, `package.json` e `package-lock.json` para suporte a emulador e testes de regras.
- O repositório passou a incluir skills próprias em `.agents/skills/` e documentação de workflow do Codex.

## Testes e Qualidade

- Foram adicionados testes para autenticação, mapeamento Firestore, repositórios remotos, migração local-remoto, catálogo remoto de categorias e conflitos de formulário.
- Foram adicionados testes de widget para login, categorias, formulário de transações, migração autenticada e regressão de layout da toolbar estreita.
- Foram criados testes automatizados de `firestore.rules` cobrindo isolamento por usuário, schema de transações e schema de categorias.
- A formatação monetária passou a ser centralizada, reduzindo inconsistência visual entre telas e testes.

## Documentação

- ADR-006 foi atualizado de proposta para decisão aceita, com resultado inicial já implementado.
- A documentação de Firebase, modelagem de dados, backlog e escopo de MVP foi revisada para refletir a Sprint 5.
- README, docs de design e handoff visual deixaram de tratar autenticação mock como estado atual do produto.
- O índice de documentação passou a incluir workflow do Codex e setup do Firebase.
- A documentação de design foi reposicionada como referência visual versionada, sem dependência operacional de FlutterFlow.

## Referências

- [RELEASE_NOTES.md](c:\Users\leomo\OneDrive\Documentos\DEV\PORTFOLIO\fintrack\RELEASE_NOTES.md)
- [README.md](c:\Users\leomo\OneDrive\Documentos\DEV\PORTFOLIO\fintrack\README.md)
- [docs/adr/adr-006-adocao-firebase.md](c:\Users\leomo\OneDrive\Documentos\DEV\PORTFOLIO\fintrack\docs\adr\adr-006-adocao-firebase.md)
- [docs/engineering/firebase-setup.md](c:\Users\leomo\OneDrive\Documentos\DEV\PORTFOLIO\fintrack\docs\engineering\firebase-setup.md)
- [docs/product/backlog-overview.md](c:\Users\leomo\OneDrive\Documentos\DEV\PORTFOLIO\fintrack\docs\product\backlog-overview.md)

## Observações

- Primeiro release tag identificado: `v0.4.0`.
- Commits registrados após o tag até o momento desta consolidação: atualização documental da Sprint 5 e refatoração para centralização de moeda, além do conjunto atual de alterações ainda não versionadas no worktree.
- Esta seção versionada consolida o estado preparado para a próxima release após `v0.4.0`.
