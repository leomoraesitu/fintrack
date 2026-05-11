# AGENTS.md

## FinTrack - Instrucoes para agentes de IA

Este arquivo define o comportamento esperado de agentes trabalhando no repositório do FinTrack.

## Fluxo de trabalho esperado

- Antes de editar arquivos, proponha um plano curto e objetivo.
- Explique o plano de forma didática, ensinando o raciocínio e os tradeoffs principais.
- Pergunte se deve aplicar o plano antes de executar mudanças de código ou documentação.
- Se o pedido for apenas análise, revisão ou planejamento, não altere arquivos.
- Depois de aplicar mudanças, resuma o que foi feito e como foi validado.

## Contexto do projeto

- Aplicação Flutter com arquitetura em camadas orientada a features.
- Fluxo de dependência: Presentation -> Domain -> Data.
- Código principal em `lib/`.
- Testes em `test/`, espelhando a organização do código quando fizer sentido.
- Documentação do projeto deve permanecer em PT-BR.

## Estrutura atual relevante

- `lib/app/` concentra composição da aplicação e tema.
- `lib/features/auth`, `lib/features/dashboard` e `lib/features/transactions` usam `presentation/`, `domain/` e `data/`.
- `lib/features/shell` existe como feature de apresentação.
- `lib/core/`, `lib/shared/` e `lib/design_system/` concentram elementos reutilizáveis.

## Convenções de implementação

- Não colocar regra de negócio em widgets.
- Entidades de domínio não devem depender de Flutter ou Firebase.
- Implementações de repositório e datasource ficam na camada `data/`.
- Preferir mudanças pequenas, incrementais e de fácil validação.
- Atualizar documentação relacionada quando a mudança alterar arquitetura, fluxo ou uso.

## Estado e arquitetura

- Usar Cubit para estado local e simples.
- Usar Bloc para fluxos com múltiplos eventos, validações e efeitos assíncronos.
- Não reutilizar modelos de armazenamento como entidades de domínio.
- Não atravessar camadas com imports indevidos entre features.

## Validação esperada

- Executar `dart format` ou formatação equivalente quando necessário.
- Executar `dart analyze` para mudanças relevantes em código Dart.
- Executar `flutter test` ou um recorte menor compatível com a área alterada.
- Priorizar validação focada no escopo alterado antes de ampliar testes.

## Política de uso de MCP

- Usar o servidor `dart` para investigar runtime, app conectado, erros e comportamento específico de Flutter/Dart.
- Rodar análise, testes, `pub get` e comandos equivalentes de Dart/Flutter pelo servidor `dart` sempre que possível.
- Antes de usar ferramentas Dart MCP, se a rota do projeto ainda não estiver liberada, chamar `add_roots` com `file:///C:/Users/leomo/OneDrive/Documentos/DEV/PORTFOLIO/fintrack`.
- Usar comandos shell como `dart analyze`, `flutter test` ou `dart pub get` apenas como fallback quando o servidor `dart` estiver indisponível ou falhar por motivo não relacionado ao código, registrando o fallback no resumo.
- Usar o servidor `firebase` para tarefas de Auth, Firestore, regras de segurança, branches e operações relacionadas ao backend.
- Usar o servidor `github` apenas para PRs, issues, comentários, checks e contexto remoto do repositório.
- Não usar FlutterFlow neste projeto. Não depender do servidor `flutterflow` e não tratá-lo como fonte de verdade para UI, arquitetura ou geração de código.
- Não usar `zapier` salvo quando o usuário pedir explicitamente uma automação externa.
- Sempre confrontar qualquer informação obtida via MCP com o código e a documentação versionados no repositório antes de editar.

## Política de skills do projeto

- A pasta oficial de skills do Codex neste repositório é `.agents/skills/`.
- Conteúdos em `.agent/` e `.github/skills/` devem ser tratados como legado ou compatibilidade com outras ferramentas.
- Ao criar ou atualizar skills para uso do Codex CLI, usar `.agents/skills/` como fonte de verdade.
- Evitar manter cópias manuais divergentes da mesma skill em múltiplas pastas.

## Fonte de verdade para design

- O design deve ser guiado pelos artefatos versionados em `docs/design/` e pelos assets exportados já presentes no repositório.
- A documentação funcional em `docs/features/` e `docs/product/` continua definindo comportamento.
- Referências visuais não substituem decisões de arquitetura ou regras de domínio.

## Documentação principal

- `docs/README.md`
- `docs/engineering/architecture.md`
- `docs/engineering/project-structure.md`
- `docs/engineering/coding-standards.md`
- `docs/engineering/testing-strategy.md`
- `docs/engineering/development-workflow.md`
- `docs/engineering/firebase-setup.md`
- `docs/adr/`

## Cuidados frequentes

- Não misturar refatoração ampla com entrega funcional sem necessidade.
- Não assumir que toda feature precisa nascer com todas as subpastas possíveis.
- Não reativar referências operacionais a FlutterFlow no fluxo do projeto.
- Se uma convenção parecer desatualizada, ajustar a documentação junto com a mudança.
