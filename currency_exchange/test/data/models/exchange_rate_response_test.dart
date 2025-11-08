import 'package:flutter_test/flutter_test.dart';

import 'package:currency_exchange/data/models/exchange_rate_response.dart';

void main() {
  group('ByPrice', () {
    test('parses numeric rate correctly', () {
      final json = {
        'fiatToCryptoExchangeRate': 25.5,
      };

      final byPrice = ByPrice.fromJson(json);

      expect(byPrice.fiatToCryptoExchangeRate, 25.5);
    });

    test('parses string rate correctly', () {
      final json = {
        'fiatToCryptoExchangeRate': '25.5',
      };

      final byPrice = ByPrice.fromJson(json);

      expect(byPrice.fiatToCryptoExchangeRate, 25.5);
    });

    test('handles invalid string rate', () {
      final json = {
        'fiatToCryptoExchangeRate': 'invalid',
      };

      final byPrice = ByPrice.fromJson(json);

      expect(byPrice.fiatToCryptoExchangeRate, 0.0);
    });

    test('handles null rate', () {
      final json = {
        'fiatToCryptoExchangeRate': null,
      };

      final byPrice = ByPrice.fromJson(json);

      expect(byPrice.fiatToCryptoExchangeRate, 0.0);
    });

    test('handles integer rate', () {
      final json = {
        'fiatToCryptoExchangeRate': 25,
      };

      final byPrice = ByPrice.fromJson(json);

      expect(byPrice.fiatToCryptoExchangeRate, 25.0);
    });

    test('handles large numeric values', () {
      final json = {
        'fiatToCryptoExchangeRate': 1234567.89,
      };

      final byPrice = ByPrice.fromJson(json);

      expect(byPrice.fiatToCryptoExchangeRate, 1234567.89);
    });

    test('handles zero value', () {
      final json = {
        'fiatToCryptoExchangeRate': 0,
      };

      final byPrice = ByPrice.fromJson(json);

      expect(byPrice.fiatToCryptoExchangeRate, 0.0);
    });

    test('handles negative values', () {
      final json = {
        'fiatToCryptoExchangeRate': -25.5,
      };

      final byPrice = ByPrice.fromJson(json);

      expect(byPrice.fiatToCryptoExchangeRate, -25.5);
    });
  });

  group('ExchangeData', () {
    test('parses with valid byPrice', () {
      final json = {
        'byPrice': {
          'fiatToCryptoExchangeRate': 25.5,
        }
      };

      final exchangeData = ExchangeData.fromJson(json);

      expect(exchangeData.byPrice, isNotNull);
      expect(exchangeData.byPrice?.fiatToCryptoExchangeRate, 25.5);
    });

    test('handles null byPrice', () {
      final json = {
        'byPrice': null,
      };

      final exchangeData = ExchangeData.fromJson(json);

      expect(exchangeData.byPrice, isNull);
    });

    test('handles missing byPrice', () {
      final json = <String, dynamic>{};

      final exchangeData = ExchangeData.fromJson(json);

      expect(exchangeData.byPrice, isNull);
    });

    test('handles empty byPrice object', () {
      final json = {
        'byPrice': {}
      };

      final exchangeData = ExchangeData.fromJson(json);

      expect(exchangeData.byPrice, isNotNull);
    });
  });

  group('ExchangeRateResponse', () {
    test('parses complete valid response', () {
      final json = {
        'data': {
          'byPrice': {
            'fiatToCryptoExchangeRate': 25.5,
          }
        }
      };

      final response = ExchangeRateResponse.fromJson(json);

      expect(response.data, isNotNull);
      expect(response.data?.byPrice, isNotNull);
      expect(response.data?.byPrice?.fiatToCryptoExchangeRate, 25.5);
    });

    test('handles null data', () {
      final json = {
        'data': null,
      };

      final response = ExchangeRateResponse.fromJson(json);

      expect(response.data, isNull);
    });

    test('handles missing data', () {
      final json = <String, dynamic>{};

      final response = ExchangeRateResponse.fromJson(json);

      expect(response.data, isNull);
    });

    test('handles empty data object', () {
      final json = {
        'data': {}
      };

      final response = ExchangeRateResponse.fromJson(json);

      expect(response.data, isNotNull);
      expect(response.data?.byPrice, isNull);
    });

    test('handles data as non-Map type', () {
      final json = {
        'data': 'invalid',
      };

      final response = ExchangeRateResponse.fromJson(json);

      expect(response.data, isNull);
    });

    test('handles data as list', () {
      final json = {
        'data': [],
      };

      final response = ExchangeRateResponse.fromJson(json);

      expect(response.data, isNull);
    });

    test('parses response with string rate', () {
      final json = {
        'data': {
          'byPrice': {
            'fiatToCryptoExchangeRate': '36.75',
          }
        }
      };

      final response = ExchangeRateResponse.fromJson(json);

      expect(response.data?.byPrice?.fiatToCryptoExchangeRate, 36.75);
    });

    test('handles nested null values', () {
      final json = {
        'data': {
          'byPrice': null,
        }
      };

      final response = ExchangeRateResponse.fromJson(json);

      expect(response.data, isNotNull);
      expect(response.data?.byPrice, isNull);
    });
  });

  group('Edge Cases', () {
    test('handles very small decimal values', () {
      final json = {
        'fiatToCryptoExchangeRate': 0.0001,
      };

      final byPrice = ByPrice.fromJson(json);

      expect(byPrice.fiatToCryptoExchangeRate, 0.0001);
    });

    test('handles scientific notation in string', () {
      final json = {
        'fiatToCryptoExchangeRate': '1.5e2',
      };

      final byPrice = ByPrice.fromJson(json);

      expect(byPrice.fiatToCryptoExchangeRate, 150.0);
    });

    test('handles trailing zeros in string', () {
      final json = {
        'fiatToCryptoExchangeRate': '25.5000',
      };

      final byPrice = ByPrice.fromJson(json);

      expect(byPrice.fiatToCryptoExchangeRate, 25.5);
    });

    test('handles leading zeros in string', () {
      final json = {
        'fiatToCryptoExchangeRate': '0025.5',
      };

      final byPrice = ByPrice.fromJson(json);

      expect(byPrice.fiatToCryptoExchangeRate, 25.5);
    });

    test('handles empty string rate', () {
      final json = {
        'fiatToCryptoExchangeRate': '',
      };

      final byPrice = ByPrice.fromJson(json);

      expect(byPrice.fiatToCryptoExchangeRate, 0.0);
    });
  });
}
