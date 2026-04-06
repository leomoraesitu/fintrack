# <img src="docs/design/assets/branding/logo/icone-fintrack.png" alt="Ícone do FinTrack" width="28" /> FinTrack

FinTrack é um aplicativo de finanças pessoais em Flutter, em desenvolvimento, com foco em ajudar usuários a acompanhar receitas, despesas e saldo em uma experiência mobile simples.

<p align="center">
  <img src="docs/design/assets/branding/wordmark/logo-fintrack-light.png" alt="Wordmark do FinTrack" width="240" />
</p>

## Resumo executivo

O projeto foi estruturado como um case de portfólio em Flutter para demonstrar capacidade de transformar uma ideia de produto em um fluxo de engenharia bem documentado, com visão funcional, decisão técnica, organização de backlog e referência visual pronta para implementação.

Para leitura de recrutadores e avaliadores técnicos, o repositório foi pensado para evidenciar raciocínio de produto, organização de arquitetura, clareza documental e preparo para evoluir de scaffold inicial para um MVP consistente.

### Destaques do projeto

- proposta de valor clara para controle de receitas e despesas
- documentação funcional, técnica e visual organizada em [docs/](docs/)
- protótipo de UX/UI consolidado com handoff e design system
- roadmap orientado a MVP, arquitetura em camadas e qualidade de código
- material estruturado para demonstrar processo, não apenas código final

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

## Preview funcional do MVP

O escopo funcional e visual já está consolidado, mesmo antes da implementação completa da interface.

```mermaid
flowchart LR
	A[Login mock] --> B[Shell principal]
	B --> C[Dashboard]
	B --> D[Lista de transações]
	D --> E[Criar transação]
	D --> F[Editar transação]
	D --> G[Filtros]
	F --> H[Confirmação de exclusão]
	C --> D
```

## Arquitetura pensada para o MVP

```mermaid
flowchart TD
	UI[Presentation\nTelas Widgets Bloc Cubit] --> Domain[Domain\nEntidades Casos de uso Contratos]
	Domain --> Data[Data\nModels Datasources Repositories]
	Design[Docs de UX/UI\nHandoff + Design system] -. orienta .-> UI
	Product[Docs de produto\nVisão MVP Backlog] -. orienta .-> Domain
	Workflow[Workflow\nADRs Testes Padrões] -. governa .-> UI
	Workflow -. governa .-> Data
```

## Direção de entrega

```mermaid
flowchart LR
	A[Descoberta do produto] --> B[Planejamento ágil]
	B --> C[Fundação técnica]
	C --> D[Implementação orientada a clean code]
	D --> E[Testes e evolução contínua]
```

## Referência visual

Os principais frames do protótipo já estão versionados no repositório e servem como referência de implementação, revisão de UI e leitura de escopo visual do MVP.

### Galeria do protótipo

| Login mock | Shell principal | Dashboard |
| --- | --- | --- |
| ![Login Mock](docs/design/assets/frames/light/Login%20Mock.png) | ![Shell Principal](docs/design/assets/frames/light/Shell%20Principal.png) | ![Dashboard](docs/design/assets/frames/light/Dashboard.png) |

| Lista de transações | Filtros | Criar transação |
| --- | --- | --- |
| ![Lista de Transações](docs/design/assets/frames/light/Lista%20de%20Transa%C3%A7%C3%B5es.png) | ![Filtros de Transação](docs/design/assets/frames/light/Filtros%20de%20Transa%C3%A7%C3%A3o.png) | ![Criar Transação](docs/design/assets/frames/light/Criar%20Transa%C3%A7%C3%A3o.png) |

| Editar transação | Confirmação de exclusão | Estados de interface |
| --- | --- | --- |
| ![Editar Transação](docs/design/assets/frames/light/Editar%20Transa%C3%A7%C3%A3o.png) | ![Confirmação de Exclusão](docs/design/assets/frames/light/Confirma%C3%A7%C3%A3o%20de%20Exclus%C3%A3o.png) | ![Estados de Interface](docs/design/assets/frames/light/Estados%20de%20Interface.png) |

O conjunto completo de referências visuais e suas correspondências funcionais está documentado em [docs/design/README.md](docs/design/README.md) e [docs/design/ff-designer-handoff.md](docs/design/ff-designer-handoff.md).

## Estado atual do repositório

- projeto Flutter inicializado e versionado
- estrutura multiplataforma gerada para Android, iOS, Web, Windows, Linux e macOS
- teste de widget padrão incluído como linha de base inicial para testes
- configuração de lint habilitada com `flutter_lints`
- protótipo visual do MVP documentado em [docs/design/](docs/design/)
- documentação técnica e funcional estruturada para continuidade do projeto

Neste momento, a lógica e a interface do aplicativo ainda estão na fase de scaffold.

## Stack técnica

- Flutter
- Dart
- Material Design
- arquitetura em camadas orientada a features
- BLoC e Cubit como estratégia planejada de gerenciamento de estado
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

## Documentação detalhada

Para continuidade do projeto, a documentação complementar está centralizada na pasta [docs/](docs/).

- visão geral da documentação em [docs/README.md](docs/README.md)
- visão do produto em [docs/product/product-vision.md](docs/product/product-vision.md)
- escopo do MVP em [docs/product/mvp-scope.md](docs/product/mvp-scope.md)
- backlog em alto nível em [docs/product/backlog-overview.md](docs/product/backlog-overview.md)
- arquitetura em [docs/engineering/architecture.md](docs/engineering/architecture.md)
- estrutura do projeto em [docs/engineering/project-structure.md](docs/engineering/project-structure.md)
- padrões de código em [docs/engineering/coding-standards.md](docs/engineering/coding-standards.md)
- gerenciamento de estado em [docs/engineering/state-management.md](docs/engineering/state-management.md)
- estratégia de testes em [docs/engineering/testing-strategy.md](docs/engineering/testing-strategy.md)
- fluxo de desenvolvimento em [docs/engineering/development-workflow.md](docs/engineering/development-workflow.md)
- documentação visual em [docs/design/README.md](docs/design/README.md)
- decisões técnicas em [docs/adr/](docs/adr/)
- especificações funcionais em [docs/features/](docs/features/)
- evolução futura em [docs/future/](docs/future/)

## Documentação visual

O handoff de UX/UI do protótipo está organizado em [docs/design/](docs/design/) para apoiar implementação e revisão visual.

- índice visual em [docs/design/README.md](docs/design/README.md)
- handoff do protótipo em [docs/design/ff-designer-handoff.md](docs/design/ff-designer-handoff.md)
- design system observado em [docs/design/design-system.md](docs/design/design-system.md)
- especificação de telas em [docs/design/screen-specs.md](docs/design/screen-specs.md)
- inventário de assets em [docs/design/assets-inventory.md](docs/design/assets-inventory.md)

## Por que este projeto

Este repositório faz parte de um portfólio em Flutter e está sendo desenvolvido para demonstrar fundamentos de desenvolvimento mobile, visão de produto, capacidade de documentação técnica e maturidade de estruturação de um projeto antes mesmo da fase intensa de implementação.

Mais do que um app de finanças em construção, o FinTrack funciona como evidência de processo: definição de escopo, organização do trabalho, consolidação de UX/UI, decisões arquiteturais e preparação para execução incremental de um MVP realista.
