# Feature - Dashboard

## Objetivo

Exibir uma visao resumida da situacao financeira do usuario de forma clara e rapida.

## Fluxo principal

1. usuario entra no app
2. dashboard apresenta saldo atual
3. dashboard apresenta total de receitas e despesas do periodo
4. dashboard pode exibir transacoes recentes
5. usuario acessa a lista completa ou navega para outras areas

## Criterios de aceite

- saldo consolidado e exibido de forma clara
- totais de receitas e despesas do periodo sao apresentados
- estado vazio e tratado quando nao houver transacoes
- dashboard reage a alteracoes nas transacoes

## Regras de negocio

- resumo depende das transacoes cadastradas
- periodo de referencia deve ser consistente com a implementacao definida
- mudancas em receitas e despesas devem atualizar o resumo correspondente

## Dependencias tecnicas

- caso de uso para obter resumo financeiro
- entidade ou modelo de resumo
- bloco ou cubit para carregar o dashboard
- integracao com repositorio de transacoes
