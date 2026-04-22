# Design System Migration Checklist

Objetivo: mapear gaps de Design System no codigo de producao, priorizar migracao e acompanhar fechamento de debitos tecnicos sem quebrar arquitetura.

## Atualizacao desta branch

- `transaction_form_page.dart`: categoria migrada de dropdown para `ChoiceChip` com validacao obrigatoria no formulario.
- `shell_page.dart` + `transactions_page.dart`: ao salvar nova transacao, a lista agora atualiza imediatamente ao retornar do formulario.
- Componentes DS fortalecidos para evitar overflow em cenarios reais e de teste:
  - `FtStatCard`
  - `FtTransactionListItem`
- Suite de testes DS criticos adicionada (widget + golden):
  - `FtButton`
  - `FtTextField`
  - `FtSwitch`
  - `FtStatCard`
  - `FtTransactionListItem`

## 1) Widgets legados ainda em uso

| Arquivo | Linha | Problema | Acao sugerida |
|---|---:|---|---|
| `lib/features/dashboard/presentation/pages/dashboard_page.dart` | - | Uso legado `StatCard2` | Resolvido: dashboard usa `FtStatCard` |
| `lib/features/transactions/presentation/widgets/transaction_list_item.dart` | - | Uso legado `TransactionItem1` | Resolvido: wrapper usa `FtTransactionListItem` |
| `lib/shared/widgets/*` | varios | Ainda existem adapters legados/prototipos | Planejar limpeza segura apos confirmar zero uso em producao |

Notas:
- A pasta `lib/shared/widgets/` permanece como camada de compatibilidade.
- Proximo passo recomendado: remover arquivos legados sem referencia em runtime.

## 2) Uso de `Colors.*` fora de tokens/theme

| Arquivo | Linha | Problema | Acao sugerida |
|---|---:|---|---|
| `lib/design_system/widgets/buttons/ft_button.dart` | - | Hardcode de `Colors.*` em destructive | Resolvido: usa `AppColors.error/onError` |
| `lib/design_system/widgets/inputs/ft_text_field.dart` | - | Hardcode de `Colors.*` em borda/erro/filled | Resolvido: usa tokens semanticos |
| `lib/design_system/widgets/switches/ft_switch.dart` | - | Cores fixas de switch | Resolvido: usa componentes nativos + tema |
| `lib/app/theme/app_theme.dart` | ~126 | `Colors.transparent` literal | Opcional: trocar por token semantico para padrao 100% token-first |
| `lib/shared/widgets/*` | varios | Muitos `Colors.*` em legado | Nao investir em refino profundo; migrar/remover legado |

## 3) Hardcodes de spacing/radius nas features

| Arquivo | Linha | Problema | Acao sugerida |
|---|---:|---|---|
| `lib/features/dashboard/presentation/pages/dashboard_page.dart` | varios | Ainda ha composicoes ad-hoc de spacing/radius | Trocar por tokens explicitos (`AppSpacing`/`AppBorders`) |
| `lib/features/transactions/presentation/pages/transactions_page.dart` | varios | Ha expressoes ad-hoc (`AppSpacing.sm + AppSpacing.xs`) | Criar tokens explicitos para variantes (`chipVertical`, `compact`) |
| `lib/features/transactions/presentation/pages/transaction_form_page.dart` | varios | Formulario ainda mistura DS com widgets material defaults | Evoluir componentes DS e concluir migracao |

Notas:
- Hardcode residual em feature pode ser aceitavel temporariamente, desde que exista card de migracao.
- Priorizar consistencia semantica: tokens em vez de numeros magicos.

## 4) Adocao atual de componentes/tokens DS

Estado atual (positivo):
- `AppTheme` usa `AppColorsLight/AppColorsDark`.
- `AppTheme` usa `AppTypography`.
- `MaterialApp` usa `theme`, `darkTheme`, `themeMode: ThemeMode.system`.
- Dashboard e transacoes usam `FtButton`, `FtTextField`, `FtStatCard`, `FtTransactionListItem`, `FtEmptyState`, `FtErrorState`, `FtLoadingState`.
- Mapper de icone de categoria em presentation: `transaction_category_icon_mapper.dart`.

Gaps para concluir adocao:
- Concluir migracao do formulario de transacao para DS em 100% dos campos/acoes.
- Separar previews/prototipos de widgets de producao.
- Limpar/remover widgets legados em `shared/widgets` apos confirmacao de nao uso.
- Revisar hardcodes residuais de spacing/radius nas telas.

## Proximas acoes (ordem recomendada)

1. **Finalizar formulario de transacao em DS puro**
   - Remover dependencias de widgets material defaults quando houver equivalente DS.
2. **Padronizar variantes de spacing/radius por token**
   - Criar tokens semanticos para composicoes recorrentes.
3. **Consolidar baseline de golden DS**
   - Versionar imagens em `test/design_system/widgets/goldens/` e manter atualizacao disciplinada por PR.
4. **Limpeza e governanca de legado**
   - Remover adapters/prototipos sem uso e reforcar regra de revisao.

## Definicao de pronto da migracao

- Nenhuma tela de producao depende de componentes legados antigos.
- Componentes DS nao usam hardcodes de cor fora de tema/tokens.
- Spacing/borders das features usam tokens.
- Estados de UI (loading, vazio, erro, sucesso) sao padronizados com DS.
- Cobertura minima com testes de widget/golden nos componentes DS criticos.
