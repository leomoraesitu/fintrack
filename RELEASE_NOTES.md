# Release: sprint-4

## Visão Geral

Esta release consolida todas as entregas realizadas até o final da Sprint 4, incluindo as principais funcionalidades do MVP, melhorias de fluxo, telas e arquitetura, conforme planejado no backlog e nas especificações de produto.

---

## Escopo Entregue

- Autenticação mock para entrada no app
- Shell principal com navegação entre dashboard e transações
- Dashboard com saldo, receitas, despesas e transações recentes
- CRUD de transações em memória
- Categorias padrão para lançamentos
- Filtros por tipo, categoria e período
- Persistência local (se implementada até Sprint 4)
- Cobertura de testes para fluxos principais, categorias e dashboard

---

## Telas e Fluxos

- **Login Mock:** Entrada no app em modo demonstração, campos de email/senha, CTA de login demo
- **Shell Principal:** Navegação base autenticada, bottom navigation, ação para nova transação
- **Dashboard:** Saldo consolidado, resumo do período, lista de transações recentes
- **Lista de Transações:** Agrupamento temporal, busca, filtros rápidos, criação de transação
- **Filtros de Transação:** Filtros por tipo, período e categoria, ações de limpar/aplicar

---

## Arquitetura e Padrões

- Arquitetura em camadas: apresentação, domínio, dados
- Gerenciamento de estado com BLoC e Cubit
- Separação clara entre lógica de UI, regras de negócio e persistência
- Convenções de branch e commit seguidas conforme documentação do projeto

---

## Referências

- [Backlog Overview](docs/product/backlog-overview.md)
- [MVP Scope](docs/product/mvp-scope.md)
- [Screen Specs](docs/design/screen-specs.md)
- [Development Workflow](docs/engineering/development-workflow.md)

---

## Observações

- Esta release representa o marco de entrega do MVP funcional, pronto para demonstração e validação.
- Para detalhes de cards, critérios de aceite e próximos passos, consulte o board do Trello e a documentação detalhada.
