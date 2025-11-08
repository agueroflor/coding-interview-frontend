import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoading extends StatelessWidget {
  const ShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          _ShimmerLine(width: double.infinity, height: 16),
          SizedBox(height: 12),
          _ShimmerLine(width: double.infinity, height: 16),
          SizedBox(height: 12),
          _ShimmerLine(width: double.infinity, height: 16),
        ],
      ),
    );
  }
}

class _ShimmerLine extends StatelessWidget {
  final double width;
  final double height;

  const _ShimmerLine({
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}
