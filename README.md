# FinTrack

FinTrack é um aplicativo de finanças pessoais em Flutter, em desenvolvimento, com foco em ajudar usuários a acompanhar receitas, despesas e saldo em uma experiência mobile simples.

## Status

Este projeto está em estágio inicial de desenvolvimento.

No momento, o repositório contém o scaffold base do Flutter e a configuração inicial do projeto. A direção do produto já está definida, mas as funcionalidades financeiras ainda estão em implementação.

## Visão do produto

O objetivo do FinTrack é oferecer uma forma clara e prática de gerenciar finanças pessoais em um único aplicativo.

A primeira versão está focada no essencial:

- registrar transações de receita e despesa
- acompanhar o saldo atual
- organizar gastos em um fluxo simples e intuitivo

## Funcionalidades planejadas para o MVP

- registro de transações de receita e despesa
- visualização de saldo
- organização básica de gastos
- experiência mobile com foco em usabilidade, desenvolvida com Flutter

## Estado atual do repositório

- projeto Flutter inicializado e versionado
- estrutura multiplataforma gerada para Android, iOS, Web, Windows, Linux e macOS
- teste de widget padrão incluído como linha de base inicial para testes
- configuração de lint habilitada com `flutter_lints`

Neste momento, a lógica e a interface do aplicativo ainda estão na fase de scaffold.

## Stack técnica

- Flutter
- Dart
- Material Design
- `flutter_test` para testes de widget
- `flutter_lints` para qualidade de código

## Como Executar

### Pre-requisitos

- Flutter SDK instalado
- Dart SDK disponível pelo Flutter
- emulador, simulador, navegador ou dispositivo físico configurado

### Executar Localmente

```bash
flutter pub get
flutter run
```

### Executar Testes

```bash
flutter test
```

## Estrutura do projeto

```text
lib/       Código principal da aplicação
test/      Testes de widget e testes unitários
android/   Runner para Android
ios/       Runner para iOS
web/       Target Web
windows/   Target Windows
linux/     Target Linux
macos/     Target macOS
```

## Roadmap

### 1. Descoberta e definição do MVP

- detalhar o problema que o aplicativo resolve e o perfil do usuário
- transformar os objetivos do produto em requisitos funcionais e não funcionais
- priorizar o backlog inicial com foco em entregas pequenas e de alto valor

### 2. Planejamento ágil e organização do projeto

- estruturar o desenvolvimento em etapas incrementais, com escopo claro por entrega
- organizar as funcionalidades em backlog, tarefas técnicas e critérios de aceitação
- acompanhar a evolução do projeto com base em priorização, revisão contínua e adaptação do plano

### 3. Fundação técnica e arquitetura da aplicação

- substituir a tela padrão do Flutter pela primeira experiência do FinTrack
- definir a estrutura inicial do projeto com separação clara de responsabilidades
- modelar as entidades e os fluxos principais do domínio financeiro

### 4. Implementação orientada a clean code

- desenvolver funcionalidades com nomes claros, responsabilidades bem definidas e baixo acoplamento
- manter funções e componentes simples, legíveis e fáceis de evoluir
- aplicar padronização de código, revisão contínua e refatoração incremental

### 5. Qualidade, testes e evolução contínua

- expandir a cobertura de testes conforme as funcionalidades forem implementadas
- validar fluxos críticos da aplicação a cada nova entrega
- evoluir a base do projeto com foco em manutenção, escalabilidade e consistência técnica

## Por que este projeto

Este repositório faz parte de um portfólio em Flutter e está sendo desenvolvido para demonstrar fundamentos de desenvolvimento mobile, visão de produto e a evolução de um projeto desde a configuração inicial até uma aplicação de finanças utilizável.
