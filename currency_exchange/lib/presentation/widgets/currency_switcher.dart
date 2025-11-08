import 'package:flutter/material.dart';

import 'package:currency_exchange/data/models/currency.dart';
import 'package:currency_exchange/core/constants/app_colors.dart';
import 'package:currency_exchange/core/constants/app_text_styles.dart';
import 'package:currency_exchange/presentation/widgets/widgets.dart';

class CurrencySwitcher extends StatefulWidget {
  final Currency fromCurrency;
  final Currency toCurrency;
  final VoidCallback onSwap;
  final Function(bool) onCurrencyTap;

  const CurrencySwitcher({
    required this.fromCurrency, required this.toCurrency, required this.onSwap, required this.onCurrencyTap, super.key,
  });

  @override
  State<CurrencySwitcher> createState() => _CurrencySwitcherState();
}

class _CurrencySwitcherState extends State<CurrencySwitcher>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSwap() {
    _controller.forward(from: 0);
    widget.onSwap();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 8),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primaryYellow, width: 2),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(50),
                      bottomLeft: Radius.circular(50),
                    ),
                  ),
                  padding: const EdgeInsets.only(left: 4, right: 4, top: 2, bottom: 2),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0.0, 0.3),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                      );
                    },
                    child: CurrencyButton(
                      key: ValueKey(widget.fromCurrency.id),
                      currency: widget.fromCurrency,
                      onTap: () => widget.onCurrencyTap(true),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primaryYellow, width: 2),
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                  ),
                  padding: const EdgeInsets.only(left: 20, right: 4, top: 2, bottom: 2),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0.0, 0.3),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                      );
                    },
                    child: CurrencyButton(
                      key: ValueKey(widget.toCurrency.id),
                      currency: widget.toCurrency,
                      onTap: () => widget.onCurrencyTap(false),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 5,
          child: RotationTransition(
            turns: _rotationAnimation,
            child: Container(
              width: 45,
              height: 45,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: _handleSwap,
                icon: const Icon(Icons.swap_horiz, color: Colors.white, size: 32),
                padding: EdgeInsets.zero,
              ),
            ),
          ),
        ),
        Positioned(
          top: 2,
          left: 0,
          right: 0,
          child: Row(
            children: [
              Expanded(
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    decoration: BoxDecoration(
                      color: AppColors.cardBackgroundTransparent,
                    ),
                    child: Text(
                      'TENGO',
                      style: AppTextStyles.smallLabel,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 60),
              Expanded(
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    decoration: BoxDecoration(
                      color: AppColors.cardBackgroundTransparent,
                    ),
                    child: Text(
                      'QUIERO',
                      style: AppTextStyles.smallLabel,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
