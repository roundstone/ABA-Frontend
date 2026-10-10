import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/main.dart';

void main() {
  testWidgets('ABAApp mounts successfully smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: ABAApp()));
    expect(find.byType(ABAApp), findsOneWidget);
  });
}
