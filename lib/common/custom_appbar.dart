import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../controllers/provider/user_provider.dart';
import '../views/address/set_address_page.dart';
import 'app_style.dart';
import 'reusable_text.dart';

// main appbar for home screen
class CustomAppbar extends StatelessWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      height: 110.h,
      child: Container(
        margin: EdgeInsets.only(top: 20.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 8.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ReusableText(
                        text: 'Welcome back!',
                        style: appStyle(34.sp, Colors.black, FontWeight.w500),
                      ),
                      Consumer<UserProvider>(
                        builder: (context, userProvider, child) {
                          final userData = userProvider.currentUserData;
                          final addressText = (userData != null && userData.address != null && userData.address!.isNotEmpty)
                              ? userData.address!
                              : "Set Delivery Address";
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SetAddressPage(isFromHome: true),
                                ),
                              );
                            },
                            child: SizedBox(
                              width: 200.w,
                              child: Text(
                                addressText,
                                overflow: TextOverflow.ellipsis,
                                style: appStyle(26.sp, Colors.black, FontWeight.bold),
                              ),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                )
              ],
            ),
            // profile icon on right
            CircleAvatar(
              radius: 22.r,
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: const Color(0xFF8a2ae4), size: 44.sp),
            ),
          ],
        ),
      ),
    );
  }
}
