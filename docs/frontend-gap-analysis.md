# Frontend Gap Analysis

## 1. What Exists and is Reusable
The current application is a converted HTML-to-Next.js e-commerce template. It has a rich set of UI components (buttons, forms, modals, tables, layout headers/footers) and standard e-commerce pages (Home, Shop, Product Details, Cart, Checkout, Login, Register). 
**Reusable:**
- Core UI components (Buttons, Inputs, Modals, Breadcrumbs).
- The fundamental layout structure (Headers, Footers).
- The shopping cart and checkout flows (with modifications for referral capture).
- The user account dashboard layout (needs restructuring for roles).
- The vendor dashboard layout (can be repurposed for the Merchant role).

## 2. Page Disposition Table

| Current Path | Action | Reason |
| --- | --- | --- |
| `/` (Home) | **Keep / Modify** | Will serve as the public storefront entry. |
| `/shop` | **Keep / Modify** | Core e-commerce functionality. |
| `/collection` | **Merge into `/shop`** | Redundant. One consolidated shop view is sufficient. |
| `/product/[slug]` | **Keep / Modify** | Required for the storefront. |
| `/cart` | **Keep / Modify** | Required for the storefront. |
| `/checkout` | **Keep / Modify** | Required. Needs to support referral code application. |
| `/order-success` | **Keep** | Required for storefront flow. |
| `/compare` | **Remove** | Out of scope / unnecessary complexity for MVP. |
| `/lookbook` | **Remove** | Marketing fluff, not needed for an ERP. |
| `/login` | **Move to `(auth)/login`** | Requires auth route group and role-based redirect. |
| `/register` | **Move to `(auth)/register`** | Requires referral code capture and auto-generation logic. |
| `/forgot-password` | **Move to `(auth)/forgot-password`** | Standard auth flow. |
| `/account/*` | **Move to `(dashboard)/*`** | Account area will become the role-based App Shell for all logged-in users. |
| `/vendor-dashboard` | **Merge into `(dashboard)/merchant`** | Forms the basis of the Merchant POS and dashboard. |
| `/vendor/*` | **Remove / Merge** | Duplicate merchant pages. |
| `/about`, `/contact`, `/faq` | **Keep (Minimal)** | Basic informational pages for the public site. |
| `/blog`, `/blog/[slug]` | **Remove** | Out of scope for MVP. |
| `/portfolio` | **Remove** | Irrelevant for manufacturing ERP. |
| `/sitemap` | **Remove** | SEO not a priority for authenticated application MVP. |
| `/review` | **Remove** | Out of scope for MVP. |
| `/coming-soon` | **Remove** | Unnecessary. |
| `/invoice` | **Modify / Reusable Component** | Convert into a reusable Receipt component for POS and Orders. |

## 3. Final Sitemap by Role and Per-Role Navigation

### App Shell Route Groups:
- `(public)`: `/`, `/shop`, `/product/[slug]`, `/cart`, `/checkout`, `/order-success`
- `(auth)`: `/login`, `/register`, `/forgot-password`
- `(dashboard)`: The authenticated application shell.

### Per-Role Navigation in `(dashboard)`:
**Customer / Distributor:**
- Profile & Settings
- Order History & Tracking
- Referral Network (Upline/Downline view)
- Commission Earnings

**Merchant:**
- Merchant Dashboard (KPIs)
- POS Interface
- Offline Sales History
- Inventory Allocation

**Sales User:**
- Customer Management
- Order Management
- Merchant Activity

**Finance User:**
- Commission Ledger (Pending, Approved, Paid)
- Payout Batches
- Receivables & Payables Overview

**Admin:**
- Platform Configuration
- Commission Policy Rules
- Activity Log & Audit
- Network Overview

## 4. Flows to Change and New Flows
- **Signup Flow:** Needs to optionally accept a `referralCode` during registration. A unique referral code (e.g., `ABA-10245-SHOE`) must be automatically generated for the new user.
- **Checkout Flow:** Needs to allow input of a referral code (if the user wasn't already referred at signup) and link the generated order to the upline for commission calculation.
- **POS Flow (New):** A merchant-specific interface to select products, capture customer details, apply referral codes, and record offline payments, generating a receipt.
- **Commission Flow (New):** Automated resolution of upline chain on order confirmation, writing to a ledger. Admin approval of payouts.

## 5. Content to Add, Remove, or Replace
- **Remove:** All "Lorem Ipsum", fake blog posts, portfolio items, heavy decorative sliders, and oversized hero images.
- **Replace:** Mock products with realistic "Shoe" data and Nigerian currency (NGN) formatting.
- **Add:** Realistic seeded data for a multi-level referral network (using Nigerian names) to test the commission engine.

## 6. Component Inventory
- **Reuse:** Data tables, forms, status badges, empty-states, layout wrappers (Header/Footer for public, Sidebar for dashboard).
- **Create:** 
  - `RoleSwitcher` (Dev-only)
  - `NetworkTree` (Visualizing upline/downline)
  - `CommissionLedgerTable`
  - `POSInterface`

## 7. Missing Functionality
- Full mock data layer (Referrals, Commissions, Orders).
- Role-based Route Guards.
- Commission calculation engine logic.
- POS terminal logic.
