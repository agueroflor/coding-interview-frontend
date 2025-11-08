import 'package:flutter/material.dart';

import 'package:currency_exchange/core/constants/app_colors.dart';

class CircularBackground extends StatelessWidget {
  const CircularBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return ClipRect(
      child: Stack(
        children: [
          Container(
            color: AppColors.backgroundBase,
          ),
          Positioned(
            left: size.width * 0.60,
            top: -size.height * 0.25,
            child: Container(
              width: size.width * 2.8,
              height: size.width * 2.8,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
