I'd go with a feature-first layered architecture, pragmatic rather than textbook clean architecture, using Riverpod for state.

## Core stack

| Concern | Choice | Why |
|---|---|---|
| State management | **Riverpod** (`flutter_riverpod`, with `riverpod_generator` if you like codegen) | Compile-safe DI, easy to override repositories in tests, and swapping mock for real is a one-line provider override |
| Routing | **go_router** | Declarative, deep links, and `redirect` guards make role-based routing straightforward |
| Networking | **Dio** + interceptors | Auth token attach/refresh, logging, and error mapping in one place |
| Models | **freezed + json_serializable** | Immutable entities and DTOs with less boilerplate |
| Secure storage | `flutter_secure_storage` | Tokens only |
| Local cache / offline | **Drift** (SQLite) | Your data is relational (orders, referral tree, ledger), and POS needs an offline queue |
| Errors | A small `Result`/`Failure` type (or `fpdart` `Either`) | UI handles typed failures, never raw exceptions |

## Structure

```
lib/
  core/
    config/        # env, flavors (dev/staging/prod), constants
    network/       # dio client, interceptors, api exceptions
    storage/       # secure storage, drift db
    theme/         # tokens extracted from the web app
    routing/       # go_router, role guards
    widgets/       # shared: StatusBadge, EmptyState, SkeletonList, AppButton, MoneyText
    utils/         # NGN formatter, validators, debouncer
  features/
    auth/
    catalog/       # products, search, categories
    cart_checkout/
    orders/
    referral/      # code, network tree, share
    commission/    # ledger, earnings, payouts
    merchant_pos/
    merchant_products/
    admin_approvals/   # only if admin is in mobile scope
    notifications/
    profile/
      presentation/   # screens, widgets
      application/    # Riverpod notifiers/controllers
      domain/         # entities, repository interface, pure logic
      data/           # repository impl, remote + mock data sources, DTOs
```

## The decisions that matter most

**1. The repository interface is your swap point.** Each feature defines `abstract class OrdersRepository` in `domain/`. The `data/` layer has `OrdersRemoteDataSource` (Dio) and `OrdersMockDataSource`. One provider chooses which to inject, driven by a flag in the flavor config. When the NestJS API lands, you change the flag and fix DTO mismatches, and no UI or controller code is touched. Build the Dio client and DTOs now against the shapes you expect, so the real integration is mostly verification.

**2. Keep business logic out of widgets, and put referral and commission resolution in `domain/` as pure functions.** The mock engine mirrors the one in `apps/web`. It is disposable once the backend owns this, but pure functions are easy to unit test now and easy to delete later.

**3. Role-based shells, not one shared app with hidden buttons.** Customer, Merchant, and (if in scope) Admin each get their own `ShellRoute` with their own bottom nav and route tree. One permission map (role → permissions → routes) feeds both the guards and the nav, so they can't drift apart. Distributor isn't a separate shell, since it's a customer with an active network, so show the referral and earnings tabs conditionally.

**4. Offline-first only where it pays: the merchant POS.** Cache catalog and last dashboard data for reading. For POS sales, write to a local Drift table first, mark them `pending_sync`, and let a sync worker push them when connectivity returns. Give every sale a client-generated idempotency key so retries never double-create an order or a commission. Everything else can be online-only with clear offline states. Full offline-first everywhere is expensive and unnecessary for the MVP.

**5. Align the API contract with the NestJS backend early.** If the backend will expose Swagger/OpenAPI, generate the Dart client from the spec instead of hand-writing DTOs. Until then, keep DTOs separate from domain entities (mappers between them) so backend field changes stay contained in `data/`.

## Testing baseline

Unit tests for the referral and commission functions and for controllers, repository tests against the mock sources, widget tests for the checkout and POS flows, and `flutter analyze` in CI. The commission math is the highest-risk logic, so cover it first.