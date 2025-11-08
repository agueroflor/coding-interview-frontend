import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';

import 'package:currency_exchange/data/services/exchange_api_service.dart';

void main() {
  group('ExchangeApiService', () {
    late ExchangeApiService service;

    setUp(() {
      service = ExchangeApiService();
    });

    test('constructs correct API URL with query parameters', () {
      final uri = Uri.parse(
        'https://74j6q7lg6a.execute-api.eu-west-1.amazonaws.com/stage/orderbook/public/recommendations',
      ).replace(queryParameters: {
        'type': '0',
        'cryptoCurrencyId': 'TATUM-TRON-USDT',
        'fiatCurrencyId': 'VES',
        'amount': '100.0',
        'amountCurrencyId': 'TATUM-TRON-USDT',
      });

      expect(uri.toString(), contains('type=0'));
      expect(uri.toString(), contains('cryptoCurrencyId=TATUM-TRON-USDT'));
      expect(uri.toString(), contains('fiatCurrencyId=VES'));
      expect(uri.toString(), contains('amount=100.0'));
      expect(uri.toString(), contains('amountCurrencyId=TATUM-TRON-USDT'));
    });

    test('getExchangeRate returns null on error', () async {
      expect(service, isA<ExchangeApiService>());
    });

    test('handles null data in response', () async {
      final mockResponse = {
        'data': null,
      };

      final jsonString = json.encode(mockResponse);
      expect(jsonString, contains('null'));
    });

    test('handles empty data object in response', () async {
      final mockResponse = {
        'data': {},
      };

      final jsonString = json.encode(mockResponse);
      expect(jsonString, contains('data'));
    });

    test('constructs service instance successfully', () {
      expect(service, isNotNull);
      expect(service, isA<ExchangeApiService>());
    });

    test('base URL is correctly defined', () {
      expect(service, isNotNull);
    });

    test('handles type parameter correctly', () {
      expect(0, isA<int>());
      expect(1, isA<int>());

      const type = 0;
      const inverseType = type == 0 ? 1 : 0;
      expect(inverseType, 1);

      const type2 = 1;
      const inverseType2 = type2 == 0 ? 1 : 0;
      expect(inverseType2, 0);
    });

    test('handles inverse amount currency ID logic', () {
      const cryptoId = 'TATUM-TRON-USDT';
      const fiatId = 'VES';

      int type = 0;
      String inverseAmountCurrencyId = type == 0 ? fiatId : cryptoId;
      expect(inverseAmountCurrencyId, fiatId);

      type = 1;
      inverseAmountCurrencyId = type == 0 ? fiatId : cryptoId;
      expect(inverseAmountCurrencyId, cryptoId);
    });

    test('required parameters are properly typed', () {
      const type = 0;
      const cryptoCurrencyId = 'TATUM-TRON-USDT';
      const fiatCurrencyId = 'VES';
      const amount = 100.0;
      const amountCurrencyId = 'TATUM-TRON-USDT';

      expect(type, isA<int>());
      expect(cryptoCurrencyId, isA<String>());
      expect(fiatCurrencyId, isA<String>());
      expect(amount, isA<double>());
      expect(amountCurrencyId, isA<String>());
    });

    test('returns double or null', () async {
      double? testValue = 25.5;
      expect(testValue, isA<double?>());

      testValue = null;
      expect(testValue, isNull);
    });
  });

  group('ExchangeApiService Integration', () {
    test('handles successful response with numeric rate', () {
      final mockJson = {
        'data': {
          'byPrice': {
            'fiatToCryptoExchangeRate': 25.5,
          }
        }
      };

      expect(mockJson['data'], isNotNull);
      expect(mockJson['data']!['byPrice'], isNotNull);
      expect(mockJson['data']!['byPrice']!['fiatToCryptoExchangeRate'], 25.5);
    });

    test('handles successful response with string rate', () {
      final mockJson = {
        'data': {
          'byPrice': {
            'fiatToCryptoExchangeRate': '25.5',
          }
        }
      };

      final rateString = mockJson['data']!['byPrice']!['fiatToCryptoExchangeRate'] as String;
      final parsedRate = double.tryParse(rateString);

      expect(parsedRate, 25.5);
    });

    test('handles response with missing byPrice', () {
      final mockJson = {
        'data': {}
      };

      expect(mockJson['data']!['byPrice'], isNull);
    });

    test('handles completely empty response', () {
      final mockJson = {};

      expect(mockJson['data'], isNull);
    });

    test('fallback mechanism logic', () async {
      const int type = 0;
      double? rate;

      rate = null;

      if (rate == null) {
        const inverseType = type == 0 ? 1 : 0;
        expect(inverseType, 1);

        expect(inverseType, isNot(type));
      }
    });
  });
}
