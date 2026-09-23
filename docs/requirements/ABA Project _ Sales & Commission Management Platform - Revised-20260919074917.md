# ABA Project | Sales & Commission Management Platform - Revised

# Manufacturing ERP, Sales, Referral & Commission Management Platform
## 1\. Overview
The system provides an integrated **manufacturing ERP, sales, merchant, referral and commission management platform** for a shoe manufacturing company.
The platform is intended to manage the manufacturer's operational cycle from the purchase of raw materials through production, inventory, sales, customer relationships, referrals, commissions and financial reporting.
A customer purchases a product. That customer can refer other people to purchase. Each referred purchase generates a commission for the referrer, and the referred person can go on to refer further buyers of their own. Repeating this creates a network of **uplines** and **downlines** several levels deep.
Alongside this customer-facing model, the manufacturer requires visibility into:
1. **Procurement:** What materials are required, from which suppliers, at what cost, and when?
2. **Production:** What is being manufactured, which materials are being consumed, and what is the production status?
3. **Inventory:** What raw materials and finished products are currently available?
4. **Merchant & POS Management:** Which merchants are selling products and what offline sales are taking place?
5. **Sales & Customer Management:** Who is purchasing, through which channel, and what demand patterns are emerging?
6. **Network & Referral Tracking:** Who referred whom, and what does the resulting upline/downline structure look like?
7. **Commission Engine:** Given a qualifying purchase, who gets paid, how much, and when?
8. **Finance & Accounting:** What has been spent, what is owed, what is receivable, and what accounting entries should be generated?
9. **Analytics & Intelligence:** What does historical activity indicate about demand, production requirements, cost and business performance?
These capabilities should operate as connected modules while retaining clear separation between operational records, financial records and commission calculations.
* * *
## 2\. Goals
The system should:
*   Register and manage customers, distributors, merchants, suppliers and internal users.
*   Maintain a central product and material catalogue.
*   Track raw material procurement and supplier transactions.
*   Track production activities from raw material allocation to finished goods.
*   Track raw material, work-in-progress and finished-product inventory.
*   Record product sales from digital and offline channels.
*   Provide merchants with a corresponding POS interface for offline transactions.
*   Capture referral relationships at signup or purchase.
*   Maintain an accurate upline/downline hierarchy.
*   Calculate commissions across configurable referral levels.
*   Track commission status from pending through payout or reversal.
*   Track operational costs associated with procurement and production.
*   Track accounts payable and accounts receivable.
*   Generate accounting entries from relevant operational transactions.
*   Provide demand, sales, production and financial analytics.
*   Provide management dashboards across the entire business.
*   Maintain auditable records for operational, financial and commission transactions.
* * *
## 3\. Non-Goals for the Initial Version (MVP)
The first version will not attempt to:
*   Support an unlimited number of commission levels.
*   Fully automate bank or wallet commission payouts unless a payment provider is selected.
*   Provide advanced real-time fraud detection for referral abuse.
*   Replace specialist enterprise-grade accounting software where statutory or highly specialised accounting functions are required.
*   Implement autonomous AI-based procurement or production decisions without human review.
*   Support complex industrial manufacturing processes that are not part of the client's confirmed production workflow.
The system should prioritise **visibility, traceability and workflow automation** before introducing autonomous decision-making.
Commission, costing and accounting logic must remain deterministic, configurable and auditable.
* * *
# 4\. High-Level Architecture

```gherkin
                            ERP PLATFORM
                                 |
       +-------------------------+-------------------------+
       |                         |                         |
       v                         v                         v
 PROCUREMENT                PRODUCTION               SALES / POS
       |                         |                         |
       v                         v                         v
 SUPPLIERS                INVENTORY / STOCK             ORDERS
       |                         |                         |
       +-------------------------+-------------------------+
                                 |
                                 v
                         CUSTOMER / MERCHANT
                                 |
                    +------------+------------+
                    |                         |
                    v                         v
              REFERRAL SERVICE         COMMISSION ENGINE
                    |                         |
                    +------------+------------+
                                 |
                                 v
                         FINANCE & ACCOUNTING
                                 |
                                 v
                     REPORTING & ANALYTICS
```

