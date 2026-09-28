import 'package:fastfeast/common/shimmers/shimmer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FoodPageShimmer extends StatelessWidget {
  const FoodPageShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8a2ae4),
      body: Stack(
        children: [
          // food image placeholder
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 0.45.sh,
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(top: 40.h),
                child: ShimmerWidget(
                  shimmerWidth: 0.8.sw,
                  shimmerHeight: 0.35.sh,
                  shimmerRadius: 20.r,
                  padding: EdgeInsets.zero,
                ),
              ),
            ),
          ),

          // back button placeholder
          Positioned(
            top: 50.h,
            left: 20.w,
            child: ShimmerWidget(
              shimmerWidth: 30.w,
              shimmerHeight: 30.h,
              shimmerRadius: 15.r,
              padding: EdgeInsets.zero,
            ),
          ),

          // bottom details container
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 0.6.sh,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(100.r),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // price loader
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ShimmerWidget(
                          shimmerWidth: 90.w,
                          shimmerHeight: 35.h,
                          shimmerRadius: 8.r,
                          padding: EdgeInsets.zero,
                        ),
                      ],
                    ),

                    SizedBox(height: 20.h),

                    // title and quantity loader
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ShimmerWidget(
                          shimmerWidth: 180.w,
                          shimmerHeight: 30.h,
                          shimmerRadius: 8.r,
                          padding: EdgeInsets.zero,
                        ),
                        ShimmerWidget(
                          shimmerWidth: 100.w,
                          shimmerHeight: 40.h,
                          shimmerRadius: 20.r,
                          padding: EdgeInsets.zero,
                        ),
                      ],
                    ),

                    SizedBox(height: 20.h),

                    // description lines loader
                    ShimmerWidget(
                      shimmerWidth: double.infinity,
                      shimmerHeight: 16.h,
                      shimmerRadius: 4.r,
                      padding: EdgeInsets.zero,
                    ),
                    SizedBox(height: 8.h),
                    ShimmerWidget(
                      shimmerWidth: 250.w,
                      shimmerHeight: 16.h,
                      shimmerRadius: 4.r,
                      padding: EdgeInsets.zero,
                    ),
                    SizedBox(height: 8.h),
                    ShimmerWidget(
                      shimmerWidth: 180.w,
                      shimmerHeight: 16.h,
                      shimmerRadius: 4.r,
                      padding: EdgeInsets.zero,
                    ),

                    const Spacer(),

                    // bottom action buttons
                    Row(
                      children: [
                        Expanded(
                          child: ShimmerWidget(
                            shimmerWidth: double.infinity,
                            shimmerHeight: 55.h,
                            shimmerRadius: 20.r,
                            padding: EdgeInsets.zero,
                          ),
                        ),
                        SizedBox(width: 15.w),
                        Expanded(
                          child: ShimmerWidget(
                            shimmerWidth: double.infinity,
                            shimmerHeight: 55.h,
                            shimmerRadius: 20.r,
                            padding: EdgeInsets.zero,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
