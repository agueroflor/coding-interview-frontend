import 'package:currency_exchange/data/models/currency.dart';

class Currencies {
  static const List<Currency> fiatCurrencies = [
    Currency(
      id: 'VES',
      name: 'Bolívares',
      symbol: 'Bs',
      iconPath: 'assets/fiat_currencies/VES.png',
      type: CurrencyType.fiat,
    ),
    Currency(
      id: 'COP',
      name: 'Pesos Colombianos',
      symbol: r'COL$',
      iconPath: 'assets/fiat_currencies/COP.png',
      type: CurrencyType.fiat,
    ),
    Currency(
      id: 'ARS',
      name: 'Pesos Argentinos',
      symbol: r'$',
      iconPath: 'assets/fiat_currencies/ARS.png',
      type: CurrencyType.fiat,
    ),
    Currency(
      id: 'PEN',
      name: 'Soles Peruanos',
      symbol: 'S/',
      iconPath: 'assets/fiat_currencies/PEN.png',
      type: CurrencyType.fiat,
    ),
    Currency(
      id: 'BRL',
      name: 'Real Brasileño',
      symbol: r'R$',
      iconPath: 'assets/fiat_currencies/BRL.png',
      type: CurrencyType.fiat,
    ),
    Currency(
      id: 'BOB',
      name: 'Boliviano',
      symbol: 'Bs',
      iconPath: 'assets/fiat_currencies/BOB.png',
      type: CurrencyType.fiat,
    ),
  ];

  static const List<Currency> cryptoCurrencies = [
    Currency(
      id: 'TATUM-TRON-USDT',
      name: 'Tether',
      symbol: 'USDT',
      iconPath: 'assets/cripto_currencies/TATUM-TRON-USDT.png',
      type: CurrencyType.crypto,
    ),
    Currency(
      id: 'TATUM-TRON-USDC',
      name: 'USD Coin',
      symbol: 'USDC',
      iconPath: 'assets/cripto_currencies/TATUM-TRON-USDC.png',
      type: CurrencyType.crypto,
    ),
  ];

  static Currency? getCurrencyById(String id) {
    try {
      return [...fiatCurrencies, ...cryptoCurrencies]
          .firstWhere((currency) => currency.id == id);
    } catch (e) {
      return null;
    }
  }
}
