enum MerchantSort {
  recommended('Recommended'),
  rating('Highest Rated'),
  orders('Most Orders'),
  newest('Newest First');

  const MerchantSort(this.label);
  final String label;
}

class Merchant {
  const Merchant({
    required this.id,
    required this.merchantNo,
    required this.name,
    required this.legalName,
    required this.logoUrl,
    required this.bannerImage,
    required this.description,
    required this.ownerName,
    required this.phone,
    required this.email,
    required this.address,
    required this.city,
    required this.state,
    this.category = 'General',
    this.rating = 4.8,
    this.reviewCount = 0,
    this.ordersCount = 0,
    this.productCount = 0,
    this.isVerified = true,
    this.isFeatured = false,
    required this.onboardedAt,
    this.userId,
    this.website,
    this.rcTaxId,
    this.merchantType,
    this.status,
    this.bio,
    this.verifiedAt,
    this.user,
  });

  final String id;
  final String merchantNo;
  final String name;
  final String legalName;
  final String logoUrl;
  final String bannerImage;
  final String description;
  final String ownerName;
  final String phone;
  final String email;
  final String address;
  final String city;
  final String state;
  final String category;
  final double rating;
  final int reviewCount;
  final int ordersCount;
  final int productCount;
  final bool isVerified;
  final bool isFeatured;
  final DateTime onboardedAt;
  final int? userId;
  final String? website;
  final String? rcTaxId;
  final int? merchantType;
  final int? status;
  final String? bio;
  final DateTime? verifiedAt;
  final Map<String, dynamic>? user;

  int get joinedYear => onboardedAt.year;

  factory Merchant.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'];
    final idStr = rawId?.toString() ?? '';
    final businessName = json['business_name'] as String? ??
        json['businessName'] as String? ??
        json['name'] as String? ??
        '';
    final owner = json['business_owner_name'] as String? ?? json['ownerName'] as String? ?? '';
    final phone = json['business_owner_phone_number'] as String? ?? json['phone'] as String? ?? '';
    final email = json['business_owner_email'] as String? ?? json['email'] as String? ?? '';
    final address = json['business_address'] as String? ?? json['address'] as String? ?? '';
    final rcTax = json['rc_tax_id'] as String? ?? json['rcTaxId'] as String? ?? json['merchantNo'] as String? ?? '';
    final bioText = json['bio'] as String? ?? json['description'] as String? ?? '';
    final statusVal = (json['status'] as num?)?.toInt();
    final verifiedAt = json['verified_at'] != null ? DateTime.tryParse(json['verified_at'].toString()) : null;
    final isVerified = verifiedAt != null || statusVal == 2 || json['isVerified'] == true;
    final createdAt = json['createdAt'] != null
        ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
        : (json['onboardedAt'] != null ? DateTime.tryParse(json['onboardedAt'].toString()) ?? DateTime.now() : DateTime.now());

    String state = json['state'] as String? ?? '';
    String city = json['city'] as String? ?? '';
    if (state.isEmpty && address.isNotEmpty) {
      final parts = address.split(',');
      if (parts.length > 1) {
        state = parts.last.trim();
        city = parts[parts.length - 2].trim();
      }
    }
    if (state.isEmpty) state = 'Lagos';
    if (city.isEmpty) city = state;

    final logo = json['logoUrl'] as String? ??
        json['logo_url'] as String? ??
        json['logo'] as String? ??
        '';
    final banner = json['bannerImage'] as String? ??
        json['banner_image'] as String? ??
        json['banner'] as String? ??
        '';
    final rawPc = json['productCount'] ?? json['product_count'];
    final productCount = rawPc is num
        ? rawPc.toInt()
        : int.tryParse(rawPc?.toString() ?? '') ?? 0;

    return Merchant(
      id: idStr,
      merchantNo: rcTax.isNotEmpty ? rcTax : (idStr.isNotEmpty ? 'MRC-$idStr' : ''),
      name: businessName,
      legalName: json['legalName'] as String? ?? businessName,
      logoUrl: logo,
      bannerImage: banner,
      description: bioText,
      ownerName: owner,
      phone: phone,
      email: email,
      address: address,
      city: city,
      state: state,
      category: json['category'] as String? ?? 'General',
      rating: (json['rating'] as num?)?.toDouble() ?? 4.8,
      reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
      ordersCount: (json['ordersCount'] as num?)?.toInt() ?? 0,
      productCount: productCount,
      isVerified: isVerified,
      isFeatured: json['isFeatured'] as bool? ?? false,
      onboardedAt: createdAt,
      userId: (json['user_id'] as num?)?.toInt() ?? (json['userId'] as num?)?.toInt(),
      website: json['website'] as String?,
      rcTaxId: rcTax,
      merchantType: (json['merchant_type'] as num?)?.toInt(),
      status: statusVal,
      bio: bioText,
      verifiedAt: verifiedAt,
      user: json['user'] is Map ? Map<String, dynamic>.from(json['user'] as Map) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'merchantNo': merchantNo,
    'name': name,
    'legalName': legalName,
    'logoUrl': logoUrl,
    'bannerImage': bannerImage,
    'description': description,
    'ownerName': ownerName,
    'phone': phone,
    'email': email,
    'address': address,
    'city': city,
    'state': state,
    'category': category,
    'rating': rating,
    'reviewCount': reviewCount,
    'ordersCount': ordersCount,
    'isVerified': isVerified,
    'isFeatured': isFeatured,
    'onboardedAt': onboardedAt.toIso8601String(),
    if (userId != null) 'user_id': userId,
    if (website != null) 'website': website,
    if (rcTaxId != null) 'rc_tax_id': rcTaxId,
    if (merchantType != null) 'merchant_type': merchantType,
    if (status != null) 'status': status,
    if (bio != null) 'bio': bio,
    if (verifiedAt != null) 'verified_at': verifiedAt!.toIso8601String(),
    if (user != null) 'user': user,
  };
}

class MerchantFilterParams {
  const MerchantFilterParams({
    this.query = '',
    this.category = '',
    this.state = '',
    this.minRating,
    this.verifiedOnly = false,
    this.sort = MerchantSort.recommended,
  });

  final String query;
  final String category;
  final String state;
  final double? minRating;
  final bool verifiedOnly;
  final MerchantSort sort;

  bool get hasActiveFilters =>
      query.isNotEmpty ||
      category.isNotEmpty ||
      state.isNotEmpty ||
      minRating != null ||
      verifiedOnly ||
      sort != MerchantSort.recommended;

  MerchantFilterParams copyWith({
    String? query,
    String? category,
    String? state,
    double? minRating,
    bool clearRating = false,
    bool? verifiedOnly,
    MerchantSort? sort,
  }) {
    return MerchantFilterParams(
      query: query ?? this.query,
      category: category ?? this.category,
      state: state ?? this.state,
      minRating: clearRating ? null : (minRating ?? this.minRating),
      verifiedOnly: verifiedOnly ?? this.verifiedOnly,
      sort: sort ?? this.sort,
    );
  }
}

class MerchantDirectoryResult {
  const MerchantDirectoryResult({
    required this.merchants,
    required this.totalCount,
    required this.availableStates,
    required this.availableCategories,
  });

  final List<Merchant> merchants;
  final int totalCount;
  final List<String> availableStates;
  final List<String> availableCategories;
}
