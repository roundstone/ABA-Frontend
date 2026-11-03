export 'merchant_directory_result.dart';
export 'merchant_filter_params.dart';

String _extractString(dynamic value) {
  if (value == null) return '';
  if (value is String) return value;
  if (value is Map) {
    final url = value['url'];
    if (url != null) return url.toString();
    final name = value['name'];
    if (name != null) return name.toString();
    final title = value['title'];
    if (title != null) return title.toString();
    final address = value['address'];
    if (address != null) return address.toString();
  }
  return value.toString();
}

String? _extractOptionalString(dynamic value) {
  if (value == null) return null;
  final str = _extractString(value);
  return str.isEmpty ? null : str;
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
    final businessName = _extractString(
      json['business_name'] ?? json['businessName'] ?? json['name'],
    );
    final owner = _extractString(
      json['business_owner_name'] ?? json['ownerName'] ?? json['owner'],
    );
    final phone = _extractString(
      json['business_owner_phone_number'] ??
          json['phone'] ??
          json['phoneNumber'],
    );
    final email = _extractString(
      json['business_owner_email'] ?? json['email'],
    );
    final address = _extractString(
      json['business_address'] ?? json['address'],
    );
    final rcTax = _extractString(
      json['rc_tax_id'] ??
          json['rcTaxId'] ??
          json['rcNumber'] ??
          json['merchantNo'],
    );
    final bioText = _extractString(
      json['bio'] ?? json['description'],
    );
    final statusVal = (json['status'] as num?)?.toInt();
    final verifiedAt = json['verified_at'] != null
        ? DateTime.tryParse(json['verified_at'].toString())
        : null;
    final isVerified =
        verifiedAt != null || statusVal == 2 || json['isVerified'] == true;
    final createdAt = json['createdAt'] != null
        ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
        : (json['onboardedAt'] != null
            ? DateTime.tryParse(json['onboardedAt'].toString()) ??
                DateTime.now()
            : DateTime.now());

    String state = _extractString(json['state']);
    String city = _extractString(json['city']);
    if (state.isEmpty && address.isNotEmpty) {
      final parts = address.split(',');
      if (parts.length > 1) {
        state = parts.last.trim();
        city = parts[parts.length - 2].trim();
      }
    }
    if (state.isEmpty) state = 'Lagos';
    if (city.isEmpty) city = state;

    final logo = _extractString(
      json['logoUrl'] ??
          json['logo_url'] ??
          json['logo'] ??
          json['avatarUrl'] ??
          json['avatar_url'] ??
          json['avatar'],
    );
    final banner = _extractString(
      json['bannerImage'] ??
          json['banner_image'] ??
          json['bannerUrl'] ??
          json['banner_url'] ??
          json['banner'],
    );
    final rawPc = json['productCount'] ?? json['product_count'];
    final productCount = rawPc is num
        ? rawPc.toInt()
        : int.tryParse(rawPc?.toString() ?? '') ?? 0;

    return Merchant(
      id: idStr,
      merchantNo: rcTax.isNotEmpty
          ? rcTax
          : (idStr.isNotEmpty ? 'MRC-$idStr' : ''),
      name: businessName,
      legalName: _extractString(json['legalName']).isNotEmpty
          ? _extractString(json['legalName'])
          : businessName,
      logoUrl: logo,
      bannerImage: banner,
      description: bioText,
      ownerName: owner,
      phone: phone,
      email: email,
      address: address,
      city: city,
      state: state,
      category: _extractString(json['category']).isNotEmpty
          ? _extractString(json['category'])
          : 'General',
      rating: (json['rating'] as num?)?.toDouble() ?? 4.8,
      reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
      ordersCount: (json['ordersCount'] as num?)?.toInt() ?? 0,
      productCount: productCount,
      isVerified: isVerified,
      isFeatured: json['isFeatured'] as bool? ?? false,
      onboardedAt: createdAt,
      userId: (json['user_id'] as num?)?.toInt() ??
          (json['userId'] as num?)?.toInt(),
      website: _extractOptionalString(json['website']),
      rcTaxId: rcTax.isNotEmpty ? rcTax : null,
      merchantType: (json['merchant_type'] as num?)?.toInt(),
      status: statusVal,
      bio: bioText.isNotEmpty ? bioText : null,
      verifiedAt: verifiedAt,
      user: json['user'] is Map
          ? Map<String, dynamic>.from(json['user'] as Map)
          : null,
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
