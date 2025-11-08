class ExchangeRateResponse {
  final ExchangeData? data;

  ExchangeRateResponse({this.data});

  factory ExchangeRateResponse.fromJson(Map<String, dynamic> json) {
    return ExchangeRateResponse(
      data: json['data'] != null && json['data'] is Map
          ? ExchangeData.fromJson(json['data'])
          : null,
    );
  }
}

class ExchangeData {
  final ByPrice? byPrice;

  ExchangeData({this.byPrice});

  factory ExchangeData.fromJson(Map<String, dynamic> json) {
    return ExchangeData(
      byPrice: json['byPrice'] != null
          ? ByPrice.fromJson(json['byPrice'])
          : null,
    );
  }
}

class ByPrice {
  final double fiatToCryptoExchangeRate;

  ByPrice({required this.fiatToCryptoExchangeRate});

  factory ByPrice.fromJson(Map<String, dynamic> json) {
    final rate = json['fiatToCryptoExchangeRate'];
    double parsedRate = 0.0;

    if (rate is num) {
      parsedRate = rate.toDouble();
    } else if (rate is String) {
      parsedRate = double.tryParse(rate) ?? 0.0;
    }

    return ByPrice(
      fiatToCryptoExchangeRate: parsedRate,
    );
  }
}