Operational modules should share common entities such as products, materials, orders, suppliers, customers and financial transactions so information does not need to be entered repeatedly.
* * *
# 5\. Core Concepts
### Raw Material
Any material purchased and consumed during manufacturing.
Examples may include leather, soles, fabric, adhesive, packaging materials and branding materials.
### Supplier
An external party supplying raw materials, services or production inputs.
### Production Order
A record authorising the manufacture of a specified quantity of a product.
### Bill of Materials
The expected materials and quantities required to manufacture a specific product.
### Finished Goods
Products that have completed production and are available for sale.
### Merchant
A business or individual authorised to sell products through an offline or merchant-specific sales channel.
### POS Transaction
A sale recorded through a merchant's point-of-sale interface.
### Referral
A relationship between a referrer and a referred customer.
### Upline
Every user above a given user within the referral hierarchy.
### Downline
Every user below a given user within the referral hierarchy.
### Accounts Payable
Amounts owed by the manufacturer to suppliers or other parties.
### Accounts Receivable
Amounts owed to the manufacturer by customers, merchants or other parties.
* * *
# 6\. User Types & Roles
Indicative roles — to be confirmed with the client:

```sql
CUSTOMER             - purchases products and refers others
DISTRIBUTOR          - customer with an active referral network
MERCHANT             - sells products through POS or merchant sales channels
SALES USER           - manages customers, orders and merchant activity
PROCUREMENT USER     - manages suppliers and purchases
PRODUCTION USER      - manages manufacturing activity
STORE / INVENTORY    - manages materials and finished goods
FINANCE USER         - manages costs, payable, receivable and accounting
ADMIN                - manages platform configuration and policies
MANAGEMENT           - business-wide reporting and analytics
SUPPORT              - controlled read access to operational records
```

Role permissions should be configurable.
* * *
# 7\. End-to-End Business Workflow

```gherkin
RAW MATERIAL REQUIREMENT
       |
       v
PROCUREMENT REQUEST
       |
       v
PURCHASE / SUPPLIER ORDER
       |
       v
RAW MATERIAL RECEIVED
       |
       v
RAW MATERIAL INVENTORY
       |
       v
PRODUCTION ORDER
       |
       v
MATERIAL ISSUED TO PRODUCTION
       |
       v
MANUFACTURING / BRANDING / PACKAGING
       |
       v
FINISHED GOODS INVENTORY
       |
       v
SALE
   +---+----------------+
   |                    |
   v                    v
ONLINE / DIRECT      MERCHANT POS
   |                    |
   +---------+----------+
             |
             v
         CUSTOMER
             |
             v
     REFERRAL RESOLUTION
             |
             v
     COMMISSION ENGINE
             |
             v
 FINANCE / ACCOUNTING
             |
             v
 ANALYTICS & REPORTING
```

The purpose of this workflow is to allow management to trace a product from its manufacturing inputs through to its final sale and financial outcome.
* * *
# 8\. Procurement Management
The procurement module should support:
*   Supplier management.
*   Purchase requisitions.
*   Purchase orders.
*   Raw material purchases.
*   Expected delivery dates.
*   Goods received.
*   Purchase cost tracking.
*   Supplier invoices.
*   Supplier payment status.
*   Purchase approval workflows.
*   Procurement history.
A procurement transaction should connect directly to inventory and finance.
* * *
# 9\. Supplier Management
Each supplier should maintain a queryable record containing:

```css
Supplier Name
Supplier Category
Materials Supplied
Contact Details
Payment Terms
Outstanding Payable
Historical Purchases
Average Purchase Cost
Delivery Performance
Status
```

This allows the business to understand both supplier relationships and their financial impact.
* * *
# 10\. Procurement Workflow

```gherkin
MATERIAL REQUIREMENT
       |
       v
PURCHASE REQUISITION
       |
       v
APPROVAL
       |
       v
PURCHASE ORDER
       |
       v
SUPPLIER DELIVERY
       |
       v
GOODS RECEIVED
       |
       +--------------------+
       |                    |
       v                    v
INVENTORY UPDATED     PAYABLE CREATED
                            |
                            v
                     SUPPLIER PAYMENT
```

* * *
# 11\. Inventory Management
Inventory should distinguish between:

```scss
RAW MATERIAL
WORK IN PROGRESS
FINISHED GOODS
```

The platform should track:
*   Opening stock.
*   Purchases.
*   Materials issued to production.
*   Production returns.
*   Finished goods received.
*   Sales.
*   Merchant stock allocations.
*   Damaged or rejected stock.
*   Manual adjustments.
*   Closing stock.
Every stock movement should retain its source transaction.
* * *
# 12\. Production Management
Production should be treated as a core part of the system rather than an external process.
The production module should support:
*   Production planning.
*   Production orders.
*   Material requirements.
*   Material allocation.
*   Manufacturing stages.
*   Branding and packaging stages where applicable.
*   Work-in-progress tracking.
*   Quantity produced.
*   Rejects and wastage.
*   Production completion.
*   Finished goods transfer to inventory.
*   Production cost calculation.
* * *
# 13\. Production Order — Example

