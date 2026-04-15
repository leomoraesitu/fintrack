# Design System – Componentes Padrões

Este documento serve como referência para os principais componentes, tokens e utilitários de responsividade do Design System do FinTrack.

---

## Tokens
Tokens são valores reutilizáveis que garantem consistência visual em todo o app. Exemplos:
- Cores (primária, secundária, erro, fundo, etc)
- Tipografia (fontes, tamanhos, pesos)
- Espaçamentos (margens, paddings)
- Bordas e radius
- Elevações/sombras

Tokens devem ser centralizados em arquivos como `lib/shared/tokens/`.

---

## Componentes & Widgets
Componentes são widgets reutilizáveis que seguem o padrão visual do Design System. Foram criados:

- **FtButton** (`lib/design_system/widgets/ft_button.dart`)
  - Variantes: primary, secondary, outline, ghost, destructive
  - Tamanhos: small, medium, large
  - Estados: loading, disabled, fullWidth
  - Suporte a ícones

- **FtSwitch** (`lib/design_system/widgets/ft_switch.dart`)
  - Variantes: Android, iOS, iOS 2.6+
  - Estados: ativo/inativo
  - Label opcional

- **FtTextField** (`lib/design_system/widgets/ft_text_field.dart`)
  - Variantes: outlined, filled, ghost
  - Estados: erro, enabled/disabled
  - Suporte a ícones, label, helper, hint

Todos os componentes seguem boas práticas de Clean Code, são parametrizáveis e prontos para uso em qualquer tela.

---

## Design System
A pasta `lib/design_system/` centraliza todos os componentes visuais reutilizáveis e utilitários de responsividade. Estrutura recomendada:

- `lib/design_system/widgets/` — componentes visuais (botões, switches, campos de texto, etc)
- `lib/design_system/responsive/` — utilitários para responsividade

---

## Responsividade
Para garantir boa experiência em diferentes dispositivos, foram criados:

- **AppBreakpoints** (`lib/design_system/responsive/app_breakpoints.dart`)
  - Define os pontos de corte: mobile, tablet, desktop
  - Métodos utilitários para checagem de breakpoint

- **FtResponsiveBuilder** (`lib/design_system/responsive/ft_responsive_builder.dart`)
  - Widget que constrói diferentes layouts conforme o breakpoint
  - Uso simples: defina builders para mobile, tablet e desktop

Exemplo de uso:
```dart
FtResponsiveBuilder(
  mobile: (_) => MobileScreen(),
  tablet: (_) => TabletScreen(),
  desktop: (_) => DesktopScreen(),
)
```

---

## Como usar
- Importe os widgets do Design System nas telas/features
- Use tokens centralizados para garantir consistência
- Utilize FtResponsiveBuilder e AppBreakpoints para adaptar o layout

---

Documentação atualizada em 15/04/2026.

## Componentes (referência anterior)

- **Botão Primário**
  - Uso: Ações principais
  - Variações: Com ícone, sem ícone, destrutivo
- **Input de Texto**
  - Uso: Formulários, busca
  - Variações: Com ícone, senha, erro
- **Chip**
  - Uso: Filtros, seleção
  - Variações: Selecionado, não selecionado, com ícone
- **Card de Transação**
  - Uso: Listas de transações
- **Card Resumo**
  - Uso: Dashboard
- **Modal**
  - Uso: Confirmação, erro, sucesso
- **Snackbar/Banner**
  - Uso: Feedbacks
- **Avatar**
  - Uso: Usuário, marca
- **Barra de Navegação Inferior**
  - Uso: Navegação principal
- **Skeleton Loader**
  - Uso: Estado de carregamento

## Para cada componente, documentar:
- Variações
- Estados (normal, hover, ativo, desabilitado, erro)
- Tokens utilizados (cores, tipografia, espaçamento, borda)
- Exemplos de uso

> Adicione exemplos e capturas de tela conforme os componentes forem implementados.
