# ADR-003 - Persistencia local antes de backend

## Status

Aceito

## Contexto

O problema principal do MVP e o controle local de receitas e despesas. Backend, sincronizacao e multiusuario estao fora do escopo inicial.

## Decisao

Priorizar persistencia local como primeira estrategia de dados.

## Consequencias

### Positivas

- menor complexidade inicial
- valor de produto mais rapido no fluxo principal
- possibilidade de evolucao posterior para sincronizacao sem reescrever o dominio

### Custos

- nao ha sincronizacao entre dispositivos
- futuras migracoes de armazenamento devem ser planejadas

## Observacao

O mecanismo exato de persistencia ainda pode ser definido entre opcoes locais compativeis com o projeto, mas a decisao de etapa e persistencia local primeiro.
