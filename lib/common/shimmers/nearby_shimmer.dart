import 'package:fastfeast/common/shimmers/shimmer_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NearbyShimmer extends StatelessWidget{
  const NearbyShimmer({super.key});




  @override
  Widget build(BuildContext context) {
    return Container(
      height: 190.h,
      margin: EdgeInsets.symmetric(horizontal: 22.w, vertical: 8.h),
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.zero,
          itemCount: 6,
          itemBuilder: (context, index) {
            return ShimmerWidget(
              shimmerWidth: double.infinity,
              shimmerRadius: 12,
              shimmerHeight: 190,
            );
          }

      ),
    );
  }




}