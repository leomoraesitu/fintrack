# Design System do Prototipo

## Objetivo

Consolidar os principais tokens e padroes visuais observados no prototipo do FinTrack para orientar a implementacao da interface.

## Principios visuais

- clareza na leitura de valores financeiros
- contraste forte entre fundo e conteudo
- identidade objetiva com azul como elemento de marca
- uso consistente de cards, chips e botoes arredondados
- feedbacks de estado com semantica visual direta

## Paleta observada

### Cores base

- primaria: azul vibrante para destaque, CTA e estado ativo
- fundo dark: preto e cinza grafite
- fundo light: cinza muito claro com cards brancos
- superficie dark: cinza escuro para cards, campos e bottom sheets
- superficie light: branco com bordas cinza suaves

### Cores semanticas

- receita: verde
- despesa: vermelho
- erro: vermelho claro em superficie de alerta
- sucesso: verde forte em banner de confirmacao
- aviso: amarelo ou laranja suave em mensagens informativas

## Tipografia

- titulos de tela com peso forte e leitura imediata
- valores monetarios em escala maior que os demais textos
- labels de apoio com tom mais discreto
- uso de contraste forte para numeros e CTA

## Componentes observados

### Cards

- cantos arredondados amplos
- espacamento interno generoso
- destaque do conteudo principal no topo do card
- card de saldo como componente hero da home

### Botoes

- botao primario preenchido com azul
- botao secundario com fundo neutro ou contorno
- botao destrutivo preenchido com vermelho
- altura de toque confortavel para mobile

### Campos de formulario

- contorno simples e legivel
- foco em hierarquia vertical
- valor exibido com maior destaque do que os outros campos
- categoria e tipo com selecao em chips ou segmentos

### Chips e filtros

- formato capsula
- estado ativo em azul
- estado inativo em superficie neutra
- usados para tipo, categoria e periodo

### Feedbacks

- loading com skeleton
- vazio com icone, titulo, texto de apoio e CTA
- erro com bloco destacado e CTA de tentativa
- sucesso com banner curto e direto

## Comportamento por tema

### Dark mode

- foco em contraste alto
- cards escuros sobre fundo preto
- azul, verde e vermelho ganham maior protagonismo

### Light mode

- foco em leveza e limpeza visual
- cards brancos sobre fundo claro acinzentado
- a cor azul continua como ancora principal de identidade

## Regras de implementacao recomendadas

- centralizar tokens de cor, raio e espacamento em `lib/app/theme/`
- criar componentes compartilhados para card de saldo, item de transacao, chip de filtro e botoes principais
- evitar variacoes locais de cor fora do sistema definido
- manter paridade entre light e dark mode sempre que a feature existir nos dois temas