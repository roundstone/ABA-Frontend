import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app/core/network/api_endpoints.dart';
import 'package:app/features/merchants/data/merchant_remote_repository.dart';
import 'package:app/features/merchants/domain/merchant_entities.dart';
import 'package:app/features/shop/data/shop_remote_repository.dart';
import 'package:app/features/shop/domain/brand.dart';

void main() {
  group('Storefront Popular Brands and Merchant Spotlight Tests', () {
    test('Brand.fromJson correctly parses popular brand payload', () {
      final json = {
        "id": 1,
        "name": "ABA Demo",
        "slug": "aba-demo",
        "isVerified": true,
        "productCount": "121",
        "orderedQuantity": "301"
      };

      final brand = Brand.fromJson(json);
      expect(brand.id, 1);
      expect(brand.name, 'ABA Demo');
      expect(brand.slug, 'aba-demo');
      expect(brand.isVerified, isTrue);
      expect(brand.productCount, 121);
      expect(brand.orderedQuantity, 301);
    });

    test('ShopRemoteRepository.fetchPopularBrands queries correct endpoint', () async {
      final dio = Dio();
      RequestOptions? captured;

      dio.interceptors.add(InterceptorsWrapper(onRequest: (opt, handler) {
        captured = opt;
        return handler.resolve(Response(
          requestOptions: opt,
          statusCode: 200,
          data: {
            "success": true,
            "data": [
              {
                "id": 1,
                "name": "ABA Demo",
                "slug": "aba-demo",
                "isVerified": true,
                "productCount": "121",
                "orderedQuantity": "301"
              }
            ]
          },
        ));
      }));

      final repo = ShopRemoteRepository(dio: dio);
      final brands = await repo.fetchPopularBrands();

      expect(brands.length, 1);
      expect(brands.first.name, 'ABA Demo');
      expect(brands.first.productCount, 121);
      expect(captured?.path, ApiEndpoints.storefront.popularBrands);
    });

    test('Merchant.fromJson correctly parses merchant spotlight payload with logo & banner', () {
      final json = {
        "id": 6,
        "businessName": "Demo Merchant Store 1",
        "website": "https://vendor-1.example.test",
        "productCount": "10",
        "logoUrl": "https://example.com/logo.png",
        "bannerImage": "https://example.com/banner.png",
      };

      final merchant = Merchant.fromJson(json);
      expect(merchant.id, '6');
      expect(merchant.name, 'Demo Merchant Store 1');
      expect(merchant.website, 'https://vendor-1.example.test');
      expect(merchant.productCount, 10);
      expect(merchant.logoUrl, 'https://example.com/logo.png');
      expect(merchant.bannerImage, 'https://example.com/banner.png');
    });

    test('MerchantRemoteRepository.getMerchantsSpotlight queries correct endpoint', () async {
      final dio = Dio();
      RequestOptions? captured;

      dio.interceptors.add(InterceptorsWrapper(onRequest: (opt, handler) {
        captured = opt;
        return handler.resolve(Response(
          requestOptions: opt,
          statusCode: 200,
          data: {
            "success": true,
            "data": [
              {
                "id": 6,
                "businessName": "Demo Merchant Store 1",
                "website": "https://vendor-1.example.test",
                "productCount": "10",
                "logoUrl": "https://example.com/logo.png",
                "bannerImage": "https://example.com/banner.png"
              }
            ]
          },
        ));
      }));

      final repo = MerchantRemoteRepository(dio);
      final merchants = await repo.getMerchantsSpotlight();

      expect(merchants.length, 1);
      expect(merchants.first.name, 'Demo Merchant Store 1');
      expect(merchants.first.productCount, 10);
      expect(merchants.first.logoUrl, 'https://example.com/logo.png');
      expect(captured?.path, ApiEndpoints.storefront.merchantsSpotlight);
    });
  });
}
