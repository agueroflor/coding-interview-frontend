import 'package:flutter/material.dart';
import 'package:currency_exchange/core/constants/app_text_styles.dart';

class InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const InfoRow({
    required this.label, required this.value, super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Separar el valor en partes: signo ≈, número, y unidad
    final regex = RegExp(r'^(≈)?\s*([0-9,\.]+)\s*(.*)$');
    final match = regex.firstMatch(value.trim());

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.infoLabel,
        ),
        RichText(
          text: TextSpan(
            children: [
              if (match?.group(1) != null)
                TextSpan(
                  text: '${match!.group(1)}  ',
                  style: AppTextStyles.infoSign,
                ),
              TextSpan(
                text: match?.group(2) ?? value,
                style: AppTextStyles.infoNumber,
              ),
              if ((match?.group(3)?.isNotEmpty ?? false))
                TextSpan(
                  text: ' ${match!.group(3)} ',
                  style: AppTextStyles.infoUnit,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
