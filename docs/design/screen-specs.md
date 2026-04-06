# Especificacao de Telas

## Objetivo

Descrever a composicao de cada tela do prototipo para servir de referencia de implementacao e validacao visual.

## Login Mock

- objetivo: permitir entrada no app em modo demonstracao
- estrutura: logo, wordmark, formulario, CTA principal, opcoes sociais ilustrativas e aviso de ambiente demo
- componentes principais: campo de email, campo de senha, CTA `Entrar no modo demo`, bloco informativo
- observacoes: os botoes sociais aparecem como referencia visual, mas o MVP continua baseado em autenticacao mock

## Shell Principal

- objetivo: apresentar a navegacao base autenticada
- estrutura: home com bottom navigation e CTA central para nova transacao
- componentes principais: abas, acao primaria flutuante, avatar/acao superior
- observacoes: serve como referencia de casca navegacional e pode ser simplificada na implementacao inicial se necessario

## Dashboard

- objetivo: mostrar saldo consolidado, resumo do periodo e transacoes recentes
- estrutura: saudacao, card hero de saldo, cards de receita e despesa, lista recente, CTA
- componentes principais: card de saldo, cards resumo, lista de itens de transacao, acao `Ver todas`
- observacoes: existem duas variacoes proximas entre `Dashboard` e `Shell Principal`; tratar ambas como referencia do mesmo fluxo principal

## Lista de Transacoes

- objetivo: listar movimentacoes com agrupamento temporal e acesso a filtros
- estrutura: cabecalho, busca, chips de filtro rapido, grupos por data, lista de cards, CTA para criar transacao
- componentes principais: item de transacao, busca, botao de filtros, CTA inferior
- observacoes: a listagem reforca ordenacao da mais recente para a mais antiga

## Filtros de Transacao

- objetivo: permitir filtragem por tipo, periodo e categoria
- estrutura: bottom sheet com secoes de filtros e acoes ao final
- componentes principais: chips de tipo, chips de periodo, chips de categoria, botoes `Limpar` e `Aplicar Filtros`
- observacoes: o periodo `Este mes` aparece como opcao padrao no prototipo

## Criar Transacao

- objetivo: cadastrar uma nova receita ou despesa
- estrutura: app bar, valor destacado, seletor de tipo, titulo, categoria, data, descricao e CTA de salvar
- componentes principais: cabecalho, campo de valor, segmentacao de tipo, chips de categoria, seletor de data, botao `Salvar Transacao`
- observacoes: o valor tem papel central na hierarquia visual da tela

## Editar Transacao

- objetivo: alterar uma transacao existente e oferecer acao de exclusao
- estrutura: semelhante a criacao, com dados preenchidos e icone de lixeira no topo
- componentes principais: mesmos da tela de criacao, com CTA `Salvar Alteracoes`
- observacoes: a acao destrutiva aparece na app bar, mas deve continuar protegida por confirmacao modal

## Confirmacao de Exclusao

- objetivo: confirmar a remocao de uma transacao
- estrutura: modal central com icone, titulo, descricao e acoes
- componentes principais: CTA destrutivo `Excluir`, CTA secundaria `Cancelar`
- observacoes: a composicao reforca separacao clara entre confirmacao e cancelamento

## Estados de Interface

- objetivo: registrar a linguagem visual dos estados de sistema
- estados cobertos: loading com skeleton, vazio sem resultados, erro de conexao ou sistema, feedback de sucesso
- observacoes: estes padroes devem ser aplicados nas telas relevantes em vez de tratados como pagina isolada de produto

## Referencia dos frames

- dark mode: `docs/design/assets/frames/dark/`
- light mode: `docs/design/assets/frames/light/`