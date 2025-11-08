import 'dart:async';
import 'package:flutter/material.dart';

import 'package:currency_exchange/data/models/currency.dart';
import 'package:currency_exchange/core/constants/currencies.dart';
import 'package:currency_exchange/data/services/exchange_api_service.dart';

class ExchangeProvider extends ChangeNotifier {
  final ExchangeApiService _apiService = ExchangeApiService();
  Timer? _debounceTimer;

  Currency _fromCurrency = Currencies.fiatCurrencies[4];
  Currency _toCurrency = Currencies.cryptoCurrencies[0];
  String _amount = '';
  double? _exchangeRate;
  bool _isLoading = false;
  String? _error;

  Currency get fromCurrency => _fromCurrency;
  Currency get toCurrency => _toCurrency;
  String get amount => _amount;
  double? get exchangeRate => _exchangeRate;
  bool get isLoading => _isLoading;
  String? get error => _error;

  double? get convertedAmount {
    if (_amount.isEmpty || _exchangeRate == null) return null;
    final inputAmount = double.tryParse(_amount);
    if (inputAmount == null) return null;

    if (_fromCurrency.type == CurrencyType.fiat) {
      return inputAmount * _exchangeRate!;
    } else {
      return inputAmount / _exchangeRate!;
    }
  }

  void setFromCurrency(Currency currency) {
    _fromCurrency = currency;
    if (_fromCurrency.type == _toCurrency.type) {
      swapCurrencies();
    } else {
      notifyListeners();
      if (_amount.isNotEmpty) {
        fetchExchangeRate();
      }
    }
  }

  void setToCurrency(Currency currency) {
    _toCurrency = currency;
    if (_fromCurrency.type == _toCurrency.type) {
      swapCurrencies();
    } else {
      notifyListeners();
      if (_amount.isNotEmpty) {
        fetchExchangeRate();
      }
    }
  }

  void swapCurrencies() {
    final temp = _fromCurrency;
    _fromCurrency = _toCurrency;
    _toCurrency = temp;
    notifyListeners();
    if (_amount.isNotEmpty) {
      fetchExchangeRate();
    }
  }

  void setAmount(String value) {
    _amount = value;
    notifyListeners();

    _debounceTimer?.cancel();

    if (value.isNotEmpty) {
      _debounceTimer = Timer(const Duration(milliseconds: 500), () {
        fetchExchangeRate();
      });
    } else {
      _exchangeRate = null;
      _error = null;
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  Future<void> fetchExchangeRate() async {
    if (_amount.isEmpty) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    final inputAmount = double.tryParse(_amount);
    if (inputAmount == null || inputAmount <= 0) {
      _isLoading = false;
      _error = 'Monto inválido';
      notifyListeners();
      return;
    }

    final type = _fromCurrency.type == CurrencyType.crypto ? 0 : 1;
    final cryptoId = _fromCurrency.type == CurrencyType.crypto
        ? _fromCurrency.id
        : _toCurrency.id;
    final fiatId = _fromCurrency.type == CurrencyType.fiat
        ? _fromCurrency.id
        : _toCurrency.id;

    try {
      final rate = await _apiService.getExchangeRate(
        type: type,
        cryptoCurrencyId: cryptoId,
        fiatCurrencyId: fiatId,
        amount: inputAmount,
        amountCurrencyId: _fromCurrency.id,
      );

      _isLoading = false;
      _exchangeRate = rate;
      _error = null;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString().replaceAll('ApiException: ', '');
      notifyListeners();
    }
  }
}
