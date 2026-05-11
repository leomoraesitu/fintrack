---
name: fintrack-code-generation
description: Use quando for criar, estender ou reorganizar código do FinTrack em features, camadas, widgets, testes ou documentação técnica, seguindo a arquitetura do repositório.
---

## Objetivo

Aplicar um fluxo consistente de geração e evolução de código no FinTrack, respeitando arquitetura, organização de pastas, nomenclatura, testes e documentação.

## Quando usar

- Criar uma nova feature ou ampliar uma existente.
- Adicionar widgets, blocs, cubits, repositórios, datasources, entidades ou casos de uso.
- Organizar testes para espelhar o código alterado.
- Atualizar documentação técnica associada à mudança.

## Quando não usar

- Quando a tarefa for apenas análise, revisão ou planejamento.
- Quando a mudança for exclusivamente de infraestrutura externa sem impacto no código do app.
- Quando a tarefa exigir só consulta de documentação ou investigação em runtime.

## Passos

1. Confirmar o objetivo da mudança e a área do projeto afetada.
2. Localizar a feature ou camada correta em `lib/`.
3. Aplicar a menor mudança coerente com a arquitetura atual.
4. Criar ou atualizar testes em `test/` quando o risco justificar.
5. Atualizar documentação quando a mudança alterar fluxo, estrutura ou uso.
6. Validar com formatação, análise e testes compatíveis com o escopo.

## Regras do projeto

- Presentation coordena UI, navegação e estado visível.
- Domain concentra entidades, contratos e regras de negócio.
- Data implementa repositórios, modelos e datasources.
- Não colocar regra de negócio em widgets.
- Não usar modelos de persistência como entidades de domínio.
- Documentação do projeto deve ficar em PT-BR.

## Validação mínima

- Rodar `dart analyze` para mudanças relevantes em Dart.
- Rodar `flutter test` ou um recorte focado quando houver comportamento alterado.
- Garantir consistência entre código, testes e documentação.