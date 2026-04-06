# Contribuindo com o FinTrack

## Objetivo

Este documento define como contribuir com o FinTrack de forma clara, previsível e alinhada com a organização atual do projeto.

## Status atual do projeto

No momento, o FinTrack é conduzido principalmente como um projeto de portfólio e evolução técnica.

Contribuições externas são bem-vindas principalmente para:

- correções pontuais
- melhorias de documentação
- ajustes de organização técnica
- sugestões de arquitetura, UX/UI e fluxo de produto

Antes de investir tempo em uma mudança maior, prefira alinhar a proposta em uma issue ou discussão.

## Formas de contribuir

Você pode contribuir de algumas formas:

- reportando bugs
- propondo melhorias de produto ou arquitetura
- refinando documentação
- implementando correções pequenas e objetivas
- adicionando ou melhorando testes

## Antes de começar

1. verifique se já existe issue, card ou documentação relacionada ao tema
2. confirme o escopo da mudança
3. prefira entregas pequenas e fáceis de revisar
4. evite misturar documentação, refatoração e feature grande no mesmo pull request

## Preparando o ambiente

### Pré-requisitos

- Flutter SDK instalado
- Dart SDK disponível pelo Flutter
- editor configurado para desenvolvimento Flutter

### Setup local

```bash
flutter pub get
flutter test
flutter run
```

## Fluxo recomendado

O fluxo esperado para contribuições segue esta ordem:

1. alinhar a proposta
2. criar uma branch específica
3. implementar a menor entrega completa possível
4. validar a mudança localmente
5. atualizar documentação quando necessário
6. abrir um pull request com contexto suficiente para revisão

## Convenção de branches

Use nomes curtos e descritivos:

- `feature/nome-curto`
- `fix/nome-curto`
- `docs/nome-curto`
- `refactor/nome-curto`
- `test/nome-curto`

Exemplos:

- `feature/transaction-form`
- `fix/dashboard-balance`
- `docs/readme-navigation`

## Convenção de commits

Use mensagens semânticas, curtas e objetivas.

Padrões recomendados:

- `feat: adiciona formulario de transacao`
- `fix: corrige calculo do saldo`
- `docs: atualiza navegacao do readme`
- `refactor: reorganiza estrutura da feature transactions`
- `test: adiciona testes do dashboard bloc`
- `chore: ajusta configuracao inicial`

## Diretrizes de implementação

Ao contribuir, siga estas regras:

- preserve o escopo da mudança
- evite alterações não relacionadas
- mantenha nomes claros e responsabilidade bem definida
- prefira soluções simples e coerentes com o estágio atual do projeto
- mantenha a documentação em PT-BR

## Documentação

Se a sua alteração impactar arquitetura, fluxo, escopo ou uso do projeto, atualize a documentação correspondente.

Referências principais:

- [README.md](README.md)
- [docs/README.md](docs/README.md)
- [docs/engineering/development-workflow.md](docs/engineering/development-workflow.md)
- [docs/engineering/coding-standards.md](docs/engineering/coding-standards.md)
- [docs/engineering/testing-strategy.md](docs/engineering/testing-strategy.md)
- [docs/design/README.md](docs/design/README.md)

## Qualidade mínima antes de abrir PR

Antes de abrir um pull request, confirme:

- o projeto continua executando sem regressões evidentes
- os testes relevantes passam
- a mudança atende ao objetivo proposto
- não existem arquivos ou alterações acidentais no diff
- a documentação foi atualizada quando necessário

## Pull requests

Ao abrir um PR, descreva com clareza:

- o problema atacado
- a solução adotada
- os arquivos ou áreas impactadas
- como validar a mudança
- limitações ou próximos passos, se houver

Prefira PRs pequenos. Eles são mais rápidos de revisar, menos arriscados e preservam melhor o histórico do projeto.

## O que evitar

Evite abrir contribuições com estas características:

- mudanças grandes sem alinhamento prévio
- mistura de refatoração ampla com feature nova
- alterações visuais sem referência ao handoff ou escopo documentado
- commits genéricos como `update`, `fixes` ou `ajustes`

## Dúvidas e alinhamento

Se existir incerteza sobre direção técnica, experiência do usuário ou escopo funcional, alinhe antes de implementar.

Em contribuições maiores, discutir a proposta antes reduz retrabalho e mantém coerência entre código, documentação e produto.