import 'package:fastfeast/common/custom_appbar.dart';
import 'package:fastfeast/common/custom_container.dart';
import 'package:fastfeast/common/heading.dart';
import 'package:fastfeast/views/home/recommendations_page.dart';
import 'package:fastfeast/views/home/widgets/category_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'nearby_restaurants_list.dart';

// home page showing top bar, categories and nearby places
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECE3F7),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.h),
        child: const CustomAppbar(),
      ),

      body: SafeArea(
        child: CustomContainer(
          containerContent: SingleChildScrollView(
            child: Column(
              children: [
                // food categories list
                const CategoryList(),
                
                // recommendations header
                Heading(
                  text: 'Try Something New',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RecommendationsPage(),
                      ),
                    );
                  },
                ),
                
                // nearby restaurants list
                const NearbyRestaurantsList(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
