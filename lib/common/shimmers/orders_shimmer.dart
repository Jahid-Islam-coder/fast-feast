import 'package:fastfeast/common/shimmers/shimmer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrdersShimmer extends StatelessWidget {
  final int itemCount;

  const OrdersShimmer({
    super.key,
    this.itemCount = 3,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(15.w),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(bottom: 15.h),
          padding: EdgeInsets.all(15.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // order id & status badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ShimmerWidget(
                    shimmerWidth: 120.w,
                    shimmerHeight: 22.h,
                    shimmerRadius: 6.r,
                    padding: EdgeInsets.zero,
                  ),
                  ShimmerWidget(
                    shimmerWidth: 80.w,
                    shimmerHeight: 24.h,
                    shimmerRadius: 8.r,
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              ShimmerWidget(
                shimmerWidth: 160.w,
                shimmerHeight: 14.h,
                shimmerRadius: 4.r,
                padding: EdgeInsets.zero,
              ),
              SizedBox(height: 10.h),
              const Divider(),
              SizedBox(height: 5.h),

              // order item row
              Row(
                children: [
                  ShimmerWidget(
                    shimmerWidth: 110.w,
                    shimmerHeight: 60.h,
                    shimmerRadius: 8.r,
                    padding: EdgeInsets.zero,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerWidget(
                          shimmerWidth: 140.w,
                          shimmerHeight: 16.h,
                          shimmerRadius: 4.r,
                          padding: EdgeInsets.zero,
                        ),
                        SizedBox(height: 6.h),
                        ShimmerWidget(
                          shimmerWidth: 60.w,
                          shimmerHeight: 14.h,
                          shimmerRadius: 4.r,
                          padding: EdgeInsets.zero,
                        ),
                      ],
                    ),
                  ),
                  ShimmerWidget(
                    shimmerWidth: 50.w,
                    shimmerHeight: 16.h,
                    shimmerRadius: 4.r,
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),

              SizedBox(height: 10.h),
              const Divider(),
              SizedBox(height: 8.h),

              // total price row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ShimmerWidget(
                    shimmerWidth: 100.w,
                    shimmerHeight: 18.h,
                    shimmerRadius: 4.r,
                    padding: EdgeInsets.zero,
                  ),
                  ShimmerWidget(
                    shimmerWidth: 70.w,
                    shimmerHeight: 18.h,
                    shimmerRadius: 4.r,
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),

              SizedBox(height: 15.h),
              // action button
              ShimmerWidget(
                shimmerWidth: double.infinity,
                shimmerHeight: 45.h,
                shimmerRadius: 10.r,
                padding: EdgeInsets.zero,
              ),
            ],
          ),
        );
      },
    );
  }
}
