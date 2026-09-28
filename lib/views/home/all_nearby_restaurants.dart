import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../common/app_style.dart';
import '../../common/custom_container.dart';
import '../../common/reusable_appbar.dart';
import 'nearby_restaurants_list.dart';

class AllNearbyRestaurants extends StatelessWidget {
  const AllNearbyRestaurants({super.key, this.restaurant});
  final dynamic restaurant;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF644AB5),
      appBar: CustomReusableAppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF644AB5),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        titleText: "Nearby Restaurants",
        titleStyle: appStyle(18.sp, Colors.white, FontWeight.w600),
      ),
      body: SafeArea(
        child: CustomContainer(
          containerContent: const Padding(
            padding: EdgeInsets.only(top: 10),
            child: NearbyRestaurantsList(),
          ),
        ),
      ),
    );
  }
}
