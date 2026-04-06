# Padroes de codigo

## Objetivo

Registrar convencoes de clean code e organizacao para manter o projeto legivel, previsivel e facil de evoluir.

## Principios obrigatorios

- cada classe deve ter uma responsabilidade clara
- regra de negocio nao deve ficar em widgets
- BLoCs e Cubits nao devem falar diretamente com infraestrutura sem uma camada intermediaria adequada
- nomes devem explicar intencao, nao implementacao
- codigo novo deve preferir simplicidade e clareza a abstrações prematuras

## Convencoes praticas

### Widgets

- widgets de tela devem coordenar layout e interacao, nao regras centrais de negocio
- extrair widgets menores quando a leitura da tela ficar densa
- preferir composicao a widgets gigantes com multiplas responsabilidades

### BLoC e Cubit

- usar Cubit para estados locais e simples
- usar Bloc para fluxos com eventos distintos, validacoes e efeitos assincronos
- eventos devem expressar intencao do usuario ou do sistema
- estados devem refletir a verdade atual da interface
- evitar estados modelados apenas por varios booleanos soltos

### Dominio

- entidades nao devem depender de classes de Flutter
- casos de uso devem ser pequenos e focados
- contratos de repositorio devem viver no dominio

### Dados

- modelos de armazenamento nao devem ser reutilizados como entidades de dominio por conveniencia
- mapear explicitamente entre dados e dominio
- isolar detalhes do datasource

## Nomeacao recomendada

- `CreateTransactionUseCase`
- `TransactionRepository`
- `TransactionFormBloc`
- `TransactionFormEvent`
- `TransactionFormState`

Evitar nomes genericos como:

- `Helper`
- `Manager`
- `UtilsBloc`
- `DataService`

## Erros e validacoes

- tratar falhas previsiveis como parte do fluxo
- diferenciar estado vazio de erro
- usar mensagens claras para o usuario e nomenclatura tecnica clara no codigo

## Refatoracao continua

Ao alterar uma area do projeto:

- remover codigo morto
- reduzir duplicacoes pequenas quando encontradas
- manter imports e arquivos coerentes com a estrutura definida
- evitar misturar refatoracoes extensas com entregas de feature sem necessidade
