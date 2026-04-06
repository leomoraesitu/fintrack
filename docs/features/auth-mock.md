# Feature - Autenticacao mock

## Objetivo

Permitir a entrada no app sem backend real, viabilizando sessao simples e navegacao entre estado autenticado e nao autenticado.

## Fluxo principal

1. usuario acessa a tela de login
2. usuario preenche os dados minimos ou executa a acao de entrada mock
3. sistema valida o fluxo local
4. usuario e redirecionado para a shell principal
5. usuario pode encerrar a sessao e voltar para o login

## Criterios de aceite

- a tela de login existe e e clara para o usuario
- o fluxo indica que se trata de autenticacao mock
- o app diferencia sessao autenticada de nao autenticada
- logout devolve o usuario para a tela de login

## Regras de negocio

- o MVP nao depende de credenciais reais
- o app deve possuir um estado de sessao observavel
- o fluxo deve permitir futura substituicao por autenticacao real

## Dependencias tecnicas

- shell principal de navegacao
- estrategia de estado para sessao
- persistencia local simples, se houver restauracao de sessao no MVP
