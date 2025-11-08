import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:currency_exchange/data/models/currency.dart';
import 'package:currency_exchange/core/constants/app_colors.dart';
import 'package:currency_exchange/core/constants/app_text_styles.dart';

class AmountInputField extends StatelessWidget {
  final Currency currency;
  final Function(String) onChanged;

  const AmountInputField({
    required this.currency, required this.onChanged, super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primaryYellow, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(
            currency.id.contains('-')
                ? currency.symbol
                : currency.id,
            style: AppTextStyles.amountInputSymbol,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              onChanged: onChanged,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
              ],
              style: AppTextStyles.amountInputValue,
              decoration: InputDecoration(
                hintText: '0.00',
                hintStyle: AppTextStyles.amountInputHint,
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
