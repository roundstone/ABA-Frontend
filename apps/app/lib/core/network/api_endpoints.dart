/// Centralized API Endpoints for the ABA ERP Mobile App.
/// Base URL: https://aba-erp-backend.onrender.com
abstract final class ApiEndpoints {
  static const String baseUrl = 'https://aba-erp-backend.onrender.com';
  static const String apiV1 = '/api/v1';

  /// Returns full URL for a given relative endpoint path.
  static String url(String path) => '$baseUrl$path';

  // Endpoint Groups
  static const auth = _AuthEndpoints();
  static const users = _UsersEndpoints();
  static const referralCodes = _ReferralCodesEndpoints();
  static const roles = _RolesEndpoints();
  static const permissions = _PermissionsEndpoints();
  static const customers = _CustomersEndpoints();
  static const deliveryAddresses = _DeliveryAddressEndpoints();
  static const orders = _OrdersEndpoints();
  static const marketers = _MarketersEndpoints();
  static const productCategories = _ProductCategoriesEndpoints();
  static const products = _ProductsEndpoints();
  static const productVariants = _ProductVariantsEndpoints();
  static const media = _MediaEndpoints();
  static const vendors = _VendorsEndpoints();
  static const vendorBankAccounts = _VendorBankAccountsEndpoints();
  static const vendorLocations = _VendorLocationsEndpoints();
  static const admins = _AdminsEndpoints();
  static const superAdmins = _SuperAdminsEndpoints();
  static const dashboard = _DashboardEndpoints();
}

/// 1. Auth Endpoints
class _AuthEndpoints {
  const _AuthEndpoints();
  static const String _base = '${ApiEndpoints.apiV1}/auth';

  String get login => '$_base/login';
  String get signup => '$_base/signup';
  String get verifyEmail => '$_base/verify-email';
  String get refresh => '$_base/refresh';
  String get logout => '$_base/logout';
  String get logoutAll => '$_base/logout-all';
  String get forgotPassword => '$_base/forgot-password';
  String get resetPassword => '$_base/reset-password';
  String get me => '$_base/me';
}

/// 2. Users Endpoints
class _UsersEndpoints {
  const _UsersEndpoints();
  static const String _base = '${ApiEndpoints.apiV1}/users';

  String get base => _base;
  String byId(String id) => '$_base/$id';
}

/// 3. Referral Codes Endpoints
class _ReferralCodesEndpoints {
  const _ReferralCodesEndpoints();
  static const String _base = '${ApiEndpoints.apiV1}/referral-codes';

  String get base => _base;
  String byId(String id) => '$_base/$id';
  String status(String id) => '$_base/$id/status';
}

/// 4. Roles Endpoints
class _RolesEndpoints {
  const _RolesEndpoints();
  static const String _base = '${ApiEndpoints.apiV1}/roles';

  String get base => _base;
  String byId(String id) => '$_base/$id';
  String userRoles(String userId) => '$_base/users/$userId';
  String userRole(String userId, String roleId) => '$_base/users/$userId/$roleId';
}

/// 5. Permissions Endpoints
class _PermissionsEndpoints {
  const _PermissionsEndpoints();
  static const String _base = '${ApiEndpoints.apiV1}/permissions';

  String get base => _base;
  String byId(String id) => '$_base/$id';
}

/// 6. Customers Endpoints
class _CustomersEndpoints {
  const _CustomersEndpoints();
  static const String _base = '${ApiEndpoints.apiV1}/customers';

  String get base => _base;
  String byId(String id) => '$_base/$id';
  String status(String id) => '$_base/$id/status';
  String addresses(String customerId) => '$_base/$customerId/addresses';
  String addressById(String customerId, String addressId) =>
      '$_base/$customerId/addresses/$addressId';
  String orders(String customerId) => '$_base/$customerId/orders';
}

/// 7. Delivery Addresses Endpoints
class _DeliveryAddressEndpoints {
  const _DeliveryAddressEndpoints();
  static const String _base = '${ApiEndpoints.apiV1}/delivery-address';

