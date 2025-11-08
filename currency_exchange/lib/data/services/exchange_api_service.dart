import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:currency_exchange/core/errors/api_exception.dart';
import 'package:currency_exchange/data/models/exchange_rate_response.dart';

class ExchangeApiService {
  static const String _baseUrl =
      'https://74j6q7lg6a.execute-api.eu-west-1.amazonaws.com/stage/orderbook/public/recommendations';
  static const int _maxRetries = 3;
  static const Duration _retryDelay = Duration(milliseconds: 500);
  static const Duration _timeout = Duration(seconds: 10);

  final Connectivity _connectivity = Connectivity();

  Future<double?> getExchangeRate({
    required int type,
    required String cryptoCurrencyId,
    required String fiatCurrencyId,
    required double amount,
    required String amountCurrencyId,
  }) async {
    if (!await _hasNetworkConnection()) {
      throw ApiException(
        'Sin conexión a internet. Verifica tu conexión.',
        ApiErrorType.network,
      );
    }

    try {
      var rate = await _fetchRateWithRetry(
        type: type,
        cryptoCurrencyId: cryptoCurrencyId,
        fiatCurrencyId: fiatCurrencyId,
        amount: amount,
        amountCurrencyId: amountCurrencyId,
      );

      if (rate == null) {
        final inverseType = type == 0 ? 1 : 0;
        final inverseAmountCurrencyId = type == 0 ? fiatCurrencyId : cryptoCurrencyId;

        rate = await _fetchRateWithRetry(
          type: inverseType,
          cryptoCurrencyId: cryptoCurrencyId,
          fiatCurrencyId: fiatCurrencyId,
          amount: amount,
          amountCurrencyId: inverseAmountCurrencyId,
        );
      }

      if (rate == null) {
        throw ApiException(
          'No hay datos disponibles para este par de monedas.',
          ApiErrorType.noData,
        );
      }

      return rate;
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        'Error inesperado: ${e.toString()}',
        ApiErrorType.unknown,
      );
    }
  }

  Future<double?> _fetchRateWithRetry({
    required int type,
    required String cryptoCurrencyId,
    required String fiatCurrencyId,
    required double amount,
    required String amountCurrencyId,
    int retryCount = 0,
  }) async {
    try {
      return await _fetchRate(
        type: type,
        cryptoCurrencyId: cryptoCurrencyId,
        fiatCurrencyId: fiatCurrencyId,
        amount: amount,
        amountCurrencyId: amountCurrencyId,
      );
    } on SocketException {
      if (retryCount < _maxRetries) {
        await Future.delayed(_retryDelay);
        return _fetchRateWithRetry(
          type: type,
          cryptoCurrencyId: cryptoCurrencyId,
          fiatCurrencyId: fiatCurrencyId,
          amount: amount,
          amountCurrencyId: amountCurrencyId,
          retryCount: retryCount + 1,
        );
      }
      throw ApiException(
        'Error de conexión. Por favor intenta nuevamente.',
        ApiErrorType.network,
      );
    } on TimeoutException {
      if (retryCount < _maxRetries) {
        await Future.delayed(_retryDelay);
        return _fetchRateWithRetry(
          type: type,
          cryptoCurrencyId: cryptoCurrencyId,
          fiatCurrencyId: fiatCurrencyId,
          amount: amount,
          amountCurrencyId: amountCurrencyId,
          retryCount: retryCount + 1,
        );
      }
      throw ApiException(
        'La solicitud tardó demasiado. Intenta nuevamente.',
        ApiErrorType.timeout,
      );
    }
  }

  Future<double?> _fetchRate({
    required int type,
    required String cryptoCurrencyId,
    required String fiatCurrencyId,
    required double amount,
    required String amountCurrencyId,
  }) async {
    final uri = Uri.parse(_baseUrl).replace(queryParameters: {
      'type': type.toString(),
      'cryptoCurrencyId': cryptoCurrencyId,
      'fiatCurrencyId': fiatCurrencyId,
      'amount': amount.toString(),
      'amountCurrencyId': amountCurrencyId,
    });

    final response = await http.get(uri).timeout(_timeout);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final exchangeResponse = ExchangeRateResponse.fromJson(jsonData);

      final rate = exchangeResponse.data?.byPrice?.fiatToCryptoExchangeRate;
      return rate;
    } else if (response.statusCode >= 500) {
      throw ApiException(
        'Error del servidor. Intenta más tarde.',
        ApiErrorType.server,
      );
    }
    return null;
  }

  Future<bool> _hasNetworkConnection() async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      return connectivityResult.any((result) =>
          result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi ||
          result == ConnectivityResult.ethernet);
    } catch (e) {
      return true;
    }
  }
}
