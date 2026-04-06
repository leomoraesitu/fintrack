# ADR-004 - Navegacao principal do MVP

## Status

Aceito

## Contexto

O FinTrack precisa de uma navegacao simples para suportar login, dashboard, transacoes e areas auxiliares sem introduzir complexidade de fluxo antes do necessario.

## Decisao

Adotar uma shell principal apos login, com destinos claros para as areas centrais do MVP.

## Consequencias

### Positivas

- navegacao previsivel para o usuario
- melhor separacao entre fluxo autenticado e nao autenticado
- base adequada para crescimento do app

### Custos

- a definicao de rotas e destinos precisa ser revisada conforme novas features surgirem

## Diretriz

- manter uma rota inicial para login
- redirecionar para a shell autenticada apos sucesso
- preservar uma area principal para dashboard e outra para transacoes
