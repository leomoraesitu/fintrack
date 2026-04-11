# Feature - Categorias e filtros

## Objetivo

Permitir ao usuario organizar e analisar melhor as transacoes por categoria, tipo e periodo.

## Fluxo principal

1. usuario cria ou edita uma transacao e escolhe uma categoria
2. usuario acessa a listagem e aplica filtros
3. sistema atualiza a lista conforme os criterios selecionados
4. usuario remove ou altera filtros conforme necessidade

## Criterios de aceite

- transacoes podem ser associadas a categorias padrao
- lista pode ser filtrada por tipo
- lista pode ser filtrada por categoria
- lista pode ser filtrada por periodo
- combinacoes simples de filtros devem funcionar de forma previsivel

## Regras de negocio

- categorias padrao devem estar disponiveis desde a criacao de transacoes
- filtros nao devem alterar os dados originais, apenas a visualizacao
- periodo invalido deve ser tratado antes da consulta final

## Dependencias tecnicas

- entidade de categoria ou representacao de categoria no dominio
- estrutura de filtro no dominio
- adaptacao da listagem e do repositorio
- estado dedicado para filtros, se a complexidade justificar

## Categorias padrao do MVP

### Objetivo

Definir um conjunto inicial de categorias padrao para sustentar os fluxos de criar, editar, listar e futuramente filtrar transacoes sem depender de backend.

### Convencao de identificacao

- cada categoria deve possuir um `id` estavel em `snake_case`
- cada categoria deve possuir um `label` em PT-BR para exibicao na interface
- cada categoria deve possuir um `type` compativel com o tipo da transacao: `income` ou `expense`
- os `ids` devem ser previsiveis para facilitar uso em testes, seeds e integracoes futuras

### Categorias de receita

- `salario` -> Salario
- `freelance` -> Freelance
- `investimentos` -> Investimentos
- `outras_receitas` -> Outras receitas

### Categorias de despesa

- `alimentacao` -> Alimentacao
- `transporte` -> Transporte
- `moradia` -> Moradia
- `saude` -> Saude
- `educacao` -> Educacao
- `lazer` -> Lazer
- `compras` -> Compras
- `contas` -> Contas
- `outras_despesas` -> Outras despesas

### Regras de uso no MVP

- o formulario de transacao deve permitir selecionar uma categoria padrao compativel com o tipo escolhido
- a categoria deve ser preservada nos fluxos de criacao e edicao
- a listagem deve exibir a categoria associada a cada transacao
- filtros por categoria devem considerar apenas essas categorias padrao nesta fase
- categorias personalizadas ficam fora do escopo atual do MVP

### Observacao de escopo

Nesta Sprint 2, o foco e consolidar categorias padrao e integra-las aos fluxos principais. Filtros mais completos, combinacoes avancadas e categorias customizadas ficam para iteracoes posteriores.
