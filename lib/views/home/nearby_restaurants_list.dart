import 'package:fastfeast/models/restaurants_model.dart';
import 'package:fastfeast/views/home/widgets/restaurant_widget.dart';
import 'package:fastfeast/views/home/widgets/restaurants_page.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import '../../controllers/provider/restaurant_provider.dart';
import '../../common/shimmers/nearby_shimmer.dart';

class NearbyRestaurantsList extends StatelessWidget {
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  const NearbyRestaurantsList({
    super.key,
    this.shrinkWrap = false,
    this.physics,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<RestaurantProvider>(
      builder: (context, restaurantProvider, child) {
        if (restaurantProvider.restaurants.isEmpty) {
          if (restaurantProvider.isLoading) {
            return const Center(
              child: NearbyShimmer(),
            );
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.restaurant_menu, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  "No nearby restaurants found",
                  style: TextStyle(color: Colors.grey[600], fontSize: 16),
                ),
              ],
            ),
          );
        } else {
          return ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: shrinkWrap,
            physics: physics,
            itemCount: restaurantProvider.restaurants.length,
            itemBuilder: (context, index) {
              RestaurantDetailModel restaurant = restaurantProvider.restaurants[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: RestaurantDetailScreen(
                        restaurant: restaurant,
                        restaurantId: restaurant.id,
                      ),
                    ),
                  );
                },
                child: RestaurantWidget(restaurant: restaurant),
              );
            },
          );
        }
      },
    );
  }
}
