# Estrutura do projeto

## Objetivo

Documentar a organizacao planejada de pastas do projeto para manter consistencia conforme as features forem implementadas.

## Estrutura alvo

```text
lib/
  app/
    router/
    theme/
    bootstrap/
  design_system/
    widgets/
  core/
    error/
    utils/
    constants/
  shared/
    widgets/
    extensions/
  features/
    auth/
      presentation/
      domain/
      data/
    dashboard/
      presentation/
      domain/
      data/
    transactions/
      presentation/
      domain/
      data/
    categories/
      presentation/
      domain/
      data/
  injection_container.dart
  main.dart

test/
  design_system/
    widgets/
      goldens/
  features/
```

## Regras de organizacao

- cada feature deve agrupar arquivos por responsabilidade e nao por tipo global do projeto
- widgets compartilhados entre features devem sair da feature e ir para `shared/`
- utilitarios genricos devem ir para `core/`
- `main.dart` deve permanecer enxuto e delegar bootstrap do app
- o arquivo de injecao nao deve concentrar regra de negocio

## Convencoes de nomeacao

- arquivos em `snake_case`
- classes em `PascalCase`
- variaveis e metodos em `camelCase`
- widgets terminam com sufixos claros, como `Page`, `View`, `Section` ou `Card`, quando fizer sentido
- BLoCs, eventos e estados devem refletir o fluxo da feature

## Estrutura minima por feature

Quando uma feature ainda estiver nascendo, a estrutura pode ser reduzida. Exemplo:

```text
features/transactions/
  presentation/
    pages/
    widgets/
    bloc/
  domain/
    entities/
    repositories/
    usecases/
  data/
    models/
    datasources/
    repositories/
```

## Critero de evolucao

A estrutura deve crescer somente quando a feature justificar. Evitar criar subpastas vazias apenas para antecipar complexidade futura.
