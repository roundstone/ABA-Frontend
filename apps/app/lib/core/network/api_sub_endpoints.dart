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
  String paystackVerify(String reference) => '$_base/paystack/$reference/verify';
}
