import 'package:fastfeast/common/shimmers/shimmer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FoodsListShimmer extends StatelessWidget {
  final int itemCount;
  final double? height;

  const FoodsListShimmer({
    super.key,
    this.itemCount = 6,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    Widget listView = ListView.builder(
      scrollDirection: Axis.vertical,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(bottom: 12.h),
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            children: [
              // food image placeholder
              ShimmerWidget(
                shimmerWidth: 80.w,
                shimmerHeight: 80.h,
                shimmerRadius: 12.r,
                padding: EdgeInsets.zero,
              ),
              SizedBox(width: 12.w),
              // title and info placeholder
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerWidget(
                      shimmerWidth: 160.w,
                      shimmerHeight: 16.h,
                      shimmerRadius: 4.r,
                      padding: EdgeInsets.zero,
                    ),
                    SizedBox(height: 8.h),
                    ShimmerWidget(
                      shimmerWidth: 100.w,
                      shimmerHeight: 12.h,
                      shimmerRadius: 4.r,
                      padding: EdgeInsets.zero,
                    ),
                    SizedBox(height: 12.h),
                    ShimmerWidget(
                      shimmerWidth: 60.w,
                      shimmerHeight: 14.h,
                      shimmerRadius: 4.r,
                      padding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );

    if (height != null) {
      return SizedBox(
        height: height,
        child: listView,
      );
    }

    return listView;
  }
}
