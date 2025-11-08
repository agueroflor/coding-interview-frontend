import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:currency_exchange/data/models/currency.dart';
import 'package:currency_exchange/core/constants/app_colors.dart';
import 'package:currency_exchange/core/constants/currencies.dart';
import 'package:currency_exchange/core/constants/app_text_styles.dart';
import 'package:currency_exchange/presentation/providers/exchange_provider.dart';

class CurrencySelector extends StatelessWidget {
  final bool isFromCurrency;
  final Currency currentCurrency;

  const CurrencySelector({
    required this.isFromCurrency, required this.currentCurrency, super.key,
  });

  @override
  Widget build(BuildContext context) {

    final showFiat = currentCurrency.type == CurrencyType.fiat;
    final currencies = showFiat ? Currencies.fiatCurrencies : Currencies.cryptoCurrencies;
    final title = showFiat ? 'FIAT' : 'Cripto';

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.70,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.borderGrey,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: AppTextStyles.bottomSheetHeader,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: currencies.map(
                  (currency) => _CurrencyTile(
                    currency: currency,
                    isSelected: currency.id == currentCurrency.id,
                    onTap: () {
                      final provider = context.read<ExchangeProvider>();
                      if (isFromCurrency) {
                        provider.setFromCurrency(currency);
                      } else {
                        provider.setToCurrency(currency);
                      }
                      Navigator.pop(context);
                    },
                  ),
                ).toList(),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _CurrencyTile extends StatelessWidget {
  final Currency currency;
  final bool isSelected;
  final VoidCallback onTap;

  const _CurrencyTile({
    required this.currency,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.asset(
                currency.iconPath,
                width: 24,
                height: 24,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(Icons.currency_exchange, size: 14),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currency.id.contains('-') ? currency.id.split('-').last : currency.id,
                    style: AppTextStyles.currencySelectorTitle,
                  ),
                  Text(
                    '${currency.name} (${currency.id.contains('-') ? currency.id.split('-').last : currency.symbol})',
                    style: AppTextStyles.currencySelectorDescription,
                  ),
                ],
              ),
            ),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? Colors.blue : AppColors.borderGreyDarker,
                  width: 2,
                ),
                color: isSelected ? Colors.blue : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(
                      Icons.circle,
                      size: 12,
                      color: Colors.white,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
