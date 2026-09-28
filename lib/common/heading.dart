import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_style.dart';
import 'reusable_text.dart';

class Heading extends StatelessWidget {
  const Heading({super.key, required this.text, this.onTap});
  final String text;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ReusableText(
              text: text,
              style: appStyle(30.sp, Colors.black, FontWeight.bold),
            ),
          ),
          GestureDetector(
            onTap: onTap,
            child: Icon(
              Icons.grid_view_rounded,
              color: const Color(0xFF644AB5),
              size: 20.sp,
            ),
          )
        ],
      ),
    );
  }
}
