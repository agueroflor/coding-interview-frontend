import 'package:flutter/material.dart';
import 'package:currency_exchange/core/constants/app_text_styles.dart';
import 'package:currency_exchange/presentation/widgets/shimmer_loading.dart';

enum InfoState { loading, error, placeholder }

class InfoStateWidget extends StatelessWidget {
  final InfoState state;
  final String? message;

  const InfoStateWidget({
    required this.state, super.key,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case InfoState.loading:
        return const ShimmerLoading();
      case InfoState.error:
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            message ?? 'Error desconocido',
            style: AppTextStyles.errorMessage,
            textAlign: TextAlign.center,
          ),
        );
      case InfoState.placeholder:
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            message ?? 'Sin información',
            style: AppTextStyles.conversionPlaceholder,
            textAlign: TextAlign.center,
          ),
        );
    }
  }
}
