# Handoff do FF Designer

## Objetivo

Registrar a origem do prototipo visual do FinTrack e mapear os frames exportados para o escopo funcional do MVP.

## Fonte oficial do prototipo

- link publico: https://share.ffdesigner.app/TJmmglOh9GCAtfNfXBOU
- ferramenta: FlutterFlow Designer
- variacoes exportadas: dark mode e light mode

## Escopo coberto pelo prototipo

O prototipo cobre o fluxo principal do MVP definido na documentacao de produto:

- autenticacao mock
- visualizacao de dashboard
- visualizacao da shell principal com navegacao base
- listagem de transacoes
- filtros por tipo, categoria e periodo
- criacao de transacao
- edicao de transacao
- confirmacao de exclusao
- estados de loading, vazio, erro e sucesso

## Mapeamento entre frames e features

| Frame | Feature relacionada | Documento funcional |
| --- | --- | --- |
| Login Mock | autenticacao | `docs/features/auth-mock.md` |
| Shell Principal | navegacao principal | `docs/adr/adr-004-navegacao.md` |
| Dashboard | dashboard | `docs/features/dashboard.md` |
| Lista de Transacoes | transacoes | `docs/features/transactions.md` |
| Filtros de Transacao | categorias e filtros | `docs/features/categories-and-filters.md` |
| Criar Transacao | transacoes | `docs/features/transactions.md` |
| Editar Transacao | transacoes | `docs/features/transactions.md` |
| Confirmacao de Exclusao | transacoes | `docs/features/transactions.md` |
| Estados de Interface | tratamento de estados | `docs/product/mvp-scope.md` |

## Leituras corretas do prototipo

- os frames representam referencia visual e de UX, nao implementacao tecnica pronta
- a aparencia do prototipo nao altera regras de negocio ja definidas na documentacao funcional
- light mode e dark mode devem ser tratados como variacoes do mesmo sistema visual
- imagens de estados servem como referencia de feedback de interface e nao como fluxo independente

## Decisoes visuais que ja podem orientar implementacao

- cor primaria azul vibrante como ancora de identidade
- superfices em cards com cantos arredondados e contraste alto
- separacao clara entre receita e despesa por cor semantica
- formularios com hierarquia forte para valor, tipo, categoria e data
- uso de bottom sheet para filtros
- uso de modal para confirmacao destrutiva

## Itens fora do escopo coberto pelos frames

- onboarding completo
- cadastro real de usuario
- backend e sincronizacao
- graficos avancados
- exportacao de dados
- configuracoes extensas

## Pasta dos artefatos no repositorio

- frames light: `docs/design/assets/frames/light/`
- frames dark: `docs/design/assets/frames/dark/`
- branding: `docs/design/assets/branding/`

## Uso recomendado na implementacao

1. usar os documentos funcionais como fonte de comportamento
2. usar este handoff e a especificacao de telas como fonte de UI
3. usar o design system como guia para tema, componentes e tokens
4. consultar os PNGs exportados para comparacao visual durante a implementacao