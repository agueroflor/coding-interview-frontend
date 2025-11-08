import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:currency_exchange/data/models/currency.dart';
import 'package:currency_exchange/core/constants/app_colors.dart';
import 'package:currency_exchange/presentation/widgets/widgets.dart';


void main() {
  group('AmountInputField', () {
    late Currency fiatCurrency;
    late Currency cryptoCurrency;

    setUp(() {
      fiatCurrency = const Currency(
        id: 'VES',
        name: 'Venezuelan Bolivar',
        symbol: '฿',
        iconPath: 'assets/currencies/VES.png',
        type: CurrencyType.fiat,
      );

      cryptoCurrency = const Currency(
        id: 'TATUM-TRON-USDT',
        name: 'Tether',
        symbol: 'USDT',
        iconPath: 'assets/cripto_currencies/TATUM-TRON-USDT.png',
        type: CurrencyType.crypto,
      );
    });

    testWidgets('renders with fiat currency symbol', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AmountInputField(
              currency: fiatCurrency,
              onChanged: (value) {},
            ),
          ),
        ),
      );

      expect(find.byType(AmountInputField), findsOneWidget);
      expect(find.text('VES'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('renders with crypto currency symbol', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AmountInputField(
              currency: cryptoCurrency,
              onChanged: (value) {},
            ),
          ),
        ),
      );

      expect(find.text('USDT'), findsOneWidget);
    });

    testWidgets('calls onChanged when text is entered', (tester) async {
      String? changedValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AmountInputField(
              currency: fiatCurrency,
              onChanged: (value) {
                changedValue = value;
              },
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), '100.50');
      expect(changedValue, '100.50');
    });

    testWidgets('has correct hint text', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AmountInputField(
              currency: fiatCurrency,
              onChanged: (value) {},
            ),
          ),
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.decoration?.hintText, '0.00');
    });

    testWidgets('accepts decimal numbers', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AmountInputField(
              currency: fiatCurrency,
              onChanged: (value) {},
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), '123.45');
      expect(find.text('123.45'), findsOneWidget);
    });

    testWidgets('has numeric keyboard type', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AmountInputField(
              currency: fiatCurrency,
              onChanged: (value) {},
            ),
          ),
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(
        textField.keyboardType,
        const TextInputType.numberWithOptions(decimal: true),
      );
    });

    testWidgets('has correct input formatters', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AmountInputField(
              currency: fiatCurrency,
              onChanged: (value) {},
            ),
          ),
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.inputFormatters, isNotEmpty);
      expect(textField.inputFormatters?.first, isA<FilteringTextInputFormatter>());
    });

    testWidgets('has yellow border', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AmountInputField(
              currency: fiatCurrency,
              onChanged: (value) {},
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.ancestor(
          of: find.byType(TextField),
          matching: find.byType(Container),
        ).first,
      );

      final decoration = container.decoration as BoxDecoration;
      final border = decoration.border as Border;
      expect(border.top.color, AppColors.primaryYellow);
      expect(border.top.width, 1);
    });

    testWidgets('has rounded corners', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AmountInputField(
              currency: fiatCurrency,
              onChanged: (value) {},
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.ancestor(
          of: find.byType(TextField),
          matching: find.byType(Container),
        ).first,
      );

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.borderRadius, BorderRadius.circular(12));
    });
  });
}