  String get base => _base;
  String byId(String id) => '$_base/$id';
}

/// 8. Orders Endpoints
class _OrdersEndpoints {
  const _OrdersEndpoints();
  static const String _base = '${ApiEndpoints.apiV1}/orders';

  String get base => _base;
  String byId(String id) => '$_base/$id';
}

/// 9. Marketers Endpoints
class _MarketersEndpoints {
  const _MarketersEndpoints();
  static const String _base = '${ApiEndpoints.apiV1}/marketers';

  String get base => _base;
  String byId(String id) => '$_base/$id';
  String referralHierarchy(String id) => '$_base/$id/referral-hierarchy';
  String upline(String id) => '$_base/$id/upline';
  String downline(String id) => '$_base/$id/downline';
}

/// 10. Product Categories Endpoints
class _ProductCategoriesEndpoints {
  const _ProductCategoriesEndpoints();
  static const String _base = '${ApiEndpoints.apiV1}/product-categories';

  String get base => _base;
  String byId(String id) => '$_base/$id';
  String status(String id) => '$_base/$id/status';
}

/// 11. Products Endpoints
class _ProductsEndpoints {
  const _ProductsEndpoints();
  static const String _base = '${ApiEndpoints.apiV1}/products';

  String get base => _base;
  String get overview => '$_base/overview';
  String byId(String id) => '$_base/$id';
  String status(String id) => '$_base/$id/status';
  String variants(String productId) => '$_base/$productId/variants';
}

/// 12. Product Variants Endpoints
class _ProductVariantsEndpoints {
  const _ProductVariantsEndpoints();
  static const String _base = '${ApiEndpoints.apiV1}/product-variants';

  String get base => _base;
  String byId(String id) => '$_base/$id';
  String status(String id) => '$_base/$id/status';
}

/// 13. Media Endpoints
class _MediaEndpoints {
  const _MediaEndpoints();
  static const String _base = '${ApiEndpoints.apiV1}/media';

  String get base => _base;
  String get upload => '$_base/upload';
  String byId(String id) => '$_base/$id';
  String download(String id) => '$_base/$id/download';
}

/// 14. Vendors Endpoints
class _VendorsEndpoints {
  const _VendorsEndpoints();
  static const String _base = '${ApiEndpoints.apiV1}/vendors';

  String get base => _base;
  String byId(String id) => '$_base/$id';
  String verify(String id) => '$_base/$id/verify';
  String suspend(String id) => '$_base/$id/suspend';
  String marketers(String id) => '$_base/$id/marketers';
  String marketerStatus(String id, String marketerId) =>
      '$_base/$id/marketers/$marketerId/status';
  String marketerById(String id, String marketerId) =>
      '$_base/$id/marketers/$marketerId';
}

/// 15. Vendor Bank Accounts Endpoints
class _VendorBankAccountsEndpoints {
  const _VendorBankAccountsEndpoints();
  static const String _base = '${ApiEndpoints.apiV1}/vendor-bank-accounts';

  String get base => _base;
  String byId(String id) => '$_base/$id';
}

/// 16. Vendor Locations Endpoints
class _VendorLocationsEndpoints {
  const _VendorLocationsEndpoints();
  static const String _base = '${ApiEndpoints.apiV1}/vendor-locations';

  String get base => _base;
  String byId(String id) => '$_base/$id';
}

/// 17. Admins Endpoints
class _AdminsEndpoints {
  const _AdminsEndpoints();
  static const String _base = '${ApiEndpoints.apiV1}/admins';

  String get base => _base;
  String byId(String id) => '$_base/$id';
}

/// 18. Super Admins Endpoints
class _SuperAdminsEndpoints {
  const _SuperAdminsEndpoints();
  static const String _base = '${ApiEndpoints.apiV1}/super-admins';

  String get base => _base;
  String byId(String id) => '$_base/$id';
}

/// 19. Dashboard Endpoints
class _DashboardEndpoints {
  const _DashboardEndpoints();
  static const String _base = '${ApiEndpoints.apiV1}/dashboard';

  String get base => _base;
}
