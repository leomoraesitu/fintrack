# Fluxo de desenvolvimento

## Objetivo

Padronizar a execucao do projeto com foco em pequenas entregas, historico legivel e integracao coerente entre backlog, codigo e documentacao.

## Fluxo recomendado

1. selecionar um card refinado no board
2. confirmar criterios de aceite e dependencias
3. implementar a menor entrega completa possivel
4. validar manualmente e por testes quando aplicavel
5. atualizar documentacao relacionada, se necessario
6. registrar commit com mensagem semantica clara

## Convencao de branches

Sugestao:

- `main` para a linha principal
- `feature/nome-curto` para implementacoes de produto
- `fix/nome-curto` para correcoes
- `docs/nome-curto` para documentacao
- `refactor/nome-curto` para reorganizacao sem mudanca funcional

## Convencao de commits

Padrao recomendado:

- `feat: adiciona formulario de transacao`
- `fix: corrige calculo do saldo mensal`
- `docs: atualiza arquitetura do projeto`
- `refactor: reorganiza estrutura de pastas da feature transactions`
- `test: adiciona testes do transaction form bloc`
- `chore: configura dependencias iniciais`

## Regra de tamanho das entregas

- preferir commits e cards pequenos
- evitar misturar varias responsabilidades no mesmo commit
- evitar abrir uma feature grande sem quebrar em incrementos validaveis

## Integracao com o board

- o board do Trello e a fonte operacional do trabalho
- sprint deve ser metadado do card, nao lista de fluxo
- Definition of Ready e Definition of Done devem ser respeitadas antes da troca de status

## Qualidade minima antes de concluir

- app continua compilando
- testes relevantes passam
- a entrega atende aos criterios de aceite
- a estrutura do projeto permanece coerente
- a documentacao foi atualizada quando a mudanca afeta arquitetura, backlog ou uso