```json
{
  "productionOrderId": "prod_2026_0042",
  "productId": "prd_SNKR_042",
  "plannedQuantity": 500,
  "completedQuantity": 420,
  "rejectedQuantity": 12,
  "status": "IN_PROGRESS",
  "plannedStartDate": "2026-08-20",
  "plannedCompletionDate": "2026-08-28"
}
```

Production orders should remain linked to all material issues and resulting finished goods.
* * *
# 14\. Production Statuses

```swift
PLANNED
APPROVED
MATERIAL_ALLOCATED
IN_PROGRESS
QUALITY_CHECK
PACKAGING
COMPLETED
CANCELLED
```

Exact stages should be configurable around the manufacturer's confirmed production process.
* * *
# 15\. Production Cost Tracking
The system should be capable of associating costs with each production batch.
Indicative cost components:

```sql
Raw Material Cost
Packaging Cost
Branding Cost
Direct Labour Cost
Production Overhead
External Service Cost
Wastage Cost
```

This should allow the manufacturer to calculate an indicative **cost per unit**.

```diff
Total Production Cost
--------------------- = Cost Per Unit
Finished Units
```

* * *
# 16\. Merchant Management
The platform should maintain merchants as distinct operational entities.
Merchant information may include:
*   Merchant profile.
*   Assigned location.
*   Product allocation.
*   Sales history.
*   Current stock.
*   Receivables.
*   Returns.
*   POS activity.
*   Merchant performance.
* * *
# 17\. Merchant POS
Each merchant should have access to a corresponding POS interface for offline sales.
The POS should allow the merchant to:

```sql
Select Product
Select Quantity
Capture Customer
Apply Referral Code where applicable
Record Payment Method
Complete Sale
Generate Receipt
Update Stock
Synchronise Sale with Central ERP
```

Where connectivity is unreliable, offline transaction capture with later synchronisation may be considered depending on technical requirements.
* * *
# 18\. Sales & Order Management
Sales may originate from multiple channels:

```plain
DIRECT SALE
ONLINE SALE
MERCHANT POS
DISTRIBUTOR SALE
ADMIN-RECORDED SALE
```

Every sale should ultimately create a standard order record so downstream inventory, commission, finance and reporting processes operate consistently.
* * *
# 19\. Purchase & Referral Workflow

```gherkin
CUSTOMER SIGNUP
   |
   v
REFERRAL CODE CAPTURE (optional)
   |
   v
REFERRAL RELATIONSHIP CREATED
   |
   v
PRODUCT PURCHASE
   |
   v
ORDER VALIDATION
   |
   v
UPLINE CHAIN RESOLUTION
   |
   v
COMMISSION ELIGIBILITY CHECK
   |
   v
COMMISSION CALCULATION
   |
   v
COMMISSION LEDGER ENTRY
```

### Order Statuses

```swift
PENDING
CONFIRMED
FULFILLED
CANCELLED
REFUNDED
```

Commissions should only be finalised once an order reaches the configured commission-eligible state.
* * *
# 20\. Referral Relationship Model
Every referral relationship should remain an explicit, queryable record.

```json
{
  "id": "ref_01K3C9RX38VN4K",
  "referrerId": "usr_10245",
  "referredId": "usr_10391",
  "referralCode": "ABA-10245-SHOE",
  "channel": "LINK",
  "createdAt": "2026-06-12T09:41:00Z",
  "status": "ACTIVE"
}
```

Referral relationships should not be reconstructed from purchase history.
* * *
# 21\. Network Hierarchy

```gherkin
              Amaka
                |
       +--------+--------+
       |                 |
     Chidi             Bola
       |                 |
   +---+---+           Tunde
   |       |             |
 Ngozi    Femi         Ifeoma
```

If Ifeoma purchases a product:
*   Tunde represents Level 1.
*   Bola represents Level 2.
*   Amaka represents Level 3.
Applicable commission policy determines which levels receive commission.
* * *
# 22\. Commission Structure Types

```plain
FLAT_DIRECT

MULTI_LEVEL

TIERED_BY_VOLUME
```

