# ADR-003 - Persistencia local antes de backend

## Status

Aceito

## Contexto

O problema principal do MVP e o controle local de receitas e despesas. Backend, sincronizacao e multiusuario estao fora do escopo inicial.

## Decisao

Priorizar persistencia local como primeira estrategia de dados.

Para o MVP, o mecanismo inicial escolhido sera `shared_preferences`, com serializacao da colecao de transacoes em JSON.

A leitura e a escrita dos dados devem ficar encapsuladas em um adaptador da camada de dados, sem expor detalhes de persistencia para o dominio ou para a UI.

## Consequencias

### Positivas

- menor complexidade inicial
- valor de produto mais rapido no fluxo principal
- possibilidade de evolucao posterior para sincronizacao sem reescrever o dominio
- integracao simples e multiplataforma no contexto atual do projeto
- menor custo para substituir a implementacao atual em memoria
- abordagem suficiente para o volume e a complexidade de dados previstos no MVP

### Custos

- nao ha sincronizacao entre dispositivos
- futuras migracoes de armazenamento devem ser planejadas
- solucao menos adequada para consultas complexas, filtros mais sofisticados ou grande volume de dados
- necessidade de serializar e desserializar manualmente a colecao persistida

## Observacao

Esta escolha atende bem ao estado atual do MVP, mas nao deve ser tratada como decisao definitiva de longo prazo.

Se o projeto evoluir para consultas mais complexas, maior volume de dados ou requisitos mais robustos de persistencia, a implementacao pode migrar para uma solucao local mais forte, preservando o dominio e os contratos ja definidos.
