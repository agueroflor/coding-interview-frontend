import 'package:flutter_test/flutter_test.dart';

import 'package:currency_exchange/data/models/currency.dart';

void main() {
  group('Currency', () {
    test('creates currency with all required fields', () {
      const currency = Currency(
        id: 'VES',
        name: 'Venezuelan Bolivar',
        symbol: '฿',
        iconPath: 'assets/currencies/VES.png',
        type: CurrencyType.fiat,
      );

      expect(currency.id, 'VES');
      expect(currency.name, 'Venezuelan Bolivar');
      expect(currency.symbol, '฿');
      expect(currency.iconPath, 'assets/currencies/VES.png');
      expect(currency.type, CurrencyType.fiat);
    });

    test('creates fiat currency', () {
      const currency = Currency(
        id: 'COP',
        name: 'Colombian Peso',
        symbol: r'$',
        iconPath: 'assets/currencies/COP.png',
        type: CurrencyType.fiat,
      );

      expect(currency.type, CurrencyType.fiat);
    });

    test('creates crypto currency', () {
      const currency = Currency(
        id: 'TATUM-TRON-USDT',
        name: 'Tether',
        symbol: 'USDT',
        iconPath: 'assets/cripto_currencies/TATUM-TRON-USDT.png',
        type: CurrencyType.crypto,
      );

      expect(currency.type, CurrencyType.crypto);
    });

    test('currency is immutable (const constructor)', () {
      const currency1 = Currency(
        id: 'VES',
        name: 'Venezuelan Bolivar',
        symbol: '฿',
        iconPath: 'assets/currencies/VES.png',
        type: CurrencyType.fiat,
      );

      const currency2 = Currency(
        id: 'VES',
        name: 'Venezuelan Bolivar',
        symbol: '฿',
        iconPath: 'assets/currencies/VES.png',
        type: CurrencyType.fiat,
      );

      // Same values should create equal instances
      expect(currency1.id, currency2.id);
      expect(currency1.name, currency2.name);
      expect(currency1.symbol, currency2.symbol);
      expect(currency1.iconPath, currency2.iconPath);
      expect(currency1.type, currency2.type);
    });

    test('different currencies have different properties', () {
      const currency1 = Currency(
        id: 'VES',
        name: 'Venezuelan Bolivar',
        symbol: '฿',
        iconPath: 'assets/currencies/VES.png',
        type: CurrencyType.fiat,
      );

      const currency2 = Currency(
        id: 'COP',
        name: 'Colombian Peso',
        symbol: r'$',
        iconPath: 'assets/currencies/COP.png',
        type: CurrencyType.fiat,
      );

      expect(currency1.id, isNot(currency2.id));
      expect(currency1.name, isNot(currency2.name));
    });

    test('crypto currency can have complex ID', () {
      const currency = Currency(
        id: 'TATUM-TRON-USDT',
        name: 'Tether',
        symbol: 'USDT',
        iconPath: 'assets/cripto_currencies/TATUM-TRON-USDT.png',
        type: CurrencyType.crypto,
      );

      expect(currency.id, contains('-'));
      expect(currency.id.split('-').length, 3);
    });

    test('currency properties are accessible', () {
      const currency = Currency(
        id: 'ARS',
        name: 'Argentine Peso',
        symbol: r'$',
        iconPath: 'assets/currencies/ARS.png',
        type: CurrencyType.fiat,
      );

      // All properties should be accessible
      expect(currency.id, isA<String>());
      expect(currency.name, isA<String>());
      expect(currency.symbol, isA<String>());
      expect(currency.iconPath, isA<String>());
      expect(currency.type, isA<CurrencyType>());
    });
  });

  group('CurrencyType', () {
    test('enum has fiat type', () {
      expect(CurrencyType.fiat, isA<CurrencyType>());
    });

    test('enum has crypto type', () {
      expect(CurrencyType.crypto, isA<CurrencyType>());
    });

    test('fiat and crypto are different', () {
      expect(CurrencyType.fiat, isNot(CurrencyType.crypto));
    });

    test('enum values can be compared', () {
      const currency1 = Currency(
        id: 'VES',
        name: 'Venezuelan Bolivar',
        symbol: '฿',
        iconPath: 'assets/currencies/VES.png',
        type: CurrencyType.fiat,
      );

      const currency2 = Currency(
        id: 'TATUM-TRON-USDT',
        name: 'Tether',
        symbol: 'USDT',
        iconPath: 'assets/cripto_currencies/TATUM-TRON-USDT.png',
        type: CurrencyType.crypto,
      );

      expect(currency1.type == CurrencyType.fiat, isTrue);
      expect(currency2.type == CurrencyType.crypto, isTrue);
      expect(currency1.type == currency2.type, isFalse);
    });

    test('enum can be used in switch statements', () {
      const currency = Currency(
        id: 'VES',
        name: 'Venezuelan Bolivar',
        symbol: '฿',
        iconPath: 'assets/currencies/VES.png',
        type: CurrencyType.fiat,
      );

      String result = '';
      switch (currency.type) {
        case CurrencyType.fiat:
          result = 'FIAT';
          break;
        case CurrencyType.crypto:
          result = 'Cripto';
          break;
      }

      expect(result, 'FIAT');
    });
  });

  group('Currency Edge Cases', () {
    test('handles empty string values', () {
      const currency = Currency(
        id: '',
        name: '',
        symbol: '',
        iconPath: '',
        type: CurrencyType.fiat,
      );

      expect(currency.id, '');
      expect(currency.name, '');
      expect(currency.symbol, '');
      expect(currency.iconPath, '');
    });

    test('handles special characters in symbol', () {
      const currency = Currency(
        id: 'BRL',
        name: 'Brazilian Real',
        symbol: r'R$',
        iconPath: 'assets/currencies/BRL.png',
        type: CurrencyType.fiat,
      );

      expect(currency.symbol, r'R$');
    });

    test('handles long currency names', () {
      const currency = Currency(
        id: 'TEST',
        name: 'This is a very long currency name for testing purposes',
        symbol: 'T',
        iconPath: 'assets/currencies/TEST.png',
        type: CurrencyType.fiat,
      );

      expect(currency.name.length, greaterThan(20));
    });

    test('handles different icon path formats', () {
      const currency1 = Currency(
        id: 'VES',
        name: 'Venezuelan Bolivar',
        symbol: '฿',
        iconPath: 'assets/currencies/VES.png',
        type: CurrencyType.fiat,
      );

      const currency2 = Currency(
        id: 'USDT',
        name: 'Tether',
        symbol: 'USDT',
        iconPath: 'assets/cripto_currencies/TATUM-TRON-USDT.png',
        type: CurrencyType.crypto,
      );

      expect(currency1.iconPath, contains('currencies'));
      expect(currency2.iconPath, contains('cripto_currencies'));
    });
  });
}
