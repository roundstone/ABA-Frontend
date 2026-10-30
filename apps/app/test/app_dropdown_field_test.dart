import 'package:app/core/widgets/app_dropdown_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppDropdownField Widget Tests', () {
    testWidgets('renders label, hint and items properly', (tester) async {
      String? selected = 'B';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppDropdownField<String>(
              label: 'Test Dropdown',
              hintText: 'Select an option',
              value: selected,
              items: const [
                DropdownMenuItem(value: 'A', child: Text('Option A')),
                DropdownMenuItem(value: 'B', child: Text('Option B')),
                DropdownMenuItem(value: 'C', child: Text('Option C')),
              ],
              onChanged: (val) => selected = val,
            ),
          ),
        ),
      );

      expect(find.text('Test Dropdown'), findsOneWidget);
      expect(find.text('Option B'), findsOneWidget);
    });

    testWidgets('handles duplicate item values without throwing assertion errors', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppDropdownField<int?>(
              label: 'Duplicate Safe',
              value: null,
              items: const [
                DropdownMenuItem(value: null, child: Text('None')),
                DropdownMenuItem(value: null, child: Text('Duplicate None')),
                DropdownMenuItem(value: 1, child: Text('One')),
                DropdownMenuItem(value: 1, child: Text('Duplicate One')),
              ],
              onChanged: (_) {},
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.text('None'), findsOneWidget);
    });

    testWidgets('gracefully falls back when value does not exist in items', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppDropdownField<String>(
              label: 'Non-existent Value',
              hintText: 'Choose...',
              value: 'Z', // does not exist in items
              items: const [
                DropdownMenuItem(value: 'A', child: Text('Option A')),
                DropdownMenuItem(value: 'B', child: Text('Option B')),
              ],
              onChanged: (_) {},
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.text('Choose...'), findsOneWidget);
    });

    testWidgets('displays error text when provided', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppDropdownField<String>(
              label: 'Required Field',
              errorText: 'This field is required',
              items: [
                DropdownMenuItem(value: 'A', child: Text('Option A')),
              ],
            ),
          ),
        ),
      );

      expect(find.text('This field is required'), findsOneWidget);
    });
  });
}

