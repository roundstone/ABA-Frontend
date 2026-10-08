# Spotlight Build Plan

## 1. Types, Schemas, Mocks
Module: `features/spotlight`
- `types.ts`: `SpotlightSettings` (mode, scoreWeights, eligibilityThresholds, refreshInterval, pinnedMerchants), `SpotlightMerchant` (for the frontend to consume, includes banner/logo, name, location, rating, orderCount, topProducts), `CategorySpotlight`.
- `schemas.ts`: validation schemas for settings.
- `api.ts`: endpoints to get shop spotlight, category spotlight, get admin settings, update settings, run refresh.
- `queries.ts`, `mutations.ts` for frontend integration.

## 2. Admin UI
- `app/(erp)/erp/admin/spotlight/page.tsx`: The admin control panel.
- Shows fields for slots, modes, score weights, eligibility thresholds, refresh interval.
- Allows managing pinned list (manual mode).
- Refresh now button, live preview button, history log.

## 3. Storefront UI
- `components/SpotlightSection.tsx` inside `features/spotlight/components/`. Renders the featured merchants on the shop landing.
- `components/SpotlightCard.tsx` - hover/focus quick buy logic.
- `app/(storefront)/page.tsx` - Inject `SpotlightSection`.
- `MegaMenu.tsx` - Replace promo banner with category star vendors.

## 4. Analytics
- Add simple `console.log` wrapped in a mock analytics function `trackSpotlightEvent`.
