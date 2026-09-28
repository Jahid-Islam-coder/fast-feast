import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  final double shimmerWidth;
  final double shimmerHeight;
  final double shimmerRadius;
  final EdgeInsetsGeometry? padding;

  const ShimmerWidget({
    super.key,
    required this.shimmerWidth,
    required this.shimmerHeight,
    required this.shimmerRadius,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: shimmerWidth,
      height: shimmerHeight,
      padding: padding ?? const EdgeInsets.only(right: 12, top: 8.0),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          width: shimmerWidth,
          height: shimmerHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(shimmerRadius),
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

