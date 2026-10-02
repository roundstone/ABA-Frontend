# Gap Analysis: Client Feedback vs. Current Specification

Based on the recent client feedback recording, here is a mapping of the client's stated requirements against the current project documentation (Specs 1–5). This highlights the features and flows that are currently missing from the spec and need to be built out on the frontend and backend.

## 1. Round-Robin Commission for Unattributed Sales
**Client Feedback:**
> "Then somebody just randomly finds the platform and purchases. Now the system will automatically allocate a percentage of that sale to any of those first-line people... round-robinning this allocation across those on that first line."

**Current Spec Status:**
- The current spec (`ABA-ERP-04-Referrals-Reporting-Admin.md` §1.8) explicitly handles invalid codes by allowing users to "Continue without a code".
- However, there is **no logic** defined for assigning organic/unattributed signups or purchases to a "first-line" promoter pool.

**What is left to build:**
- **Backend/Logic:** Implement a pool of "first-line" chief promoters (e.g., Roundstone, Mr. Andrew) and a round-robin algorithm to auto-assign unattributed purchases/signups to them.
- **Notification Flow:** Add an email/in-app notification template for auto-assigned commissions stating: *"Congratulations on your new sale; your topline person that facilitated this trade is XYZ."*
- **Frontend (Admin):** Add a settings toggle to manage the "First-Line Promoters" pool and the round-robin distribution strategy.

## 2. Vendor Promotion & Spotlighting
**Client Feedback:**
> "...promote the vendors across the system... maybe do some spotlighting on a person, what they are doing, how they are doing it, that kind of stuff that is just different from the regular random e-commerce platform."

**Current Spec Status:**
- The spec defines Merchants/Suppliers purely as data entities in the ERP (Orders, Inventory, Payables).
- There is no mention of public-facing vendor spotlighting, profile stories, or enhanced storefront visibility for vendors.

**What is left to build:**
- **Frontend (Storefront):** Build dedicated "Spotlight" or "Featured Vendor" sections on the customer-facing storefront homepage and categories.
- **Frontend (Storefront):** Build rich Vendor Profile pages where vendors can display their story ("what they are doing, how they are doing it").
- **Frontend (ERP Admin):** Build tools for the Admin to flag a Merchant as "Spotlighted" or "Featured" and add rich editorial content (bio, photos, interviews) to their profile.

## 3. Top-Performing Promoters Spotlighting
**Client Feedback:**
> "...maybe even top-performing promoters on the platform—show what they have sold and how much they have made to encourage other people to also want to be a part of this."

**Current Spec Status:**
- The portal has personal dashboard stats (Earnings, My Network) for referrers (`ABA-ERP-03` & `ABA-ERP-04`).
- However, there is no public or network-wide leaderboard visible to *other* promoters.

**What is left to build:**
- **Frontend (Portal):** Add a "Leaderboard" or "Top Earners Spotlight" page in the Referrer Portal showing top promoters, total sales volume, and commissions earned (with appropriate privacy opt-ins).
- **Frontend (Storefront):** Add promotional banners/sections highlighting the MLM opportunity ("See how much our top promoters are making").

## 4. WhatsApp Integration for Operations
**Client Feedback:**
> "...we also need to have some kind of WhatsApp integration. The reason being that when purchases are made, I think it will be important that there is a way to be able to disseminate to make sure that we are getting the products quickly."

**Current Spec Status:**
- The spec (`ABA-ERP-04` §6) mentions "SMS/email providers" and "WhatsApp share links" (for referral codes), but does not explicitly outline automated operational WhatsApp messaging for order fulfillment.

**What is left to build:**
- **Backend/Logic:** Integrate a WhatsApp Business API provider (e.g., Twilio, Meta) into the notification engine.
- **Frontend (Settings):** Add WhatsApp configuration to the "Integrations" and "Notifications" settings.
- **Workflow:** Implement automated WhatsApp alerts triggered on order creation ("Purchase made") sent directly to the vendor/merchant to ensure quick fulfillment, as well as status updates to the customer.

## Next Steps
To recalibrate the project vision, we need to:
1. Update `ABA-ERP-04` and `ABA-ERP-05` to include the **Round-Robin Commission Algorithm** and **WhatsApp operational notifications**.
2. Design and implement the **Storefront UI enhancements** (Vendor Spotlights, Promoter Leaderboards) to ensure the platform feels like a community-driven marketplace rather than a standard e-commerce site.