The commission structure should remain configurable rather than hard-coded.
* * *
# 23\. Commission Calculation Engine
For each qualifying purchase, the engine should:
1. Resolve the purchaser's upline chain.
2. Retrieve the active commission policy.
3. Determine eligible levels.
4. Apply product or user overrides.
5. Calculate commission amounts.
6. Write individual commission ledger entries.
7. Associate each commission with the originating sale.
The original commission-engine principle should remain unchanged: referral logic and commission calculations stay independently auditable.
* * *
# 24\. Commission Ledger & Payout

```gherkin
COMMISSION GENERATED
       |
       v
PENDING
       |
       v
APPROVED
       |
       v
PAYOUT BATCH
       |
       v
PAID
```

Refunds or invalid transactions should support commission reversal.
* * *
# 25\. Finance & Accounting
The finance module should consolidate financial consequences generated across the ERP.
Indicative transactions include:

```plain
Supplier Purchase
Supplier Payment
Customer Sale
Merchant Sale
Customer Payment
Merchant Payment
Commission Liability
Commission Payment
Production Cost
Operating Expense
Stock Adjustment
Refund
```

Rather than relying entirely on manual accounting entries, operational transactions should be capable of creating corresponding accounting records.
* * *
# 26\. Intelligent Accounting Entries
Transaction rules should determine which accounting entries are generated.
Example:

```yaml
RAW MATERIAL PURCHASE

Debit:   Raw Material Inventory
Credit:  Accounts Payable
```

Supplier payment:

```yaml
Debit:   Accounts Payable
Credit:  Cash / Bank
```

Product sale:

```yaml
Debit:   Cash / Receivable
Credit:  Sales Revenue
```

The exact chart of accounts and accounting treatment must be confirmed with the client's finance team.
Any automated entry should remain traceable to the original transaction that generated it.
* * *
# 27\. Accounts Payable
The platform should track:
*   Supplier invoices.
*   Amount owed.
*   Due dates.
*   Payment status.
*   Partial payments.
*   Overdue amounts.
*   Supplier balances.
Management should be able to identify upcoming cash obligations from the dashboard.
* * *
# 28\. Accounts Receivable
Receivables may arise from merchants, distributors or customers purchasing on approved payment terms.
The system should track:
*   Invoice amount.
*   Amount received.
*   Outstanding balance.
*   Due date.
*   Payment status.
*   Age of receivable.
This should allow management to understand both expected revenue and overdue collections.
* * *
# 29\. Expense & Cost Management
The platform should record expenses beyond direct procurement.
Indicative categories:

```plain
Raw Materials
Production
Branding
Packaging
Transport
Marketing
Merchant Expenses
Administration
Utilities
Other Operating Costs
```

Expenses should support categorisation, documentation, approval and financial reporting.
* * *
# 30\. Demand Analytics
Demand analytics should combine historical information from:
*   Customer purchases.
*   Merchant POS transactions.
*   Product performance.
*   Geographic sales.
*   Time periods.
*   Distributor activity.
*   Inventory movement.
The platform should provide insights such as:

```cs
Fastest-moving products
Slow-moving products
Demand by location
Demand by merchant
Sales trends
Seasonal patterns
Stock-out frequency
Products approaching low stock
```

* * *
# 31\. Production Intelligence
The production side should progressively use business data to support better operational decisions.
Indicative insights:
*   Products with increasing demand.
*   Production quantities compared with sales.
*   Material usage versus expected usage.
*   Production wastage trends.
*   Products with unusually high production costs.
*   Material shortages likely to affect production.
*   Finished goods that are overstocked or understocked.
*   Supplier cost movements.
*   Production cycle time.
The system should initially provide **decision-support insights**, rather than automatically making production decisions.
* * *
# 32\. Demand-to-Production Planning
One of the longer-term objectives should be connecting demand information directly to production planning.

```gherkin
SALES HISTORY
     +
CURRENT ORDERS
     +
MERCHANT SALES
     +
CURRENT INVENTORY
     |
     v
DEMAND ANALYSIS
     |
     v
PRODUCTION REQUIREMENT
     |
     v
MATERIAL REQUIREMENT
     |
     v
PROCUREMENT REQUIREMENT
```

This provides a foundation for progressively making manufacturing processes more intelligent.
* * *
# 33\. Reports & Dashboard
The management dashboard should provide, at minimum:
### Sales

```cs
Company-wide sales
Sales by product
Sales by merchant
Sales by location
Sales by channel
```

### Production

