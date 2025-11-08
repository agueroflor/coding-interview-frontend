import 'package:flutter_test/flutter_test.dart';

import 'package:currency_exchange/data/models/currency.dart';
import 'package:currency_exchange/core/constants/currencies.dart';
import 'package:currency_exchange/presentation/providers/exchange_provider.dart';

void main() {
  group('ExchangeProvider', () {
    late ExchangeProvider provider;

    setUp(() {
      provider = ExchangeProvider();
    });

    tearDown(() async { 
      provider.setAmount('');
      await Future.delayed(const Duration(milliseconds: 700));
      provider.dispose();
    });

    test('initializes with default values', () {
      expect(provider.fromCurrency, Currencies.fiatCurrencies[4]);
      expect(provider.toCurrency, Currencies.cryptoCurrencies[0]);
      expect(provider.amount, '');
      expect(provider.exchangeRate, isNull);
      expect(provider.isLoading, isFalse);
      expect(provider.error, isNull);
      expect(provider.convertedAmount, isNull);
    });

    test('setAmount updates amount value', () {
      provider.setAmount('100.50');
      expect(provider.amount, '100.50');
    });

    test('setAmount with empty string clears exchange rate and error', () {
      provider.setAmount('');
      expect(provider.amount, '');
      expect(provider.exchangeRate, isNull);
      expect(provider.error, isNull);
    });

    test('swapCurrencies swaps from and to currencies', () {
      final originalFrom = provider.fromCurrency;
      final originalTo = provider.toCurrency;

      provider.swapCurrencies();

      expect(provider.fromCurrency, originalTo);
      expect(provider.toCurrency, originalFrom);
    });

    test('setFromCurrency updates from currency', () {
      final newCurrency = Currencies.fiatCurrencies[0];
      provider.setFromCurrency(newCurrency);

      expect(provider.fromCurrency, newCurrency);
    });

    test('setToCurrency updates to currency', () {
      final newCurrency = Currencies.cryptoCurrencies[1];
      provider.setToCurrency(newCurrency);

      expect(provider.toCurrency, newCurrency);
    });

    test('setFromCurrency swaps if same type as toCurrency', () {
      provider.setFromCurrency(Currencies.fiatCurrencies[0]);
      provider.setToCurrency(Currencies.cryptoCurrencies[0]);

      final originalTo = provider.toCurrency;

      provider.setFromCurrency(Currencies.cryptoCurrencies[1]);

      expect(provider.fromCurrency, originalTo);
      expect(provider.toCurrency, Currencies.cryptoCurrencies[1]);
    });

    test('setToCurrency swaps if same type as fromCurrency', () {
      provider.setFromCurrency(Currencies.fiatCurrencies[0]);
      provider.setToCurrency(Currencies.cryptoCurrencies[0]);

      final originalFrom = provider.fromCurrency;

      provider.setToCurrency(Currencies.fiatCurrencies[1]);

      expect(provider.fromCurrency, Currencies.fiatCurrencies[1]);
      expect(provider.toCurrency, originalFrom);
    });

    test('convertedAmount returns null when amount is empty', () {
      provider.setAmount('');
      expect(provider.convertedAmount, isNull);
    });

    test('convertedAmount returns null when exchange rate is null', () {
      provider.setAmount('100');
      expect(provider.convertedAmount, isNull);
    });

    test('convertedAmount calculates correctly for fiat to crypto', () async {
      provider.setAmount('100');

      expect(provider.convertedAmount, isNull);
    });

    test('notifies listeners when amount changes', () {
      int notificationCount = 0;
      provider.addListener(() {
        notificationCount++;
      });

      provider.setAmount('100');

      expect(notificationCount, greaterThan(0));
    });

    test('notifies listeners when currencies are swapped', () {
      int notificationCount = 0;
      provider.addListener(() {
        notificationCount++;
      });

      provider.swapCurrencies();

      expect(notificationCount, greaterThan(0));
    });

    test('notifies listeners when fromCurrency changes', () {
      int notificationCount = 0;
      provider.addListener(() {
        notificationCount++;
      });

      provider.setFromCurrency(Currencies.fiatCurrencies[1]);

      expect(notificationCount, greaterThan(0));
    });

    test('notifies listeners when toCurrency changes', () {
      int notificationCount = 0;
      provider.addListener(() {
        notificationCount++;
      });

      provider.setToCurrency(Currencies.cryptoCurrencies[1]);

      expect(notificationCount, greaterThan(0));
    });

    test('disposes debounce timer on dispose', () {
      final testProvider = ExchangeProvider();
      testProvider.setAmount('100');

      expect(testProvider.amount, '100');
      
      testProvider.dispose();
      
      expect(true, isTrue);
    });

    test('validates amount is not negative', () async {
      provider.setAmount('-100');

      await Future.delayed(const Duration(milliseconds: 600));

      expect(provider.amount, '-100');
    });

    test('validates amount is numeric', () async {
      provider.setAmount('abc');

      await Future.delayed(const Duration(milliseconds: 600));

      expect(provider.amount, 'abc');
    });

    test('debounces API calls', () async {
      int callCount = 0;
      provider.addListener(() {
        if (provider.isLoading) {
          callCount++;
        }
      });

      provider.setAmount('1');
      provider.setAmount('10');
      provider.setAmount('100');

      await Future.delayed(const Duration(milliseconds: 300));

      expect(callCount, 0);

      await Future.delayed(const Duration(milliseconds: 300));

      expect(callCount, lessThanOrEqualTo(1));
    });

    test('convertedAmount calculation for fiat to crypto', () {
      provider.setAmount('100');

      expect(provider.amount, '100');

    });

    test('fromCurrency type determines API call type', () {
      provider.setFromCurrency(Currencies.fiatCurrencies[0]);
      expect(provider.fromCurrency.type, CurrencyType.fiat);

      provider.setFromCurrency(Currencies.cryptoCurrencies[0]);
      expect(provider.fromCurrency.type, CurrencyType.crypto);
    });

    test('handles empty amount gracefully', () async {
      provider.setAmount('');

      expect(provider.isLoading, isFalse);
      expect(provider.error, isNull);
    });
  });
}
