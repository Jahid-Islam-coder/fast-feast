import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../common/app_style.dart';
import '../../common/reusable_text.dart';
import '../../controllers/services/restaurants_services/restaurant_services.dart';
import '../bottom_navigation_bar/bottom_navigation_bar.dart';


class OrderSuccessPage extends StatefulWidget {
  final String? restaurantId;
  const OrderSuccessPage({super.key, this.restaurantId});

  @override
  State<OrderSuccessPage> createState() => _OrderSuccessPageState();
}

class _OrderSuccessPageState extends State<OrderSuccessPage> {
  double _rating = 0;
  bool _isRated = false;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _submitRating() async {
    if (widget.restaurantId == null || _rating == 0) return;

    setState(() => _isSubmitting = true);
    try {
      await RestaurantServices.updateRating(widget.restaurantId!, _rating);
      setState(() {
        _isRated = true;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Thank you for your rating!")),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF644AB5),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 40.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ReusableText(
              text: "Congratulations",
              style: appStyle(28.sp, Colors.white, FontWeight.bold),
            ),
            SizedBox(height: 10.h),
            Text(
              "Your Order is on its way!",
              style: appStyle(16.sp, Colors.white.withOpacity(0.7), FontWeight.w400),
            ),
            
            SizedBox(height: 30.h),
            
            // rating section
            if (widget.restaurantId != null && !_isRated) ...[
              ReusableText(
                text: "Rate your experience",
                style: appStyle(18.sp, Colors.white, FontWeight.w600),
              ),
              SizedBox(height: 15.h),
              RatingBar.builder(
                initialRating: 0,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.w),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  setState(() {
                    _rating = rating;
                  });
                },
              ),

              SizedBox(height: 20.h),
              if (_rating > 0)
                SizedBox(
                  width: 150.w,
                  height: 40.h,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _submitRating,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber[700],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    child: _isSubmitting
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text("Submit", style: appStyle(14.sp, Colors.white, FontWeight.bold)),
                  ),
                ),
            ] else if (_isRated) ...[
              Icon(Icons.check_circle, color: Colors.green, size: 50.sp),
              SizedBox(height: 10.h),
              ReusableText(
                text: "Rating Submitted!",
                style: appStyle(16.sp, Colors.white, FontWeight.w500),
              ),
            ],

            SizedBox(height: 40.h),
            
            // arrow divider
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 200.w,
                  height: 2.h,
                  color: Colors.white,
                ),
                Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20.sp),
              ],
            ),
            
            SizedBox(height: 40.h),
            
            ReusableText(
              text: "Enjoy",
              style: appStyle(32.sp, Colors.white, FontWeight.bold),
            ),
            ReusableText(
              text: "Your Food",
              style: appStyle(32.sp, Colors.white, FontWeight.bold),
            ),
            
            SizedBox(height: 60.h),
            
            if (widget.restaurantId != null) ...[
              SizedBox(
                width: double.infinity,
                height: 55.h,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8a2ae4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                  ),
                  child: Text(
                    "Track Your Order",
                    style: appStyle(18.sp, Colors.white, FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(height: 15.h),
            ],

            // back to menu button
            SizedBox(
              width: double.infinity,
              height: 55.h,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const MainScreen()),
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                ),
                child: Text(
                  "Back to Menu",
                  style: appStyle(18.sp, const Color(0xFF644AB5), FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
