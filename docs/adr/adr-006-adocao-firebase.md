# ADR-006 - Adoção do Firebase como Backend

## Status

Proposta

## Contexto

Com a evolução do FinTrack, surgiu a necessidade de autenticação real, sincronização multi-dispositivo e persistência segura dos dados do usuário. O armazenamento local limita a escalabilidade, colaboração e backup dos dados.

## Decisão

Adotar o Firebase como backend principal para:
- Autenticação de usuários (e-mail/senha, provedores sociais futuramente)
- Persistência de transações financeiras
- Sincronização de categorias e dados entre dispositivos
- Regras de segurança e isolamento por usuário

## Alternativas consideradas
- Manter apenas armazenamento local (limitado para multi-dispositivo e backup)
- Backend próprio (maior custo de manutenção e infraestrutura)

## Impactos
- Refatoração da camada de dados para integração com Firebase
- Novos fluxos de autenticação e migração de dados locais
- Novas dependências no projeto Flutter
- Necessidade de regras de segurança no Firestore

## Próximos passos
- Configurar projeto Firebase
- Implementar autenticação
- Migrar CRUD de transações para Firestore
- Documentar setup e arquitetura
- Testar fluxos e regras de segurança
