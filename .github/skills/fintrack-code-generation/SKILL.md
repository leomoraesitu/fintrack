---

name: fintrack-code-generation

description: This skill defines a reusable workflow for generating code in the FinTrack repository, following project conventions and quality standards.

---

## Purpose
Automate and standardize code generation for features, widgets, and layers in the FinTrack Flutter project, ensuring alignment with architecture, naming, and testing practices.

---

## Workflow
1. **Clarify Requirements**
   - Confirm feature, widget, or layer to generate (e.g., Cubit, Bloc, Repository, Widget).
   - Identify target location in `lib/` (e.g., `features/`, `shared/`, `core/`).
   - Gather any specific requirements (e.g., parameters, UI states, dependencies).

2. **Select Template**
   - Choose or adapt a template matching the requested artifact (see [project structure](../../docs/engineering/project-structure.md)).
   - Ensure naming and folder conventions are followed.

3. **Generate Code**
   - Scaffold files in the correct layer (presentation/domain/data).
   - Add stubs for tests in `test/` mirroring `lib/` structure.
   - Insert TODOs for any manual steps or business logic.

4. **Integrate and Register**
   - Update imports, exports, or registries as needed.
   - Add to navigation, DI, or feature lists if required.

5. **Quality Checks**
   - Run `dart format` and `dart analyze`.
   - Ensure code passes static analysis and follows [coding standards](../../docs/engineering/coding-standards.md).
   - Add or update tests to cover generated code.

6. **Document**
   - Update or create README/docs if the new code introduces new patterns or APIs.

---

## Decision Points
- If unclear on requirements, prompt for clarification before generating code.
- If a template does not exist, scaffold a minimal version and note gaps.
- If code generation affects navigation, DI, or state management, update relevant files.

---

## Completion Criteria
- Code is generated in the correct location, following project structure and naming.
- All generated code passes formatting and analysis.
- Tests are created or updated.
- Documentation is updated if needed.

---

## Example Prompts
- "Generate a Cubit for transaction filtering."
- "Add a new widget for category chips in shared/widgets."
- "Scaffold a repository for user preferences."

---

## Related Customizations
- fintrack-test-writing
- fintrack-widget-template
- fintrack-bloc-scaffolding

---

See [agent-customization guidelines](../agent-customization/skills.md) for best practices.
