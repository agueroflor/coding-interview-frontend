enum CurrencyType {
  fiat,
  crypto,
}

class Currency {
  final String id;
  final String name;
  final String symbol;
  final String iconPath;
  final CurrencyType type;

  const Currency({
    required this.id,
    required this.name,
    required this.symbol,
    required this.iconPath,
    required this.type,
  });
}
