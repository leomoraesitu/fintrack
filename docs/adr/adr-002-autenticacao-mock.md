# ADR-002 - Autenticacao mock no MVP

## Status

Aceito

## Contexto

O objetivo do MVP nao e validar autenticacao real nem backend. O foco inicial e entregar o fluxo principal do produto e a base tecnica do projeto.

## Decisao

Implementar autenticacao mock na primeira versao.

## Consequencias

### Positivas

- reduz dependencia de backend antes da hora
- permite validar navegacao protegida e fluxo de sessao
- acelera a entrega do MVP sem perder coerencia arquitetural

### Custos

- nao cobre credenciais reais, refresh token ou seguranca de producao
- exigira revisao futura se backend for introduzido

## Limites

- login apenas para entrada no app
- sessao simples local
- logout limpa o estado de sessao do MVP
