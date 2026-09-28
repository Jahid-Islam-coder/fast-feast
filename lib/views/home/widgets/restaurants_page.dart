
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fastfeast/common/app_style.dart';
import 'package:fastfeast/common/shimmers/shimmer_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controllers/provider/restaurant_menu_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../models/restaurants_model.dart';
import '../../../common/shimmers/foodlist_shimmer.dart';
import 'food_widget.dart';

class RestaurantDetailScreen extends StatefulWidget {

  final RestaurantDetailModel restaurant;
  final String? restaurantId;

  const RestaurantDetailScreen({super.key,
    required this.restaurant,
    this.restaurantId
  });

  @override
  State<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final resId = widget.restaurantId ?? widget.restaurant.id;
      context.read<RestaurantMenuProvider>().fetchRestaurantMenu(resId);
    });
  }

  Future<void> _onRefresh() async {
    final resId = widget.restaurantId ?? widget.restaurant.id;
    await context.read<RestaurantMenuProvider>().fetchRestaurantMenu(resId, forceRefresh: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECE3F7),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        color: const Color(0xFF8a2ae4),
        child: CustomScrollView(
          slivers: [
            // restaurant banner
            SliverAppBar(
              expandedHeight: 200.h,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: CachedNetworkImage(
                  imageUrl: widget.restaurant.image,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => ShimmerWidget(
                    shimmerWidth: double.infinity,
                    shimmerHeight: 200.h,
                    shimmerRadius: 0,
                    padding: EdgeInsets.zero,
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.error, color: Colors.red),
                  ),
                ),
              ),
            ),

            // restaurant info section
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.restaurant.name,
                      style: appStyle(30.sp, Colors.black, FontWeight.bold),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      widget.restaurant.address,
                      style: appStyle(20.sp, Colors.grey, FontWeight.normal),
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Color(0xffD97706), size: 20),
                        SizedBox(width: 5.w),
                        Text(
                          "${widget.restaurant.rating} Rating",
                          style: appStyle(24.sp, Colors.black, FontWeight.w500),
                        ),
                      ],
                    ),
                    const Divider(),
                    Text(
                      "Full Menus",
                      style: appStyle(28.sp, Colors.black, FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),

            Consumer<RestaurantMenuProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading && provider.restaurantFoods.isEmpty) {
                  return const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: FoodsListShimmer(),
                    ),
                  );
                } else if (provider.restaurantFoods.isEmpty) {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Text(
                        "No menu items available",
                        style: appStyle(18.sp, Colors.grey[600]!, FontWeight.w500),
                      ),
                    ),
                  );
                } else {
                  return SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: 30.w),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 14.h,
                        crossAxisSpacing: 30.w,
                        childAspectRatio: 0.85,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return MenuItemCard(
                            item: provider.restaurantFoods[index],
                          );
                        },
                        childCount: provider.restaurantFoods.length,
                      ),
                    ),
                  );
                }
              },
            ),

            SliverToBoxAdapter(child: SizedBox(height: 30.h)),
          ],
        ),
      ),
    );
  }
}


