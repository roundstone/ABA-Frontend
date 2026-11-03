import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app/features/merchants/domain/merchant_entities.dart';
import 'package:app/features/merchants/presentation/merchant_detail_screen.dart';
import 'package:app/features/merchants/application/merchant_providers.dart';
import 'package:app/features/shop/domain/shop_entities.dart';

void main() {
  group('Merchant Backend Endpoint Payload Tests', () {
    final backendMerchantJson = {
      "id": 5,
      "user_id": 35,
      "commission_rule_id": null,
      "business_name": "David Enabs Demo Store",
      "business_owner_phone_number": "+2348140000002",
      "business_address": "1 Demo Commerce Avenue, Lagos",
      "business_owner_name": "David Enabs",
      "business_owner_email": "v-davidenabs@gmail.com",
      "website": null,
      "rc_tax_id": null,
      "merchant_type": 1,
      "status": 2,
      "bio": "Demo store bio",
      "verified_at": "2026-10-26T13:08:10.358Z",
      "user": {
        "id": 35,
        "first_name": "David",
        "last_name": "Enabs",
        "email": "v-davidenabs@gmail.com",
      },
      "createdAt": "2026-10-23T08:53:05.363Z",
    };

    test('Merchant.fromJson correctly parses backend payload', () {
      final merchant = Merchant.fromJson(backendMerchantJson);

      expect(merchant.id, '5');
      expect(merchant.name, 'David Enabs Demo Store');
      expect(merchant.ownerName, 'David Enabs');
      expect(merchant.phone, '+2348140000002');
      expect(merchant.email, 'v-davidenabs@gmail.com');
      expect(merchant.address, '1 Demo Commerce Avenue, Lagos');
      expect(merchant.state, 'Lagos');
      expect(merchant.isVerified, isTrue);
      expect(merchant.userId, 35);
      expect(merchant.merchantType, 1);
      expect(merchant.status, 2);
      expect(merchant.description, 'Demo store bio');
    });

    test('Merchant.toJson serializes backend fields', () {
      final merchant = Merchant.fromJson(backendMerchantJson);
      final json = merchant.toJson();

      expect(json['id'], '5');
      expect(json['name'], 'David Enabs Demo Store');
      expect(json['user_id'], 35);
      expect(json['phone'], '+2348140000002');
      expect(json['isVerified'], isTrue);
    });

    test('Merchant.fromJson safely parses payload where avatar, banner and category are Map objects', () {
      final jsonWithMediaMaps = {
        "id": 1,
        "business_name": "Demo Store Ltd",
        "business_address": "1 Demo Avenue, Lagos",
        "avatar": {
          "id": 2,
          "url": "https://s3.example.com/avatar.jpg",
          "original_name": "avatar.jpg"
        },
        "banner": {
          "id": 3,
          "url": "https://s3.example.com/banner.jpg",
          "original_name": "banner.jpg"
        },
        "category": {
          "name": "Leather Crafts"
        },
        "website": "https://demostore.test"
      };

      final merchant = Merchant.fromJson(jsonWithMediaMaps);
      expect(merchant.id, '1');
      expect(merchant.name, 'Demo Store Ltd');
      expect(merchant.logoUrl, 'https://s3.example.com/avatar.jpg');
      expect(merchant.bannerImage, 'https://s3.example.com/banner.jpg');
      expect(merchant.category, 'Leather Crafts');
      expect(merchant.website, 'https://demostore.test');
    });

    testWidgets('MerchantDetailScreen renders profile and products from provider', (tester) async {
      final sampleMerchant = Merchant.fromJson(backendMerchantJson);
      const sampleProduct = Product(
        id: '101',
        name: 'Merchant Custom Shoe',
        slug: 'merchant-custom-shoe',
        price: 25000,
        category: 'Shoes',
        brand: 'David Enabs',
        merchantId: 5,
        rating: 4.8,
        reviewCount: 12,
        stock: 10,
        images: ['https://example.com/shoe.jpg'],
        description: 'Handcrafted shoe by David Enabs',
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            merchantDetailProvider('5').overrideWith((ref) => Future.value(sampleMerchant)),
            merchantProductsProvider('5').overrideWith((ref) => Future.value([sampleProduct])),
          ],
          child: const MaterialApp(
            home: MerchantDetailScreen(merchantId: '5'),
          ),
        ),
      );

      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('David Enabs Demo Store'), findsAtLeast(1));
      expect(find.text('Owner: David Enabs'), findsOneWidget);
      expect(find.text('+2348140000002'), findsOneWidget);
      expect(find.text('Merchant Custom Shoe'), findsOneWidget);
      expect(find.text('Products by this Store'), findsOneWidget);
    });
  });
}
