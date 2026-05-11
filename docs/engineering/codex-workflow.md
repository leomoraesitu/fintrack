# Workflow do Codex no FinTrack

## Objetivo

Registrar como usar o Codex no FinTrack com consistência de processo, contexto e customização.

## Fluxo esperado de interação

O fluxo padrão adotado para este projeto é:

1. o Codex propõe um plano curto
2. o Codex explica o plano de forma didática
3. o Codex pergunta se deve aplicar o plano
4. após aprovação, o Codex implementa a menor mudança coerente
5. o Codex valida o que alterou e resume o resultado

Esse fluxo vale tanto para o Codex CLI quanto para outros contextos compatíveis com `AGENTS.md`.

## Camadas de customização recomendadas

### 1. Global

Arquivo:

- `C:/Users/leomo/.codex/AGENTS.md`

Uso recomendado:

- preferências pessoais de trabalho
- estilo de comunicação
- exigência de plano antes de editar
- regra de pedir aprovação antes de aplicar mudanças

Esse arquivo deve conter instruções reutilizáveis em qualquer repositório.

### 2. Repositório

Arquivo:

- `AGENTS.md`

Uso recomendado:

- arquitetura do FinTrack
- convenções de código e testes
- política de uso de MCP
- regras específicas sobre design, Firebase e documentação

Esse arquivo deve conter instruções específicas do projeto.

### 3. Skills repo-scoped

Pasta oficial:

- `.agents/skills/`

Uso recomendado:

- workflows especializados e reutilizáveis
- tarefas recorrentes como geração de código ou fluxo Firebase
- conhecimento que não precisa ficar sempre carregado no prompt base

## Skills ativas do projeto

- `.agents/skills/fintrack-code-generation/`
- `.agents/skills/fintrack-firebase-workflow/`

## Estratégia de manutenção das skills

O repositório atualmente contém as seguintes superfícies de skills:

- `.agents/skills/`
- `.github/skills/`

Para uso com Codex CLI, a fonte de verdade deve ser `.agents/skills/`.

Limpeza já aplicada:

- a skill duplicada `fintrack-code-generation` foi removida de `.github/skills/`
- a pasta `.agent/skills/` foi removida por ser um espelho redundante de `.github/skills/`
- a versão oficial dessa skill permanece em `.agents/skills/fintrack-code-generation/`
- as demais skills em `.github/skills/` seguem como conteúdo genérico de compatibilidade

Recomendação prática:

1. criar e evoluir skills novas apenas em `.agents/skills/`
2. tratar `.github/skills/` como pacote de compatibilidade mantido para outras ferramentas
3. evitar editar a mesma skill manualmente em múltiplos lugares
4. manter `.github/skills/` inteira enquanto ela continuar servindo como pacote de compatibilidade amplo

## Inventário curto de skills genéricas úteis

Entre as skills genéricas mantidas em `.github/skills/`, as mais úteis para o contexto atual do FinTrack são:

- `flutter-architecting-apps`: útil em refatorações estruturais e revisão de fronteiras entre presentation, domain e data
- `flutter-building-forms`: útil para fluxos como autenticação, filtros e formulários de transação
- `flutter-building-layouts`: útil para evolução de telas e composição responsiva
- `flutter-implementing-navigation-and-routing`: útil para shell, navegação principal e fluxos entre páginas
- `flutter-managing-state`: útil como referência genérica para estado compartilhado e transições de UI
- `flutter-testing-apps`: útil para ampliar testes unitários, widget e integração
- `flutter-theming-apps`: útil quando houver evolução consistente do design system e do tema global

As demais skills genéricas permanecem no repositório por decisão explícita de compatibilidade, mas têm prioridade menor para o fluxo diário do FinTrack.

## Política de MCP no FinTrack

### Servidores prioritários

- `dart`: investigar runtime, erros, widget tree, app conectado e comportamento Flutter/Dart
- `firebase`: autenticação, Firestore, regras de segurança e operações de backend
- `github`: PRs, issues, checks e contexto remoto

### Servidores não prioritários

- `flutterflow`: descartado do fluxo deste projeto
- `zapier`: usar apenas sob pedido explícito para automações externas

Regra central:

- qualquer dado vindo de MCP deve ser conferido contra o código e a documentação versionados no repositório antes de orientar mudanças

## Fonte de verdade para design

- `docs/design/` e assets versionados no repositório
- documentação funcional em `docs/features/` e `docs/product/`

O projeto não depende de FlutterFlow para evolução de interface.

## Verificações úteis

No início do uso do Codex CLI neste repositório, vale pedir:

1. "Liste as instruções ativas carregadas para este diretório"
2. "Resuma o AGENTS.md global e o do repositório"
3. "Liste as skills disponíveis em `.agents/skills`"

Essas verificações ajudam a confirmar se a cadeia de instruções correta foi carregada.

## Quando criar uma nova skill

Crie uma nova skill quando o workflow for:

- recorrente
- específico
- fácil de descrever com gatilhos claros
- melhor carregado sob demanda do que no `AGENTS.md`

Não crie skill para regras gerais de comportamento. Essas regras pertencem ao `AGENTS.md`.

## Decisão atual

- `.agents/skills/` permanece como fonte de verdade para skills do Codex no FinTrack
- `.github/skills/` permanece inteira como pacote de compatibilidade com outras ferramentas
- novas limpezas nessa superfície não são prioridade neste momento
