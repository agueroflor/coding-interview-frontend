import 'package:flutter/material.dart';

import 'package:currency_exchange/core/constants/app_colors.dart';

class AppTextStyles {
  static TextStyle smallLabel = TextStyle(
    fontSize: 9,
    fontWeight: FontWeight.w600,
    color: AppColors.textDarker,
    letterSpacing: 0.2,
  );

  static TextStyle currencyButton = const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle currencySelectorTitle = const TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: Colors.black87,
  );

  static TextStyle currencySelectorDescription = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  static const TextStyle bottomSheetHeader = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
  );

  static TextStyle amountInputSymbol = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.primaryYellow,
  );

  static TextStyle amountInputValue = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle amountInputHint = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle infoLabel = TextStyle(
    fontSize: 14,
    color: AppColors.textTertiary,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.3,
  );

  static TextStyle infoSign = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
    letterSpacing: -0.3,
  );

  static TextStyle infoNumber = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.textDark,
    letterSpacing: -0.3,
  );

  static TextStyle infoUnit = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
    letterSpacing: -0.3,
  );

  static TextStyle loadingMessage = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 14,
  );

  static TextStyle errorMessage = TextStyle(
    color: AppColors.error,
    fontSize: 14,
  );

  static TextStyle conversionPlaceholder = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 14,
  );

  static const TextStyle changeButton = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.3,
  );
}
