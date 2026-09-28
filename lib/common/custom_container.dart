import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// rounded top white container used across pages
class CustomContainer extends StatelessWidget {
  final Widget containerContent;

  const CustomContainer({super.key, required this.containerContent});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFECE3F7),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.r),
          topRight: Radius.circular(30.r),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.r),
          topRight: Radius.circular(30.r),
        ),
        child: containerContent,
      ),
    );
  }
}