```sql
Active production orders
Units produced
Production completion rate
Wastage
Cost per production batch
```

### Procurement

```sql
Open purchase orders
Raw material expenditure
Supplier balances
Material price changes
```

### Inventory

```plain
Raw material stock
Finished goods stock
Low-stock items
Inventory movement
Stock valuation
```

### Finance

```css
Revenue
Expenses
Accounts payable
Accounts receivable
Commission liability
Cash-flow visibility
```

### Referral & Commission

```bash
Network growth
Top distributors
Commission liability
Commission payout history
Individual upline/downline view
```

### Demand

```plain
Product demand
Merchant demand
Location demand
Fast-moving products
Slow-moving products
Demand trends
```

* * *
# 34\. Audit & Traceability
Transactions that affect stock, production, finance or commissions should maintain a complete audit trail.
The system should record:

```sql
Who performed the action
What changed
Previous value
New value
Timestamp
Source transaction
Approval information where applicable
```

No critical operational or financial transaction should be silently overwritten.
* * *
# 35\. Proposed Backend Architecture
A modular monolith remains sufficient for the initial version. Microservices should only be introduced where scale or operational requirements justify them.
Suggested NestJS modules:

```css
src/

auth/

user/

customer/

merchant/
  merchant.service
  merchant-pos.service

supplier/
  supplier.service

procurement/
  requisition.service
  purchase-order.service
  goods-received.service

inventory/
  inventory.service
  stock-movement.service

production/
  production-order.service
  material-requirement.service
  production-cost.service

sales/
  order.service
  product-catalog.service

referral/
  referral.service
  network-graph.service

commission/
  commission.service
  commission-calculator.service

payout/
  payout.service
  payout-batch.service

finance/
  payable.service
  receivable.service
  expense.service

accounting/
  journal.service
  accounting-rule.service

analytics/
  demand-analytics.service
  production-analytics.service

reporting/
  reporting.service
  dashboard.controller

risk/
  network-integrity.service

audit/
  audit.service
```

* * *
# 36\. Authentication and API Security
Authentication should support role-based access to each operational area.

```haskell
Company
   |
   +-- Admin Users
   +-- Procurement Users
   +-- Production Users
   +-- Inventory Users
   +-- Finance Users
   +-- Merchants
   +-- Distributors
   +-- Customers
```

Sensitive operations should require appropriate permissions.
These include:
*   Procurement approval.
*   Inventory adjustment.
*   Production completion.
*   Commission policy changes.
*   Payout approval.
*   Accounting adjustments.
*   Supplier payments.
Such actions should remain fully auditable.
* * *
# 37\. Information Still Required From Client
The client will need to confirm:
### Manufacturing
*   Full production process from raw materials to finished shoes.
*   Production stages currently used.
*   Whether production happens at one or multiple locations.
*   How branding and packaging fit into production.
*   Expected method for capturing labour and production overhead.
*   Existing method for tracking production quantities and wastage.
### Procurement
*   Types of raw materials purchased.
*   Current supplier-management process.
*   Procurement approval process.
*   Purchase-order workflow.
*   Supplier payment terms.
### Inventory
*   Existing warehouses or stores.
*   Inventory locations.
*   Stock units of measure.
*   Finished-goods distribution process.
*   Merchant stock-allocation process.
### Merchants & POS
*   Who qualifies as a merchant.
*   Whether merchants hold company-owned stock or purchase stock.
*   Whether merchant POS needs offline capability.
*   Payment methods accepted.
*   Whether merchants sell on credit.
*   Whether referrals should work on POS transactions.
### Sales & Referral
*   Commission percentages.
*   Number of referral levels.
*   Rules for earning commission.
*   Whether repeat purchases generate commission.
*   Distributor tiers, if applicable.
*   Payout frequency.
*   Payout mechanism.
### Finance
*   Existing accounting process.
*   Chart of accounts.
*   Payment approval process.
*   Treatment of supplier invoices.
*   Merchant/customer credit arrangements.
*   Accounts receivable process.
*   Expense categories.
*   Required financial reports.
### Analytics
*   Key management KPIs.
*   Demand forecasting expectations.
*   Production planning requirements.
*   Reports currently prepared manually.
*   Frequency of management reporting.
### Integrations
*   Payment providers.
*   Existing accounting systems.
*   Existing POS systems.
*   SMS/email providers.
*   Bank integrations.
*   Existing customer database.
*   Barcode or inventory hardware.
*   Any existing manufacturing or ERP systems.
* * *