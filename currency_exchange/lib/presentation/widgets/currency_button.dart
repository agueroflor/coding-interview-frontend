import 'package:flutter/material.dart';

import 'package:currency_exchange/data/models/currency.dart';
import 'package:currency_exchange/core/constants/app_colors.dart';
import 'package:currency_exchange/core/constants/app_text_styles.dart';

class CurrencyButton extends StatelessWidget {
  final Currency currency;
  final VoidCallback onTap;

  const CurrencyButton({
    required this.currency, required this.onTap, super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.asset(
                currency.iconPath,
                width: 22,
                height: 22,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: AppColors.borderGrey,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(Icons.currency_exchange, size: 16),
                  );
                },
              ),
            ),
            const SizedBox(width: 8),
            Text(
              currency.id.contains('-')
                  ? currency.symbol
                  : currency.id,
              style: AppTextStyles.currencyButton,
            ),
            const SizedBox(width: 4),
            Icon(Icons.keyboard_arrow_down, size: 16, color: AppColors.iconGrey),
          ],
        ),
      ),
    );
  }
}
