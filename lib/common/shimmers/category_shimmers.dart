import 'package:fastfeast/common/shimmers/shimmer_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryShimmer extends StatelessWidget{
  const CategoryShimmer({super.key});


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
          itemCount: 6,
          itemBuilder: (context, index) {

          return Column(
            children: [

          ]
          );

          }),
    );
  }



}