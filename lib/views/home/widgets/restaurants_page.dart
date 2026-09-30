
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fastfeast/common/app_style.dart';
import 'package:fastfeast/common/shimmers/shimmer_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controllers/provider/restaurant_menu_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../models/foods_model.dart';
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
  String _selectedCategory = 'all';

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

  List<Map<String, dynamic>> _getCategories(List<FoodModel> foods) {
    final List<Map<String, dynamic>> categoriesList = [
      {'_id': 'all', 'title': 'All', 'value': 'all', 'icon': Icons.restaurant_menu},
      {'_id': '1', 'title': 'Burger', 'value': 'burger', 'image': 'assets/images/burger.png'},
      {'_id': '2', 'title': 'Pizza', 'value': 'pizza', 'image': 'assets/images/pizza.png'},
      {'_id': '3', 'title': 'Pasta', 'value': 'pasta', 'image': 'assets/images/pasta.png'},
      {'_id': '4', 'title': 'Cake', 'value': 'cake', 'image': 'assets/images/cake.png'},
      {'_id': '5', 'title': 'Biryani', 'value': 'biryani', 'image': 'assets/images/biryani.png'},
    ];

    final existingValues = categoriesList.map((c) => c['value'] as String).toSet();
    for (var food in foods) {
      final catName = food.category.trim();
      if (catName.isNotEmpty && catName != "No Category") {
        final val = catName.toLowerCase();
        if (!existingValues.contains(val)) {
          existingValues.add(val);
          final formattedTitle = catName[0].toUpperCase() + catName.substring(1);
          categoriesList.add({
            '_id': val,
            'title': formattedTitle,
            'value': val,
            'icon': Icons.fastfood,
          });
        }
      }
    }

    return categoriesList;
  }

  Widget _buildCategoryIcon(Map<String, dynamic> category, bool isSelected) {
    if (category['image'] != null) {
      return SizedBox(
        width: 24.w,
        height: 24.h,
        child: Image.asset(
          category['image'] as String,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => Icon(
            Icons.fastfood,
            size: 20.sp,
            color: isSelected ? Colors.white : const Color(0xFF8a2ae4),
          ),
        ),
      );
    } else if (category['icon'] != null) {
      return Icon(
        category['icon'] as IconData,
        size: 20.sp,
        color: isSelected ? Colors.white : const Color(0xFF8a2ae4),
      );
    }
    return Icon(
      Icons.fastfood,
      size: 20.sp,
      color: isSelected ? Colors.white : const Color(0xFF8a2ae4),
    );
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

            // restaurant info & categories section
            SliverToBoxAdapter(
              child: Consumer<RestaurantMenuProvider>(
                builder: (context, provider, child) {
                  final categoriesList = _getCategories(provider.restaurantFoods);

                  return Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.restaurant.name,
                          style: appStyle(22, Colors.black, FontWeight.bold),
                        ),
                        SizedBox(height: 5.h),
                        Text(
                          widget.restaurant.address,
                          style: appStyle(14, Colors.grey, FontWeight.normal),
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Color(0xffD97706), size: 18),
                            SizedBox(width: 5.w),
                            Text(
                              "${widget.restaurant.rating} Rating",
                              style: appStyle(14, Colors.black, FontWeight.w500),
                            ),
                          ],
                        ),
                        const Divider(),
                        SizedBox(height: 5.h),
                        Text(
                          "Categories",
                          style: appStyle(18, Colors.black, FontWeight.bold),
                        ),
                        SizedBox(height: 10.h),

                        // Categories horizontal list
                        SizedBox(
                          height: 45.h,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            cacheExtent: 500,
                            itemCount: categoriesList.length,
                            separatorBuilder: (context, index) => SizedBox(width: 10.w),
                            itemBuilder: (context, index) {
                              final cat = categoriesList[index];
                              final isSelected = _selectedCategory == cat['value'];

                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (isSelected) {
                                      _selectedCategory = 'all';
                                    } else {
                                      _selectedCategory = cat['value'] as String;
                                    }
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                                  decoration: BoxDecoration(
                                    color: isSelected ? const Color(0xFF8a2ae4) : Colors.white,
                                    borderRadius: BorderRadius.circular(20.r),
                                    border: Border.all(
                                      color: isSelected ? const Color(0xFF8a2ae4) : Colors.grey[300]!,
                                    ),
                                    boxShadow: [
                                      if (isSelected)
                                        BoxShadow(
                                          color: const Color(0xFF8a2ae4).withValues(alpha: 0.3),
                                          blurRadius: 6,
                                          offset: const Offset(0, 2),
                                        )
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      _buildCategoryIcon(cat, isSelected),
                                      SizedBox(width: 8.w),
                                      Text(
                                        cat['title'] as String,
                                        style: appStyle(
                                          14,
                                          isSelected ? Colors.white : Colors.black87,
                                          isSelected ? FontWeight.bold : FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        SizedBox(height: 15.h),
                        const Divider(),
                        SizedBox(height: 5.h),
                        Text(
                          _selectedCategory == 'all' || _selectedCategory.isEmpty
                              ? "Full Menus"
                              : "${categoriesList.firstWhere((c) => c['value'] == _selectedCategory, orElse: () => {'title': _selectedCategory})['title']} Menu",
                          style: appStyle(20, Colors.black, FontWeight.bold),
                        ),
                      ],
                    ),
                  );
                },
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
                        style: appStyle(16, Colors.grey[600]!, FontWeight.w500),
                      ),
                    ),
                  );
                } else {
                  final filteredFoods = provider.restaurantFoods.where((item) {
                    if (_selectedCategory == 'all' || _selectedCategory.isEmpty) {
                      return true;
                    }
                    final cat = item.category.toLowerCase();
                    final name = item.name.toLowerCase();
                    final selected = _selectedCategory.toLowerCase();
                    return cat.contains(selected) || name.contains(selected);
                  }).toList();

                  if (filteredFoods.isEmpty) {
                    return SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
                          child: Text(
                            "No items available in this category",
                            style: appStyle(16, Colors.grey[600]!, FontWeight.w500),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    );
                  }

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
                            item: filteredFoods[index],
                          );
                        },
                        childCount: filteredFoods.length,
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



