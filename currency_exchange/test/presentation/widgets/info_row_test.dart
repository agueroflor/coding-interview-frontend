import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:currency_exchange/presentation/widgets/widgets.dart';
import 'package:currency_exchange/core/constants/app_text_styles.dart';

void main() {
  group('InfoRow', () {
    testWidgets('renders label and value correctly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: InfoRow(
              label: 'Tasa estimada',
              value: '25.00 VES',
            ),
          ),
        ),
      );

      expect(find.text('Tasa estimada'), findsOneWidget);
      expect(find.byType(RichText), findsNWidgets(2));
    });

    testWidgets('parses value with approximate sign correctly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: InfoRow(
              label: 'Tasa estimada',
              value: '≈ 25.00 VES',
            ),
          ),
        ),
      );

      final richTextWidgets = tester.widgetList<RichText>(find.byType(RichText));
      final valueRichText = richTextWidgets.elementAt(1);
      final textSpan = valueRichText.text as TextSpan;

      expect(textSpan.children, isNotNull);
      expect(textSpan.children!.length, greaterThanOrEqualTo(2));

      // Verificar que el signo está 
      final firstSpan = textSpan.children![0] as TextSpan;
      expect(firstSpan.text, contains('≈'));
    });

    testWidgets('parses value with number and unit correctly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: InfoRow(
              label: 'Recibirás',
              value: '≈ 1,234.56 USDT',
            ),
          ),
        ),
      );

      final richTextWidgets = tester.widgetList<RichText>(find.byType(RichText));
      final valueRichText = richTextWidgets.elementAt(1);
      final textSpan = valueRichText.text as TextSpan;

      expect(textSpan.children, isNotNull);
      expect(textSpan.children!.length, 3); // signo, numero, moneda

      final numberSpan = textSpan.children![1] as TextSpan;
      expect(numberSpan.text, '1,234.56');

      final unitSpan = textSpan.children![2] as TextSpan;
      expect(unitSpan.text, contains('USDT'));
    });

    testWidgets('handles value without approximate sign', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: InfoRow(
              label: 'Tiempo estimado',
              value: '10 Min',
            ),
          ),
        ),
      );

      final richTextWidgets = tester.widgetList<RichText>(find.byType(RichText));
      final valueRichText = richTextWidgets.elementAt(1);
      final textSpan = valueRichText.text as TextSpan;

      expect(textSpan.children, isNotNull);
      expect(textSpan.children!.length, 2); // numero y moneda (sin signo)

      final numberSpan = textSpan.children![0] as TextSpan;
      expect(numberSpan.text, '10');

      final unitSpan = textSpan.children![1] as TextSpan;
      expect(unitSpan.text, contains('Min'));
    });

    testWidgets('handles simple numeric value', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: InfoRow(
              label: 'Amount',
              value: '100.00',
            ),
          ),
        ),
      );

      final richTextWidgets = tester.widgetList<RichText>(find.byType(RichText));
      final valueRichText = richTextWidgets.elementAt(1);
      final textSpan = valueRichText.text as TextSpan;

      expect(textSpan.children, isNotNull);
      final numberSpan = textSpan.children![0] as TextSpan;
      expect(numberSpan.text, '100.00');
    });

    testWidgets('has correct spacing between label and value', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: InfoRow(
              label: 'Test Label',
              value: '100',
            ),
          ),
        ),
      );

      final row = tester.widget<Row>(find.byType(Row));
      expect(row.mainAxisAlignment, MainAxisAlignment.spaceBetween);
    });

    testWidgets('label has correct text style', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: InfoRow(
              label: 'Test Label',
              value: '100',
            ),
          ),
        ),
      );

      final labelText = tester.widget<Text>(find.text('Test Label'));
      expect(labelText.style, AppTextStyles.infoLabel);
    });

    testWidgets('handles value with commas in number', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: InfoRow(
              label: 'Large Amount',
              value: '≈ 10,000,000.00 VES',
            ),
          ),
        ),
      );

      final richTextWidgets = tester.widgetList<RichText>(find.byType(RichText));
      // el segundo RichText es el valor (el primero es el label)
      final valueRichText = richTextWidgets.elementAt(1);
      final textSpan = valueRichText.text as TextSpan;

      final numberSpan = textSpan.children![1] as TextSpan;
      expect(numberSpan.text, '10,000,000.00');
    });

    testWidgets('handles edge case with only unit', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: InfoRow(
              label: 'Status',
              value: 'N/A',
            ),
          ),
        ),
      );

      expect(find.text('Status'), findsOneWidget);
      // hay 2 RichText widgets (uno para el label, uno para el valor)
      expect(find.byType(RichText), findsNWidgets(2));
    });
  });
}
