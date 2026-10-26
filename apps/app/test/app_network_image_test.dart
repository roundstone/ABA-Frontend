import 'package:app/core/widgets/app_network_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hugeicons/hugeicons.dart';

void main() {
  group('AppNetworkImage Tests', () {
    testWidgets('renders product fallback icon when imageUrl is null',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppNetworkImage(
              imageUrl: null,
              fallbackType: AppImageFallbackType.product,
            ),
          ),
        ),
      );

      expect(find.byType(HugeIcon), findsOneWidget);
      expect(find.byType(CachedNetworkImage), findsNothing);
    });

    testWidgets('renders fallback icon when imageUrl is empty or whitespace',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppNetworkImage(
              imageUrl: '   ',
              fallbackType: AppImageFallbackType.generic,
            ),
          ),
        ),
      );

      expect(find.byType(HugeIcon), findsOneWidget);
      expect(find.byType(CachedNetworkImage), findsNothing);
    });

    testWidgets('renders fallback icon when imageUrl is not a valid http URL',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppNetworkImage(
              imageUrl: 'not-a-valid-url',
              fallbackType: AppImageFallbackType.merchant,
            ),
          ),
        ),
      );

      expect(find.byType(HugeIcon), findsOneWidget);
      expect(find.byType(CachedNetworkImage), findsNothing);
    });

    testWidgets('renders avatar initials when name is provided and image is null',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppNetworkImage.avatar(
              imageUrl: null,
              name: 'Nnamdi Azikiwe',
              size: 50,
            ),
          ),
        ),
      );

      expect(find.text('NA'), findsOneWidget);
      expect(find.byType(ClipOval), findsOneWidget);
    });

    testWidgets('renders avatar icon when name is null and image is null',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppNetworkImage.avatar(
              imageUrl: null,
              size: 40,
            ),
          ),
        ),
      );

      expect(find.byType(HugeIcon), findsOneWidget);
      expect(find.byType(ClipOval), findsOneWidget);
    });

    testWidgets('applies ClipRRect when borderRadius is specified',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppNetworkImage(
              imageUrl: null,
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ),
        ),
      );

      expect(find.byType(ClipRRect), findsOneWidget);
    });

    testWidgets('CachedNetworkImage is instantiated for valid https URL',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppNetworkImage(
              imageUrl: 'https://example.com/image.png',
              width: 100,
              height: 100,
            ),
          ),
        ),
      );

      expect(find.byType(CachedNetworkImage), findsOneWidget);
    });
  });
}
