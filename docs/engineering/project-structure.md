# Estrutura do projeto

## Objetivo

Documentar a organizacao atual e a direcao de evolucao das pastas do projeto para manter consistencia conforme as features forem implementadas.

## Estrutura atual relevante

```text
lib/
  app/
    app.dart
    theme/
  design_system/
    widgets/
  core/
    utils/
  shared/
    extensions/
    widgets/
  features/
    auth/
      data/
      domain/
      presentation/
    dashboard/
      data/
      domain/
      presentation/
    shell/
      presentation/
    transactions/
      data/
      domain/
      presentation/
  main.dart
  firebase_options.dart

test/
  core/
    utils/
  design_system/
    widgets/
      goldens/
  features/
    auth/
    dashboard/
    transactions/
```

## Direcao de evolucao

- cada feature principal deve continuar preferindo `presentation/`, `domain/` e `data/` quando houver complexidade suficiente
- features menores podem nascer apenas com a camada que realmente faz sentido no momento
- novas subpastas devem surgir por necessidade real, nao por antecipacao
- se `categories` voltar a existir como feature dedicada, deve seguir o mesmo padrao das demais

## Regras de organizacao

- cada feature deve agrupar arquivos por responsabilidade e nao por tipo global do projeto
- widgets compartilhados entre features devem sair da feature e ir para `shared/`
- utilitarios genricos devem ir para `core/`
- `main.dart` deve permanecer enxuto e delegar composicao da aplicacao
- `lib/app/app.dart` concentra a composicao principal da aplicacao

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
