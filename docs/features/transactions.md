# Feature - Transacoes

## Objetivo

Permitir ao usuario registrar, listar, editar e excluir receitas e despesas.

## Fluxos principais

### Criacao

1. usuario acessa o formulario
2. informa titulo, valor, tipo, categoria e data
3. sistema valida os campos
4. transacao e salva
5. lista e resumo financeiro sao atualizados

### Edicao

1. usuario seleciona uma transacao existente
2. sistema abre o formulario com os dados atuais
3. usuario altera os campos necessarios
4. sistema persiste a mudanca

### Exclusao

1. usuario solicita remover a transacao
2. sistema solicita confirmacao
3. transacao e removida
4. lista e resumo sao atualizados

## Criterios de aceite

- usuario consegue criar uma transacao valida
- usuario consegue visualizar lista vazia e lista populada
- usuario consegue editar uma transacao existente
- usuario consegue excluir uma transacao com confirmacao
- receitas e despesas impactam corretamente o saldo

## Regras de negocio

- transacao deve ter tipo, valor, data e descricao minima definida pelo formulario
- receitas aumentam o saldo
- despesas reduzem o saldo
- alteracoes devem refletir nos agregados financeiros

## Dependencias tecnicas

- entidade de transacao no dominio
- repositorio para operacoes de CRUD
- gerenciamento de estado para formulario e listagem
- persistencia local ou repositorio em memoria na fase inicial
