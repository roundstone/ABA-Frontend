# ABA ERP Mobile Blueprint

## 1. Executive Summary & Mobile Strategy

This document outlines the architectural, design, and implementation plan for the ABA ERP mobile application. The mobile app serves as the native counterpart to the existing web application, focusing on the roles that benefit most from a mobile form factor: **Customers** and **Merchants**.

### Admin Scope Decision

**Decision:** Admin functionality will be **WEB-ONLY** for this MVP.
**Rationale:** The requirements (ABA_ERP_Pre-Kickoff_Design & Work Plan) detail heavy operational modules for Admin: Procurement, Production, Inventory Management, Commission Policy Configuration, and Finance. These are data-dense, table-heavy, complex operational tasks best suited for a desktop web environment. Building these for a mobile interface would incur massive development overhead with very low ROI for the initial launch. We will focus mobile efforts entirely on the Customer and Merchant experiences where mobile accessibility (on-the-go purchasing, POS offline sales) is a hard requirement.

## 2. Design System Extraction (Flutter Theme Tokens)

Extracted from `apps/web/src/styles/utils/_variables.scss` and web branding.

### ColorScheme

```dart
const ColorScheme abaColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFFEC8951), // --theme-color
  onPrimary: Colors.white,
  secondary: Color(0xFF13C9CA),
  onSecondary: Colors.white,
  error: Color(0xFFFF4C3B),
  onError: Colors.white,
  surface: Colors.white,
  onSurface: Color(0xFF333333),
  background: Color(0xFFF8F8F9), // light-color
  onBackground: Color(0xFF222222), // dark-font
);
```

### Typography (TextTheme)

The primary font is **Montserrat**.

```dart
TextTheme abaTextTheme = GoogleFonts.montserratTextTheme().copyWith(
  displayLarge: TextStyle(color: Color(0xFF222222), fontWeight: FontWeight.bold),
  bodyLarge: TextStyle(color: Color(0xFF333333)),
  bodyMedium: TextStyle(color: Color(0xFF777777)), // grey font
);
```

### Component Styles

- **Cards/Containers:** Rounded corners (`BorderRadius.circular(12)`), subtle shadows (`Color(0xFFEDEDED)`).
- **Buttons:** Minimum touch target `48x48`, pill or rounded-rect shape.
- **Inputs:** Form background `#F5F2F2`, rounded borders, clear error states.

## 3. Role-by-Role Screen Inventory & Navigation

### Architecture

- **Customers:** Bottom Navigation Bar (Home, Shop, Cart, Account).
- **Merchants:** Bottom Navigation Bar (Dashboard, POS, Orders, Menu/More).

### Screen Inventory

#### Customer

- **Auth:** Splash, Login, Register (w/ Referral Code), Forgot Password.
- **Shop:** Home/Dashboard (Trending, Categories), Product Listing, Product Detail.
- **Checkout:** Cart, Checkout (Shipping, Payment, Referral apply), Order Success.
- **Account:** Profile, Addresses, Orders (History & Detail).
- **Network & Earnings:** My Network (Upline/Downline visualizer), Earnings/Ledger (Commission history).

#### Merchant

- **Auth:** Login.
- **Dashboard:** Sales Summary, Pending Orders (Cards/Carousels, NOT tables).
- **POS Flow (Critical):** Select Product -> Qty -> Capture Customer -> Referral Code -> Payment -> Receipt -> Sync.
- **Management:** Merchant Orders, Merchant Products, Customers, Earnings.

## 4. Web → Flutter Route Mapping

| Web Route             | Flutter Route (`go_router`) | Role              | Notes                  |
| --------------------- | --------------------------- | ----------------- | ---------------------- |
| `/`                   | `/home`                     | Public / Customer | Main storefront        |
| `/login`              | `/login`                    | Public            | Shared auth gate       |
| `/shop`               | `/shop`                     | Customer          | Product listing        |
| `/product/:id`        | `/product/:id`              | Customer          | Product detail         |
| `/cart`               | `/cart`                     | Customer          | Local cart state       |
| `/checkout`           | `/checkout`                 | Customer          | Checkout flow          |
| `/account/dashboard`  | `/account`                  | Customer          | Account hub            |
| `/account/orders`     | `/account/orders`           | Customer          | Order history          |
| `/account/network`    | `/account/network`          | Customer          | Upline/Downline tree   |
| `/account/earning`    | `/account/earnings`         | Customer          | Commission ledger      |
| `/merchant/dashboard` | `/merchant`                 | Merchant          | Dashboard              |
| `/merchant/pos`       | `/merchant/pos`             | Merchant          | POS transactional flow |
| `/merchant/orders`    | `/merchant/orders`          | Merchant          | Merchant orders        |

## 5. Technical Architecture

- **Structure:** Feature-first layered architecture.
  `lib/features/<feature_name>/{presentation, application, domain, data}`
- **State Management:** **Riverpod** (Provides robust dependency injection, caching, and state predictability).
- **Networking:** **Dio** (Interceptors for auth, offline-caching, and global error handling).
- **Routing:** **GoRouter** (Deep linking, role-based route guards).
- **Offline Support:** The Merchant POS requires offline capabilities. We will use a local database (e.g., Isar or SQLite/Drift) to cache products and queue POS transactions when offline, syncing via Dio interceptors upon reconnection.

## 6. Gap List & Mobile Nuances

1. **Offline POS (Requirement vs Web Gap):** The web app relies on connectivity. The mobile app MUST support an offline queue for Merchant POS to satisfy the requirements (Nigerian connectivity conditions).
2. **Table UI translation:** Web admin/merchant tables (e.g., Commission Ledgers, Orders) will be translated into expandable list view cards with filter bottom-sheets.

## 7. Implementation Phase Plan

**Phase 1: Foundation & Auth (Days 1-3)**

- Setup Riverpod, GoRouter, Dio.
- Implement Design System (Theme, Colors, Typography).
- Build shared widgets (Buttons, Inputs, Loaders).
- Implement Login & Registration flows.

**Phase 2: Customer Core (Days 4-7)**

- Product browsing, Home Dashboard.
- Cart state management.
- Checkout flow (including Referral capture).

**Phase 3: Network & Commissions (Days 8-10)**

- Customer Account area.
- Referral Network visualizer (Upline/Downline).
- Commission Ledger (Earnings view).

**Phase 4: Merchant POS (Days 11-15)**

- Merchant Dashboard.
- POS Flow (Offline-first architecture for cart and sync).
- Merchant Orders & Earnings.

## 8. Open Questions

- **Referral Code Capture:** Does the referral code get attached to the _User_ at registration, or to the _Order_ at checkout, or both? (Assuming both based on docs, but needs backend confirmation).
- **Payment Gateway:** What payment gateways are expected for the checkout/POS? For MVP, we will mock the payment success state.
