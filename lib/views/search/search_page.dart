import 'package:fastfeast/common/app_style.dart';
import 'package:fastfeast/controllers/provider/restaurant_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart' show PageTransition, PageTransitionType;
import 'package:provider/provider.dart';
import '../../controllers/provider/search_provider.dart';

import '../../models/foods_model.dart';
import '../../models/restaurants_model.dart';
import '../home/widgets/restaurants_page.dart';
import '../home/widgets/restaurant_widget.dart';


class SearchPage extends StatefulWidget {
 final List<FoodModel>? search;
  SearchPage({ this.search});
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xFFECE3F7),
            appBar: PreferredSize(
                preferredSize: Size(
                    100.w,
                    50.h),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 6.h
                  ),
                  child: SizedBox(
                    height: 100.h,
                    width: double.infinity,
                    child: TextField(
                      onChanged: (value){
                        final nearby = Provider.of<RestaurantProvider>(
                            context,listen: false).restaurants;
                        Provider.of<SearchProvider>(
                            context,listen: false).updateQuery(value, nearby);
                      },
                      controller: searchController,
                      cursorColor: Colors.black,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 5.w,
                          vertical: 0,
                        ),
                        hintText: "Search for items in the store",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.black,
                          ),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        ),


                      ),
                    ),
                  ),
                )
            ),
          body: Consumer<SearchProvider>(
              builder: (context, searchProvider, child) {
                if(searchController.text.isEmpty || searchProvider.filteredResults.isEmpty){
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        SizedBox(height: 20.h),
                        Text(
                          searchController.text.isEmpty 
                              ? 'Search for items in the store' 
                              : 'No results found', 
                          style: appStyle(18, Colors.grey, FontWeight.w500),
                        ),
                      ],
                    ),
                  );

                }else{
                  return ListView.builder(
                      itemCount: searchProvider.filteredResults.length,
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index){
                        RestaurantDetailModel restaurant = searchProvider.filteredResults[index];
                        return GestureDetector(
                            onTap: (){
                              Navigator.push(context, PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  child: RestaurantDetailScreen(
                                    restaurant: restaurant,
                                    restaurantId: restaurant.id,
                                  )));
                            },
                            child: RestaurantWidget(
                              restaurant: restaurant,
                            ),
                        );
                      });
                }
              })),
        );
  }
}
