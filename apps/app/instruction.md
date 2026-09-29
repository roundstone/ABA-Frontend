- Explicit decision on admin: state plainly whether admin functionality is mobile-in-scope or web-only for this MVP, and why, based on the requirements' role/permission model and the work plan's build sequence. Do not build mobile admin screens on an assumption.
- Navigation architecture per role (bottom nav vs. drawer vs. tabs) and the reasoning.
- Gap list: requirements functionality with no current web equivalent, and how it will be represented on mobile.
- Open questions.

Do not proceed to implementation until this document is written. Then proceed without waiting for confirmation, unless something is genuinely blocking.

## Screen inventory (determine the real list from the docs + web app; the items below are prompts to investigate, not a final spec)

**Customer:** onboarding/splash, login, register (with referral code capture), forgot password, home/dashboard, product listing, product detail, cart, checkout, order confirmation, order history, order detail/tracking, my referral network (upline/downline, share code/link), my earnings/commission ledger, wishlist, profile, addresses, notifications, settings.

**Merchant:** login, dashboard (sales summary, pending orders, trending products — translated to mobile cards/carousels, not a desktop table dump), POS flow (select product, quantity, capture customer, apply referral code, payment method, complete sale, receipt), products, product detail, add/edit product, orders, order detail, customers, sales/analytics, store profile, notifications.

**Admin:** determine from the requirements + apps/web what admin covers (user/role management, commission policy config, referral network oversight, order management, payout approval, audit log). Decide mobile scope per the Phase 0 rule above — a trimmed "oversight and approvals on the go" admin experience is a reasonable outcome if full admin stays web-only.

Every screen needs its states: loading (skeleton, not spinner-only where content has shape), empty, error, and permission-denied where relevant.

## Mobile UX requirements
- Bottom navigation for primary role sections; drawer only for secondary/rarely-used items.
- Mobile app bars, bottom sheets for quick actions/filters, mobile-native forms with correct keyboard types and proper scroll-into-view on focus.
- Cards/lists instead of desktop tables for merchant and admin data; a table view is acceptable only where genuinely tabular and short.
- Pull-to-refresh on list/dashboard screens.
- Debounced, mobile-friendly search; filters in bottom sheets, not inline desktop filter bars.
- Proper touch target sizes (44x44 minimum), safe-area handling, and support for both iOS and Android navigation conventions.
- Offline/poor-connectivity awareness: cached last-good data where reasonable, clear "you're offline" states — this matters given the merchant POS use case and Nigerian connectivity conditions the requirements call out.

## Architecture
- Clean, layered Flutter architecture: `presentation` (screens/widgets), `application` (state/controllers), `domain` (entities, repository interfaces, use cases), `data` (repository implementations, data sources, DTOs/mappers).
- State management: Riverpod (or Bloc if that's your team's existing convention — pick one and apply it consistently; note the choice and why in the blueprint).
- Networking: Dio, fully wired (base client, interceptors for auth/logging/error handling, typed API service classes) but pointed at mock data sources for now via a repository interface, so swapping to live endpoints later is a one-line change per repository, not a rewrite.
- Domain models mirror the entities implied by the requirements docs (User/Role, Product, Order, ReferralRelationship, CommissionLedgerEntry, PayoutBatch, Merchant, POSTransaction, etc.) and should stay consistent with whatever shape apps/web already mocks, so the future backend contract lines up across web and mobile.
- Routing: go_router (or equivalent) with role-based route guards mirroring the web app's role/permission model.
- Feature-first folder structure: `lib/features/<feature>/{presentation,application,domain,data}`, plus `lib/core/` for theme, networking, routing, shared widgets, utils.

## Mock data strategy
- Seed realistic mock data matching the web app's mocks where they exist (same product names, same sample referral network, same statuses) so both apps feel like one product during demos.
- Mock data lives behind repository interfaces in the `data` layer only — no business logic or mock data inside widgets.
- Commission/referral resolution logic implemented as pure, testable functions in `domain`, mirroring the web app's mock logic, clearly marked as temporary until the real backend exists.

## Code standards
- No file over 250 lines; split widgets, controllers, and repositories accordingly.
- One widget/class per file, consistent naming, no dead code, no hard-coded copy or data inside widgets (strings via a constants/theme layer or at minimum grouped, not scattered).
- Null-safety strict, no unnecessary `dynamic`.
- Passes `flutter analyze` with zero issues.

## Definition of done
- docs/mobile-blueprint.md exists and was followed.
- Every role's screen inventory is implemented with all required states.
- Web → Flutter mapping table is complete and accurate to what was actually built.
- Branding, terminology, and business logic are consistent with apps/web.
- `flutter analyze` and a full build pass; 250-line check returns nothing.
- Final summary: screens built per role, architecture/state-management choice and why, admin mobile-scope decision and why, gap list resolved, and open questions.