# RELEASE_NOTES

## Release: sprint-4

### Visão Geral da sprint-4

Esta release consolida todas as entregas realizadas até o final da Sprint 4, incluindo as principais funcionalidades do MVP, melhorias de fluxo, telas e arquitetura, conforme planejado no backlog e nas especificações de produto.

---

### Escopo Entregue da sprint-4

- Autenticação mock para entrada no app
- Shell principal com navegação entre dashboard e transações
- Dashboard com saldo, receitas, despesas e transações recentes
- CRUD de transações em memória
- Categorias padrão para lançamentos
- Filtros por tipo, categoria e período
- Persistência local (se implementada até Sprint 4)
- Cobertura de testes para fluxos principais, categorias e dashboard

---

### Telas e Fluxos da sprint-4

- **Login Mock:** Entrada no app em modo demonstração, campos de email/senha, CTA de login demo
- **Shell Principal:** Navegação base autenticada, bottom navigation, ação para nova transação
- **Dashboard:** Saldo consolidado, resumo do período, lista de transações recentes
- **Lista de Transações:** Agrupamento temporal, busca, filtros rápidos, criação de transação
- **Filtros de Transação:** Filtros por tipo, período e categoria, ações de limpar/aplicar

---

### Arquitetura e Padrões da sprint-4

- Arquitetura em camadas: apresentação, domínio, dados
- Gerenciamento de estado com BLoC e Cubit
- Separação clara entre lógica de UI, regras de negócio e persistência
- Convenções de branch e commit seguidas conforme documentação do projeto

---

### Referências da sprint-4

- [Backlog Overview](docs/product/backlog-overview.md)
- [MVP Scope](docs/product/mvp-scope.md)
- [Screen Specs](docs/design/screen-specs.md)
- [Development Workflow](docs/engineering/development-workflow.md)

---

### Observações da sprint-4

- Esta release representa o marco de entrega do MVP funcional, pronto para demonstração e validação.
- Para detalhes de cards, critérios de aceite e próximos passos, consulte o board do Trello e a documentação detalhada.

---

## Release: v0.5.0

### Visão Geral da v0.5.0

Esta release consolida a evolução do FinTrack após `v0.4.0`, com foco na Sprint 5: integração inicial do Firebase, autenticação real, persistência remota para contas autenticadas, sincronização básica de dados e amadurecimento da documentação técnica e funcional.

---

### Escopo Entregue da v0.5.0

- Autenticação real por e-mail e senha com preservação do modo demo.
- Integração do Firebase Auth e Firestore ao app Flutter.
- CRUD remoto de transações para usuários autenticados.
- Migração explícita de transações locais para a conta autenticada.
- Provisionamento inicial e gestão básica de categorias remotas.
- Sincronização básica da listagem autenticada por stream do Firestore.
- Tratamento inicial de conflito remoto por `updatedAt`.
- Centralização da formatação monetária.
- Personalização do shell com `displayName` do usuário.
- Correção responsiva da toolbar de transações em largura estreita.
- Ampliação da cobertura de testes e criação de testes de regras Firestore.
- Revisão da documentação para refletir o estado real da Sprint 5.

---

### Telas e Fluxos da v0.5.0

- **Login e Cadastro:** autenticação real por e-mail e senha, com CTA separado para modo demo.
- **Shell Principal:** saudação passa a usar `displayName`, preferindo nome real do perfil Firebase.
- **Lista de Transações:** leitura remota para contas autenticadas, sincronização básica e toolbar ajustada para manter ações na mesma linha em telas estreitas.
- **Formulário de Transação:** criação e edição com suporte a conflito remoto, recarga da versão atual, resumo de diferenças e reaplicação do rascunho local.
- **Categorias:** criação inline no formulário e tela dedicada simples para contas autenticadas.

---

### Arquitetura e Padrões da v0.5.0

- Camada `data` expandida para suportar Firebase Auth e Firestore sem contaminar o domínio.
- Repositórios passaram a alternar entre fluxo local e remoto conforme o tipo de sessão.
- Dashboard evoluiu para fonte assíncrona, compatível com persistência remota.
- `TransactionListBloc` passou a observar streams do repositório.
- Regras Firestore, emulador local e testes de backend foram versionados junto ao app.

---

### Referências da v0.5.0

- [CHANGELOG.md](c:\Users\leomo\OneDrive\Documentos\DEV\PORTFOLIO\fintrack\CHANGELOG.md)
- [README.md](c:\Users\leomo\OneDrive\Documentos\DEV\PORTFOLIO\fintrack\README.md)
- [docs/adr/adr-006-adocao-firebase.md](c:\Users\leomo\OneDrive\Documentos\DEV\PORTFOLIO\fintrack\docs\adr\adr-006-adocao-firebase.md)
- [docs/engineering/firebase-setup.md](c:\Users\leomo\OneDrive\Documentos\DEV\PORTFOLIO\fintrack\docs\engineering\firebase-setup.md)
- [docs/product/backlog-overview.md](c:\Users\leomo\OneDrive\Documentos\DEV\PORTFOLIO\fintrack\docs\product\backlog-overview.md)

---

### Observações da v0.5.0

- Esta release marca a transição do MVP local para uma base híbrida, com modo demo preservado e contas autenticadas usando backend Firebase.
- A sincronização multi-dispositivo avançada e a conciliação mais rica de conflitos seguem como próximos passos.
