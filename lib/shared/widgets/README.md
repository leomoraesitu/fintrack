# Shared Widgets (Legacy Adapters)

Esta pasta agora contém apenas **adapters de compatibilidade** para componentes antigos.

## Convenção

- Novos componentes reutilizáveis de UI devem ser criados em `lib/design_system/widgets/`.
- Features devem importar componentes via barrel:
  - `package:fintrack/design_system/widgets/widgets.dart`
- Arquivos em `lib/shared/widgets/` estão marcados como `@Deprecated` e só existem para evitar quebra de compatibilidade durante migração.

## Mapeamento legado -> DS

- `CategoryChip` -> `FtCategoryChip`
- `FilterChipWidget1` -> `FtFilterChip`
- `FilterChipWidget2` -> `FtFilterChip`
- `NavItemWidget` -> `FtNavItem`
- `SectionHeaderWidget` -> `FtSectionHeader`
- `SkeletonItemWidget` -> `FtSkeletonItem`
- `SocialLoginButtonWidget` -> `FtSocialLoginButton`
- `EmptyStateWidget` -> `FtEmptyState` (+ `FtButton` opcional)
- `ErrorCardWidget` -> `FtErrorState`
- `StatCard1`/`StatCard2`/`StatCard3` -> `FtStatCard`
- `TransactionItem1`/`TransactionItem2`/`TransactionRowWidget`/`TransactionCardWidget` -> `FtTransactionListItem`
