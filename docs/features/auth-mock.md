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

## Estrategia inicial de sessao mock

### Decisao para a Sprint 1

A implementacao inicial da autenticacao mock sera baseada em uma entrada local sem backend real e sem persistencia entre reinicializacoes do app.

O objetivo desta etapa e validar o fluxo principal de acesso ao FinTrack com o menor acoplamento possivel.

### Regras da sessao

- o app inicia em estado nao autenticado
- o usuario acessa uma tela de login mock
- a entrada ocorre por uma acao principal de demo
- apos a entrada, o usuario e redirecionado para a shell principal
- o logout retorna o usuario para a tela de login
- a sessao permanece apenas em memoria nesta fase
- nao havera restauracao automatica de sessao na abertura do app nesta Sprint 1

### Estado observavel previsto

O fluxo deve permitir ao app distinguir claramente:

- usuario nao autenticado
- usuario autenticado

Se necessario para a implementacao, pode existir um estado transitorio simples de carregamento durante entrada ou saida, sem complexidade adicional de infraestrutura.

### Diretriz de navegacao

- a rota inicial do app deve apontar para o login quando nao houver sessao ativa
- a shell principal deve ser exibida apenas no estado autenticado
- a acao de logout deve ficar acessivel a partir da area autenticada

### Limites desta etapa

Esta estrategia nao inclui:

- validacao de credenciais reais
- cadastro de usuario
- integracao com backend
- persistencia local de sessao
- refresh token ou qualquer mecanismo de seguranca real

### Evolucao prevista

A implementacao deve permitir futura substituicao do fluxo mock por autenticacao real sem reescrever a navegacao principal do app.
