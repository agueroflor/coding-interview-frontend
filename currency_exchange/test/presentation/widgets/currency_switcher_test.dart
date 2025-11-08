import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:currency_exchange/data/models/currency.dart';
import 'package:currency_exchange/presentation/widgets/widgets.dart';

void main() {
  group('CurrencySwitcher', () {
    late Currency fromCurrency;
    late Currency toCurrency;

    setUp(() {
      fromCurrency = const Currency(
        id: 'VES',
        name: 'Venezuelan Bolivar',
        symbol: '฿',
        iconPath: 'assets/currencies/VES.png',
        type: CurrencyType.fiat,
      );

      toCurrency = const Currency(
        id: 'TATUM-TRON-USDT',
        name: 'Tether',
        symbol: 'USDT',
        iconPath: 'assets/cripto_currencies/TATUM-TRON-USDT.png',
        type: CurrencyType.crypto,
      );
    });

    testWidgets('renders both currency buttons', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CurrencySwitcher(
              fromCurrency: fromCurrency,
              toCurrency: toCurrency,
              onSwap: () {},
              onCurrencyTap: (isFrom) {},
            ),
          ),
        ),
      );

      expect(find.byType(CurrencyButton), findsNWidgets(2));
    });

    testWidgets('displays TENGO and QUIERO labels', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CurrencySwitcher(
              fromCurrency: fromCurrency,
              toCurrency: toCurrency,
              onSwap: () {},
              onCurrencyTap: (isFrom) {},
            ),
          ),
        ),
      );

      expect(find.text('TENGO'), findsOneWidget);
      expect(find.text('QUIERO'), findsOneWidget);
    });

    testWidgets('displays swap button', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CurrencySwitcher(
              fromCurrency: fromCurrency,
              toCurrency: toCurrency,
              onSwap: () {},
              onCurrencyTap: (isFrom) {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.swap_horiz), findsOneWidget);
      expect(find.byType(IconButton), findsOneWidget);
    });

    testWidgets('calls onSwap when swap button is tapped', (tester) async {
      bool swapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CurrencySwitcher(
              fromCurrency: fromCurrency,
              toCurrency: toCurrency,
              onSwap: () {
                swapped = true;
              },
              onCurrencyTap: (isFrom) {},
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.swap_horiz));
      expect(swapped, isTrue);
    });

    testWidgets('calls onCurrencyTap with true when from currency is tapped', (tester) async {
      bool? tappedFrom;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CurrencySwitcher(
              fromCurrency: fromCurrency,
              toCurrency: toCurrency,
              onSwap: () {},
              onCurrencyTap: (isFrom) {
                tappedFrom = isFrom;
              },
            ),
          ),
        ),
      );

      final currencyButtons = tester.widgetList<CurrencyButton>(find.byType(CurrencyButton)).toList();
      await tester.tap(find.byWidget(currencyButtons[0]));

      expect(tappedFrom, isTrue);
    });

    testWidgets('calls onCurrencyTap with false when to currency is tapped', (tester) async {
      bool? tappedFrom;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CurrencySwitcher(
              fromCurrency: fromCurrency,
              toCurrency: toCurrency,
              onSwap: () {},
              onCurrencyTap: (isFrom) {
                tappedFrom = isFrom;
              },
            ),
          ),
        ),
      );

      final currencyButtons = tester.widgetList<CurrencyButton>(find.byType(CurrencyButton)).toList();
      await tester.tap(find.byWidget(currencyButtons[1]));

      expect(tappedFrom, isFalse);
    });

    testWidgets('has correct layout structure with Stack', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CurrencySwitcher(
              fromCurrency: fromCurrency,
              toCurrency: toCurrency,
              onSwap: () {},
              onCurrencyTap: (isFrom) {},
            ),
          ),
        ),
      );

      // Find the main Stack that contains Positioned widgets
      final positionedFinder = find.descendant(
        of: find.byType(CurrencySwitcher),
        matching: find.byType(Positioned),
      );
      
      expect(positionedFinder, findsNWidgets(2)); // Swap button and labels
      
      // Verify there's at least one Stack in CurrencySwitcher
      final stackFinder = find.descendant(
        of: find.byType(CurrencySwitcher),
        matching: find.byType(Stack),
      );
      expect(stackFinder, findsWidgets);
    });
  });
}
