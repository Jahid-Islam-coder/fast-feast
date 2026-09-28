import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'category_widget.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> categories = [
      {'_id': '1', 'title': 'Burger', 'value': 'burger', 'icon': 'assets/images/burger.png', 'image': 'assets/images/burger.png'},
      {'_id': '2', 'title': 'Pizza', 'value': 'pizza', 'icon': 'assets/images/pizza.png', 'image': 'assets/images/pizza.png'},
      {'_id': '3', 'title': 'Pasta', 'value': 'pasta', 'icon': 'assets/images/pasta.png', 'image': 'assets/images/pasta.png'},
      {'_id': '4', 'title': 'Cake', 'value': 'cake', 'icon': 'assets/images/cake.png', 'image': 'assets/images/cake.png'},

    ];

    return Container(
      height: 80.h,
      padding: EdgeInsets.only(left: 20.w, top: 8.h),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return CategoryWidget(category: categories[index]);
        },
      ),
    );
  }
}
