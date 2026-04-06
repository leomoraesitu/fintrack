# Gerenciamento de estado

## Objetivo

Definir como o projeto deve usar BLoC e Cubit para manter previsibilidade, isolamento de fluxo e clareza entre interface e negocio.

## Diretriz principal

Nem toda tela precisa de um BLoC. O criterio e a complexidade do fluxo.

## Quando usar Cubit

Usar Cubit quando:

- o estado e simples e local
- ha poucas transicoes previsiveis
- nao existem multiplos eventos com regras distintas

Exemplos provaveis:

- alternancia de aba local
- estado de filtro simples temporario
- controles visuais de formulario sem regra extensa

## Quando usar Bloc

Usar Bloc quando:

- o fluxo possui multiplos eventos relevantes
- ha validacoes, carregamento e persistencia
- a ordem dos eventos importa
- o estado precisa ser explicitamente modelado

Exemplos provaveis:

- autenticacao mock
- formulario de transacao
- listagem de transacoes
- dashboard com resumo financeiro

## Fronteiras de responsabilidade

- a UI dispara eventos ou interage com Cubits
- Bloc e Cubit orquestram estado e chamam casos de uso ou repositorios via abstracoes definidas
- datasource e persistencia nunca devem ser acessados diretamente da UI

## Modelagem de estado

Estados devem representar situacoes reais da tela, como:

- initial
- loading
- success
- empty
- error

Quando necessario, usar um estado unico com propriedades claras ou estados explicitamente separados. A escolha deve privilegiar legibilidade e facilidade de teste.

## Observabilidade

Durante desenvolvimento, o projeto deve usar `BlocObserver` para rastrear transicoes, eventos e erros relevantes sem poluir a regra de negocio.

## Evolucao

A estrategia de estado deve ser revisada quando:

- uma feature crescer alem do previsto
- um Cubit simples passar a carregar multiplas responsabilidades
- o fluxo exigir eventos mais explicitos ou efeitos assincronos mais complexos
