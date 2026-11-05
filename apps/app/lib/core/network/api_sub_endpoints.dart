import 'api_endpoints.dart';

/// 15. Vendor Bank Accounts Endpoints
class VendorBankAccountsEndpoints {
  const VendorBankAccountsEndpoints();
  static const String _base = '${ApiEndpoints.apiV1}/vendor-bank-accounts';
  String get base => _base;
  String byId(String id) => '$_base/$id';
}

/// 16. Vendor Locations Endpoints
class VendorLocationsEndpoints {
  const VendorLocationsEndpoints();
  static const String _base = '${ApiEndpoints.apiV1}/vendor-locations';
  String get base => _base;
  String byId(String id) => '$_base/$id';
}

/// 17. Admins & Super Admins Endpoints
class AdminsEndpoints {
  const AdminsEndpoints();
  static const String _base = '${ApiEndpoints.apiV1}/admins';
  String get base => _base;
  String byId(String id) => '$_base/$id';
}

class SuperAdminsEndpoints {
  const SuperAdminsEndpoints();
  static const String _base = '${ApiEndpoints.apiV1}/super-admins';
  String get base => _base;
  String byId(String id) => '$_base/$id';
}

/// 19. Dashboard & Storefront Endpoints
class DashboardEndpoints {
  const DashboardEndpoints();
  String get base => '${ApiEndpoints.apiV1}/dashboard';
}

class StorefrontEndpoints {
  const StorefrontEndpoints();
  static const String _base = '${ApiEndpoints.apiV1}/storefront';
  String get featuredProducts => '$_base/mobile-app/featured-products';
  String get trendingProducts => '$_base/mobile-app/trending-products';
  String get popularBrands => '$_base/popular-brands';
  String get merchantsSpotlight => '$_base/merchants-spotlight';
}

/// 21. Reviews Endpoints
class ReviewsEndpoints {
  const ReviewsEndpoints();
  static const String _base = '${ApiEndpoints.apiV1}/reviews';
  String get base => _base;
  String byId(String id) => '$_base/$id';
}

/// 22. Brands Endpoints
class BrandsEndpoints {
  const BrandsEndpoints();
  static const String _base = '${ApiEndpoints.apiV1}/brands';
  String get base => _base;
  String byId(String id) => '$_base/$id';
}

/// 23. Mobile App Cart Endpoints
class CartEndpoints {
  const CartEndpoints();
  static const String _base = '${ApiEndpoints.apiV1}/cart/mobile-app';
  String get base => _base;
  String get me => '$_base/me';
  String get availability => '$_base/availability';
  String get items => '$_base/items';
  String item(dynamic itemId) => '$_base/items/$itemId';
}

/// 24. Mobile App Payments Endpoints
class PaymentsEndpoints {
  const PaymentsEndpoints();
  static const String _base = '${ApiEndpoints.apiV1}/payments/mobile-app';
  String get base => _base;
  String paystackInitialize(dynamic orderId) =>
      '$_base/orders/$orderId/paystack/initialize';
  String paystackVerify(String reference) => '$_base/paystack/$reference/verify';
  String get kycActivationPaystackInitialize =>
      '${ApiEndpoints.apiV1}/payments/kyc-activation/paystack/initialize';
}

/// 25. Mobile App KYC Endpoints
class KycEndpoints {
  const KycEndpoints();
  static const String _base = '${ApiEndpoints.apiV1}/kyc';
  String get activationSubmission => '$_base/activation-submission';
  String get profile => '$_base/mobile-app/profile';
  String get submitProfile => '$_base/mobile-app/profile/submit';
  String get documents => '$_base/mobile-app/documents';
}

/// 25. Mobile App Profile Endpoints
class ProfileEndpoints {
  const ProfileEndpoints();
  static const String _base = '${ApiEndpoints.apiV1}/profile/mobile-app';
  String get base => _base;
}

/// 26. Mobile App Wishlists Endpoints
class WishlistsEndpoints {
  const WishlistsEndpoints();
  static const String _base = '${ApiEndpoints.apiV1}/wishlists/mobile-app';
  String get base => _base;
  String byId(dynamic id) => '$_base/$id';
}

/// 27. Mobile App Payouts & Withdrawals Endpoints
class PayoutsEndpoints {
  const PayoutsEndpoints();
  static const String _base = '${ApiEndpoints.apiV1}/payouts/mobile-app';
  String get base => _base;
  String get withdrawals => '$_base/withdrawals';
  String get me => '$_base/me';
  String byId(dynamic id) => '$_base/$id';
}

/// 28. Mobile App User Bank Accounts Endpoints
class UserBankAccountsEndpoints {
  const UserBankAccountsEndpoints();
  static const String _base =
      '${ApiEndpoints.apiV1}/user-bank-accounts/mobile-app';
  String get base => _base;
  String get banks => '$_base/banks';
  String byId(dynamic id) => '$_base/$id';
}

/// 29. Order Invoices Endpoints
class InvoicesEndpoints {
  const InvoicesEndpoints();
  static const String _base = '${ApiEndpoints.apiV1}/invoices/orders';
  String byOrderId(dynamic orderId) => '$_base/$orderId';
  String downloadByOrderId(dynamic orderId) => '$_base/$orderId/download';
}

/// 30. Shopping Credits Endpoints
class ShoppingCreditsEndpoints {
  const ShoppingCreditsEndpoints();
  static const String _base = '${ApiEndpoints.apiV1}/shopping-credits';
  String get base => _base;
  String get me => '$_base/me';
}

/// 31. Commissions Endpoints
class CommissionsEndpoints {
  const CommissionsEndpoints();
  static const String _base = '${ApiEndpoints.apiV1}/commissions/mobile-app';
  String get base => _base;
  String get overview => '$_base/overview';
}
