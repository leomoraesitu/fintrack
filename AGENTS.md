# AGENTS.md

## FinTrack – AI Coding Agent Instructions

This file provides concise, actionable guidance for AI coding agents working in the FinTrack repository. It links to detailed documentation and highlights key conventions, architecture, and workflows to ensure productive and consistent contributions.

---

### 📚 Documentation Index
- [Project Documentation Index](docs/README.md)
- [Product Vision](docs/product/product-vision.md)
- [MVP Scope](docs/product/mvp-scope.md)
- [Architecture](docs/engineering/architecture.md)
- [Project Structure](docs/engineering/project-structure.md)
- [Coding Standards](docs/engineering/coding-standards.md)
- [State Management](docs/engineering/state-management.md)
- [Testing Strategy](docs/engineering/testing-strategy.md)
- [Development Workflow](docs/engineering/development-workflow.md)
- [ADR Index](docs/adr/)

---

### 🏗️ Project Structure
- Main code: `lib/`
- Features: `lib/features/` (each with `presentation/`, `domain/`, `data/`)
- Shared/core utilities: `lib/core/`, `lib/shared/`
- Tests: `test/` mirrors `lib/` structure

---

### 🧩 Architecture
- Layered: Presentation → Domain → Data
- UI logic (widgets, navigation, BLoC/Cubit) in Presentation
- Business logic, entities, and repository contracts in Domain
- Data sources and repository implementations in Data
- See [Architecture](docs/engineering/architecture.md) for details

---

### ⚙️ State Management
- Use Cubit for simple/local state
- Use Bloc for complex flows, multiple events, or async effects
- See [State Management](docs/engineering/state-management.md) and [ADR-001](docs/adr/adr-001-adocao-bloc.md)

---

### 🧪 Testing
- Prioritize business logic, BLoCs, and main flows
- Use descriptive test names and simple test doubles
- See [Testing Strategy](docs/engineering/testing-strategy.md)

---

### 🚦 Workflow & Conventions
- Small, focused commits and PRs
- Branch naming: `feature/`, `fix/`, `docs/`, `refactor/`, `test/`, `chore/`
- Semantic commit messages (e.g., `feat: add transaction form`)
- Update docs as needed with code changes
- See [Development Workflow](docs/engineering/development-workflow.md)

---

### 📝 Contribution
- See [CONTRIBUTING.md](CONTRIBUTING.md) for how to contribute
- Align major changes via issues/discussions first

---

### ⚠️ Common Pitfalls
- Do not mix business logic in widgets
- Avoid large, monolithic BLoCs
- Keep domain entities framework-agnostic
- Do not reuse storage models as domain entities

---

### 📎 Useful Links
- [Design System & Handoff](docs/design/design-system.md)
- [Screen Specs](docs/design/screen-specs.md)
- [Backlog Overview](docs/product/backlog-overview.md)

---

For further details, always refer to the linked documentation above. If a convention or decision is unclear, check the docs or propose an update to this file.
