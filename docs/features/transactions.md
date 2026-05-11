# Feature - Transacoes

## Status

O CRUD principal de transacoes esta implementado. No modo demo, a persistencia segue local. Em contas autenticadas, as transacoes usam Firestore com deteccao basica de conflito remoto por `updatedAt`, resumo das diferencas recarregadas e opcao de reaplicar o rascunho local. O catalogo de categorias tambem passa a ser provisionado no Firestore por usuario autenticado, com criacao inline de novas categorias diretamente no formulario.

Tambem existe uma tela simples de categorias para contas autenticadas, permitindo listar o catalogo atual e criar novas categorias fora do fluxo do formulario.

## Objetivo

Permitir ao usuario registrar, listar, editar e excluir receitas e despesas, com reflexo imediato no resumo financeiro e comportamento coerente entre modo demo e conta autenticada.

## Fluxos principais

### Criacao

1. usuario acessa o formulario
2. se necessario, cria uma nova categoria inline no proprio formulario
3. informa descricao, valor, tipo, categoria e data
4. sistema valida os campos
5. transacao e salva
6. lista e resumo financeiro sao atualizados

### Gestao simples de categorias

1. usuario autenticado acessa a tela de transacoes
2. abre a tela de categorias
3. visualiza o catalogo atual disponivel para filtros e formulario
4. cria uma nova categoria manualmente
5. a nova categoria fica disponivel imediatamente no app autenticado

### Edicao

1. usuario seleciona uma transacao existente
2. sistema abre o formulario com os dados atuais
3. usuario altera os campos necessarios
4. sistema persiste a mudanca
5. lista e resumo financeiro refletem a versao atual da transacao

### Edicao com conflito remoto

1. usuario tenta salvar uma transacao que foi alterada em outro dispositivo
2. sistema bloqueia a sobrescrita silenciosa
3. formulario exibe um banner de conflito
4. usuario pode recarregar a versao mais recente da transacao
5. sistema resume os campos alterados entre a versao anterior e a versao remota recarregada
6. usuario pode reaplicar sua edicao local sobre a versao mais recente
7. apos revisar os dados resultantes, usuario pode salvar novamente

### Edicao com remocao remota

1. usuario tenta continuar editando uma transacao que nao existe mais no backend
2. sistema identifica que a transacao foi removida remotamente
3. formulario exibe um banner com orientacao objetiva
4. usuario pode fechar a tela e retornar para a lista

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
- usuario autenticado recebe feedback explicito quando existe conflito remoto na edicao
- usuario autenticado consegue recarregar a versao mais recente da transacao apos conflito
- usuario autenticado consegue visualizar um resumo objetivo das diferencas apos recarregar a versao remota
- usuario autenticado consegue reaplicar sua edicao local antes de salvar novamente
- usuario autenticado recebe acao objetiva para fechar a tela quando a transacao foi removida no backend
- usuario autenticado consegue criar uma nova categoria inline e reutiliza-la imediatamente no formulario
- usuario autenticado consegue listar e criar categorias em uma tela dedicada

## Regras de negocio

- transacao deve ter tipo, valor, data e descricao minima definida pelo formulario
- receitas aumentam o saldo
- despesas reduzem o saldo
- alteracoes devem refletir nos agregados financeiros
- no modo demo, a persistencia continua local
- em conta autenticada, a persistencia usa `users/{userId}/transactions/{transactionId}` no Firestore
- em conta autenticada, o catalogo de categorias e lido de `users/{userId}/categories/{categoryId}`, com provisionamento automatico do conjunto padrao quando necessario
- em conta autenticada, novas categorias criadas no formulario devem ser persistidas no catalogo remoto e ficar disponiveis para filtros e novos lancamentos
- em conta autenticada, novas categorias criadas na tela de categorias devem atualizar o mesmo catalogo usado em filtros e lancamentos
- edicoes remotas concorrentes nao devem sobrescrever silenciosamente uma versao mais nova da transacao
- quando a versao remota e recarregada, o formulario deve permitir restaurar o rascunho local do usuario sobre a revisao mais recente

## Dependencias tecnicas

- entidade de transacao no dominio
- repositorio para operacoes de CRUD
- gerenciamento de estado para formulario e listagem
- persistencia local no modo demo e repositorio remoto com Firestore para contas autenticadas
- tratamento de conflito no formulario via estado explicito, resumo das diferencas, recarga da versao remota e reaplicacao do rascunho local
