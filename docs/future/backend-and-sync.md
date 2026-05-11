# Backend e sincronizacao

## Status

Parte do backend foi iniciada na Sprint 5. Este documento permanece como referencia para evolucao de sincronizacao e cenarios multi-dispositivo.

## Objetivo

Registrar a direcao prevista para evoluir autenticacao real, persistencia remota e sincronizacao entre dispositivos.

## Possiveis motivadores

- necessidade de multiusuario
- sincronizacao entre dispositivos
- backup remoto dos dados
- autenticacao real

## Base ja implementada

- Firebase inicializado no app.
- Login/cadastro por e-mail e senha via Firebase Auth.
- Transacoes de usuarios autenticados persistidas no Firestore.
- Listagem de transacoes autenticadas sincronizada por stream do Firestore.
- Migracao explicita de transacoes locais para Firestore apos login/cadastro real.
- Modo demo preservado com armazenamento local.
- Regras Firestore isolando `users/{userId}/transactions`.
- Atualizacao remota com deteccao de conflito por `updatedAt`, retornando erro explicito quando a mesma transacao foi alterada em outro dispositivo.
- Formulario de transacao com banner para recarregar a versao remota apos conflito, resumir as diferencas relevantes, reaplicar a edicao local e fechar a tela quando o registro nao existir mais no backend.

## Perguntas que precisam ser respondidas antes da implementacao

- qual sera a estrategia de sincronizacao e resolucao de conflito
- como tratar conflitos quando a mesma transacao for editada em mais de um dispositivo
- como comunicar ao usuario diferencas entre modo demo e conta real

## Limite atual

Ha sincronizacao basica em tempo real para a listagem de transacoes autenticadas. Quando ocorre edicao concorrente, o app bloqueia a sobrescrita silenciosa, permite recarregar a versao mais recente da transacao, resume as diferencas detectadas, reaplica o rascunho local quando o usuario desejar e orienta o fechamento da tela se o registro tiver sido removido no backend. Ainda nao existe conciliacao avancada entre versoes. O app persiste transacoes remotas por usuario autenticado, enquanto o modo demo segue local.
