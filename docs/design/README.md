# Design do FinTrack

Esta pasta centraliza a documentacao visual do prototipo gerado no FlutterFlow Designer.

## Objetivo

Registrar a referencia visual do MVP para apoiar implementacao, revisao de interface e futuras iteracoes de design.

## Origem do prototipo

- FF Designer: https://share.ffdesigner.app/TJmmglOh9GCAtfNfXBOU
- temas exportados: light mode e dark mode
- origem dos frames: pacote de midia anexado ao projeto

## Documentos

- [Handoff do FF Designer](./ff-designer-handoff.md)
- [Design system](./design-system.md)
- [Especificacao de telas](./screen-specs.md)
- [Inventario de assets](./assets-inventory.md)

## Como consultar

1. comece pelo handoff para entender o que o prototipo cobre
2. use o design system para definir tema, componentes e tokens
3. use a especificacao de telas para validar composicao e hierarquia visual
4. confira os assets exportados para comparacao visual durante a implementacao

## Estrutura de assets

```text
assets/
  branding/
    logo/
    wordmark/
  frames/
    light/
    dark/
```

## Escopo coberto

O pacote atual cobre o prototipo visual do MVP para:

- login mock
- shell principal
- dashboard
- lista de transacoes
- filtros de transacao
- criar transacao
- editar transacao
- confirmacao de exclusao
- estados de interface

## Relacao com a implementacao

- o comportamento funcional continua sendo definido pela documentacao em `docs/features/`
- este material deve orientar interface, hierarquia visual e feedbacks
- os frames light e dark representam o mesmo sistema visual em variacoes de tema
- a implementacao pode simplificar detalhes visuais sem perder coerencia com a referencia

## Atualizacao recomendada

- manter novas exportacoes do FF Designer nesta mesma pasta quando substituirem a versao atual
- se houver nova rodada ampla de design, criar uma subpasta versionada em `assets/frames/`
- atualizar este indice e o handoff sempre que houver mudanca relevante de fluxo, estilo ou composicao das telas