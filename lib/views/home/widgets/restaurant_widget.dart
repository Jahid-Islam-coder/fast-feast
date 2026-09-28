import 'package:cached_network_image/cached_network_image.dart';
import 'package:fastfeast/common/app_style.dart';
import 'package:fastfeast/common/reusable_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../models/restaurants_model.dart';

// restaurant card widget for lists
class RestaurantWidget extends StatelessWidget {
  final RestaurantDetailModel restaurant;
  final void Function()? onTap;

  const RestaurantWidget({super.key, required this.restaurant, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 8.h),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(30.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4.r,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // banner image & avatar icon
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
                    child: CachedNetworkImage(
                      imageUrl: restaurant.image,
                      height: 150.h,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        height: 160.h,
                        color: Colors.grey[200],
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) => Container(
                        height: 160.h,
                        color: Colors.grey[200],
                        child: const Icon(Icons.error, color: Colors.red),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 10.w,
                    top: 10.h,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50.r),
                      child: CachedNetworkImage(
                        imageUrl: restaurant.image,
                        fit: BoxFit.cover,
                        width: 35.w,
                        height: 35.h,
                        placeholder: (context, url) => Container(
                          width: 35.w,
                          height: 35.h,
                          color: Colors.grey[200],
                        ),
                        errorWidget: (context, url, error) => Container(
                          width: 35.w,
                          height: 35.h,
                          color: Colors.grey[200],
                          child: Icon(Icons.restaurant, size: 20.sp),
                        ),
                      ),
                    ),
                  )
                ],
              ),

              // text details section (name, address, rating)
              Padding(
                padding: EdgeInsets.all(12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ReusableText(
                      text: restaurant.name,
                      style: appStyle(30.sp, Colors.black, FontWeight.bold),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            restaurant.address,
                            style: appStyle(20.sp, Colors.grey, FontWeight.normal),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        ReusableText(
                          text: 'Delivery time : 30 mins',
                          style: appStyle(20.sp, Colors.black, FontWeight.w600),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        RatingBarIndicator(
                          itemBuilder: (context, index) =>
                          const Icon(Icons.star, color: Colors.orange,),
                          itemCount: 5,
                          rating: double.tryParse(restaurant.rating.toString()) ?? 0.0,
                          itemSize: 18.h,
                        ),
                        SizedBox(width: 8.w,),
                        ReusableText(
                          text: "${restaurant.rating} + reviews",
                          style: appStyle(11, Colors.grey, FontWeight.w500),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
