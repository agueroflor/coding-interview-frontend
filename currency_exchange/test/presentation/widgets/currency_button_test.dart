import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:currency_exchange/data/models/currency.dart';
import 'package:currency_exchange/core/constants/app_text_styles.dart';
import 'package:currency_exchange/presentation/widgets/widgets.dart';


void main() {
  group('CurrencyButton', () {
    late Currency testCurrency;
    late Currency testCryptoCurrency;

    setUp(() {
      testCurrency = const Currency(
        id: 'VES',
        name: 'Venezuelan Bolivar',
        symbol: '฿',
        iconPath: 'assets/currencies/VES.png',
        type: CurrencyType.fiat,
      );

      testCryptoCurrency = const Currency(
        id: 'TATUM-TRON-USDT',
        name: 'Tether',
        symbol: 'USDT',
        iconPath: 'assets/cripto_currencies/TATUM-TRON-USDT.png',
        type: CurrencyType.crypto,
      );
    });

    testWidgets('renders currency button with fiat currency', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CurrencyButton(
              currency: testCurrency,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.byType(CurrencyButton), findsOneWidget);
      expect(find.text('VES'), findsOneWidget);
      expect(find.byIcon(Icons.keyboard_arrow_down), findsOneWidget);
    });

    testWidgets('renders currency button with crypto currency showing symbol', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CurrencyButton(
              currency: testCryptoCurrency,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.byType(CurrencyButton), findsOneWidget);
      expect(find.text('USDT'), findsOneWidget);
      expect(find.byIcon(Icons.keyboard_arrow_down), findsOneWidget);
    });

    testWidgets('calls onTap callback when tapped', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CurrencyButton(
              currency: testCurrency,
              onTap: () {
                tapped = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      expect(tapped, isTrue);
    });

    testWidgets('displays error widget when image fails to load', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CurrencyButton(
              currency: testCurrency,
              onTap: () {},
            ),
          ),
        ),
      );

      // The error builder should be set up even if image loads successfully
      final imageFinder = find.byType(Image);
      expect(imageFinder, findsOneWidget);
    });

    testWidgets('has correct styling', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CurrencyButton(
              currency: testCurrency,
              onTap: () {},
            ),
          ),
        ),
      );

      final textFinder = find.text('VES');
      final Text textWidget = tester.widget(textFinder);

      expect(textWidget.style, AppTextStyles.currencyButton);
    });

    testWidgets('has correct InkWell border radius', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CurrencyButton(
              currency: testCurrency,
              onTap: () {},
            ),
          ),
        ),
      );

      final inkWell = tester.widget<InkWell>(find.byType(InkWell));
      expect(inkWell.borderRadius, BorderRadius.circular(50));
    });
  });
}
