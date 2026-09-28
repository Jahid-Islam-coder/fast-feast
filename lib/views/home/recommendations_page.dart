import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../common/app_style.dart';
import '../../common/custom_container.dart';
import '../../common/reusable_appbar.dart';
import '../../common/shimmers/foodlist_shimmer.dart';
import '../../controllers/provider/restaurant_menu_provider.dart';
import '../../controllers/provider/restaurant_provider.dart';
import 'widgets/food_widget.dart';

class RecommendationsPage extends StatefulWidget {
  const RecommendationsPage({super.key});

  @override
  State<RecommendationsPage> createState() => _RecommendationsPageState();
}

class _RecommendationsPageState extends State<RecommendationsPage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadRecommendations();
    });
  }

  Future<void> _loadRecommendations({bool forceRefresh = false}) async {
    final restaurantProvider = context.read<RestaurantProvider>();
    final menuProvider = context.read<RestaurantMenuProvider>();

    if (restaurantProvider.restaurants.isNotEmpty) {
      final restaurantIds = restaurantProvider.restaurants.map((res) => res.id).toList();
      await menuProvider.fetchMenusForRestaurants(restaurantIds, forceRefresh: forceRefresh);
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: CustomReusableAppBar(
        elevation: 0,
        titleText: "Recommendations",
        titleStyle: appStyle(30.sp, Colors.black, FontWeight.bold),
      ),
      body: SafeArea(
        child: CustomContainer(
          containerContent: RefreshIndicator(
            onRefresh: () => _loadRecommendations(forceRefresh: true),
            color: const Color(0xFF8a2ae4),
            child: Consumer<RestaurantMenuProvider>(
              builder: (context, menuProvider, child) {
                if (_isLoading && menuProvider.foods.isEmpty) {
                  return Padding(
                    padding: EdgeInsets.only(top: 10.h),
                    child: const FoodsListShimmer(),
                  );
                }

                if (menuProvider.foods.isEmpty) {
                  return ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      SizedBox(height: 150.h),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.fastfood, size: 64.sp, color: Colors.grey[400]),
                            SizedBox(height: 16.h),
                            Text(
                              "No recommendations found",
                              style: appStyle(18.sp, Colors.grey[600]!, FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }

                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                  child: GridView.builder(
                    physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 14.h,
                      crossAxisSpacing: 14.w,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: menuProvider.foods.length,
                    itemBuilder: (context, index) {
                      final food = menuProvider.foods[index];
                      return MenuItemCard(item: food);
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}


