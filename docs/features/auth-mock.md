# Feature - Autenticacao e modo demo

## Status

A autenticacao real por e-mail/senha foi implementada na Sprint 5 com Firebase Auth. O fluxo mock evoluiu para modo demo local, preservado para avaliacao rapida do app sem criar conta.

## Objetivo

Permitir a entrada no app por conta real ou modo demo, viabilizando sessao simples e navegacao entre estado autenticado e nao autenticado.

## Fluxo principal

1. usuario acessa a tela de login
2. usuario preenche e-mail/senha ou executa a acao de entrada demo
3. sistema valida a autenticacao real ou o fluxo local de demo
4. usuario e redirecionado para a shell principal
5. usuario pode encerrar a sessao e voltar para o login

## Criterios de aceite

- a tela de login existe e e clara para o usuario
- o fluxo oferece conta real e modo demo local
- o app diferencia sessao autenticada de nao autenticada
- logout devolve o usuario para a tela de login

## Regras de negocio

- o modo demo nao depende de credenciais reais
- o app deve possuir um estado de sessao observavel
- o fluxo deve manter conta real e modo demo sem duplicar a navegacao principal

## Dependencias tecnicas

- shell principal de navegacao
- estrategia de estado para sessao
- Firebase Auth para contas reais
- persistencia local simples para o modo demo

## Estrategia inicial de sessao mock

### Decisao para a Sprint 1

A implementacao atual separa conta real e modo demo. Contas reais usam Firebase Auth; o modo demo usa entrada local e persistencia local.

O objetivo desta feature continua sendo validar o fluxo principal de acesso ao FinTrack com o menor acoplamento possivel entre navegacao, sessao demo e autenticacao real.

### Regras da sessao

- o app inicia em estado nao autenticado
- o usuario acessa uma tela de login
- a entrada pode ocorrer por conta real ou por uma acao principal de demo
- apos a entrada, o usuario e redirecionado para a shell principal
- o logout retorna o usuario para a tela de login
- o modo demo permanece desacoplado de credenciais reais e usa persistencia local das transacoes
- contas reais dependem do estado autenticado provido pelo Firebase Auth

### Estado observavel previsto

O fluxo deve permitir ao app distinguir claramente:

- usuario nao autenticado
- usuario autenticado em modo demo
- usuario autenticado com conta real

Se necessario para a implementacao, pode existir um estado transitorio simples de carregamento durante entrada ou saida, sem complexidade adicional de infraestrutura.

### Diretriz de navegacao

- a rota inicial do app deve apontar para o login quando nao houver sessao ativa
- a shell principal deve ser exibida apenas no estado autenticado
- a acao de logout deve ficar acessivel a partir da area autenticada

### Limites desta etapa

Esta estrategia nao inclui:

- cadastro completo de perfil de usuario
- restauracao local sofisticada de sessao demo
- provedores sociais de autenticacao
- refresh token ou qualquer mecanismo de seguranca real

### Evolucao prevista

A implementacao permite manter o modo demo e usar autenticacao real sem reescrever a navegacao principal do app.
