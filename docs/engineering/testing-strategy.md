# Estrategia de testes

## Objetivo

Definir a estrategia minima de testes do FinTrack para proteger regras criticas, manter previsibilidade das transicoes de estado e reduzir regressao durante a evolucao do MVP.

## Prioridades

1. regras de negocio e casos de uso
2. BLoCs e Cubits com fluxo relevante
3. widget tests para fluxos principais da interface
4. widget + golden tests para componentes criticos do Design System
5. smoke tests para bootstrap do app

## Organizacao sugerida

```text
test/
  app/
  design_system/
    widgets/
      goldens/
  features/
    auth/
    dashboard/
    transactions/
  domain/
  shared/
```

## Convencoes

- usar nomes de teste descritivos
- cobrir cenarios de sucesso, erro e vazio quando aplicavel
- manter doubles de teste simples e explicitos
- evitar testes muito acoplados a detalhes de implementacao visual sem valor funcional
- para golden tests, manter baseline versionado no repositorio

## Cobertura minima esperada

- casos de uso criticos com cobertura direta
- BLoCs principais com transicoes centrais testadas
- fluxo principal do app demonstravel por smoke test ou widget test
- componentes DS criticos cobertos por widget + golden test

## Ferramentas previstas

- `flutter_test`
- `bloc_test`
- `mocktail`

## Suite DS implementada

Caminho:

- `test/design_system/widgets/`

Componentes cobertos:

- `FtButton`
- `FtTextField`
- `FtSwitch`
- `FtStatCard`
- `FtTransactionListItem`

Padrao adotado:

- teste de comportamento (renderizacao/callback/interacao)
- golden light
- golden dark

Comandos uteis:

- validar suite DS: `flutter test test/design_system/widgets`
- gerar/atualizar baseline golden: `flutter test --update-goldens test/design_system/widgets`

## Regras praticas

- cada correcao de bug relevante deve considerar a adicao de teste
- cada feature nova deve sair com validacao compativel com seu risco
- testes nao substituem revisao de arquitetura e leitura critica do codigo

## Criterio de pronto para testes

Antes de mover um item para revisao:

- o fluxo principal funciona manualmente
- o comportamento central esta coberto por teste quando fizer sentido
- nao ha dependencia de estado global obscuro ou dificil de reproduzir
- quando houver mudanca visual de DS, baseline golden foi revisado/atualizado
