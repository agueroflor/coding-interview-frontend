import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:currency_exchange/data/models/currency.dart';
import 'package:currency_exchange/core/constants/app_colors.dart';
import 'package:currency_exchange/presentation/widgets/widgets.dart';
import 'package:currency_exchange/presentation/providers/exchange_provider.dart';

class ExchangeScreen extends StatelessWidget {
  const ExchangeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const CircularBackground(),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Consumer<ExchangeProvider>(
                  builder: (context, provider, child) {
                    return _ExchangeCard(
                      provider: provider,
                      onCurrencyTap: (isFrom) => _showCurrencySelector(
                        context,
                        isFrom,
                        isFrom ? provider.fromCurrency : provider.toCurrency,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCurrencySelector(
    BuildContext context,
    bool isFromCurrency,
    Currency currentCurrency,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => CurrencySelector(
        isFromCurrency: isFromCurrency,
        currentCurrency: currentCurrency,
      ),
    );
  }
}

class _ExchangeCard extends StatelessWidget {
  final ExchangeProvider provider;
  final Function(bool) onCurrencyTap;

  const _ExchangeCard({
    required this.provider,
    required this.onCurrencyTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.80),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 32),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.borderGrey,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowDarker,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          CurrencySwitcher(
            fromCurrency: provider.fromCurrency,
            toCurrency: provider.toCurrency,
            onSwap: provider.swapCurrencies,
            onCurrencyTap: onCurrencyTap,
          ),
          const SizedBox(height: 15),
          AmountInputField(
            currency: provider.fromCurrency,
            onChanged: provider.setAmount,
          ),
          const SizedBox(height: 15),
          _InfoSection(provider: provider),
          const SizedBox(height: 26),
          PrimaryButton(
            text: 'Cambiar',
            onPressed: provider.exchangeRate != null &&
                    provider.amount.isNotEmpty &&
                    !provider.isLoading
                ? () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Función de cambio no implementada'),
                        backgroundColor: AppColors.snackbarBackground,
                      ),
                    );
                  }
                : null,
          ),
        ],
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  final ExchangeProvider provider;

  const _InfoSection({required this.provider});

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,##0.00', 'es');

    if (provider.isLoading) {
      return const InfoStateWidget(state: InfoState.loading);
    }

    if (provider.error != null) {
      return InfoStateWidget(
        state: InfoState.error,
        message: provider.error,
      );
    }

    if (provider.exchangeRate == null || provider.amount.isEmpty) {
      return const InfoStateWidget(
        state: InfoState.placeholder,
        message: 'Ingresa un monto\n para ver la conversión',
      );
    }

    final convertedAmount = provider.convertedAmount ?? 0;
    final toCurrencySymbol = provider.toCurrency.id.contains('-')
        ? provider.toCurrency.symbol
        : provider.toCurrency.id;

    return Column(
      children: [
        InfoRow(
          label: 'Tasa estimada',
          value: '≈ ${formatter.format(provider.exchangeRate)} $toCurrencySymbol',
        ),
        const SizedBox(height: 12),
        InfoRow(
          label: 'Recibirás',
          value: '≈ ${formatter.format(convertedAmount)} $toCurrencySymbol',
        ),
        const SizedBox(height: 12),
        const InfoRow(
          label: 'Tiempo estimado',
          value: '≈ 10 Min',
        ),
      ],
    );
  }
}
