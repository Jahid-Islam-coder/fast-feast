import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../common/app_style.dart';
import '../../common/reusable_text.dart';
import '../../controllers/provider/review_cart_provider.dart';
import '../../models/review_cart_model.dart';

import 'checkout_page.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final TextEditingController _instructionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CartProvider>().getCartData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECE3F7),
      body: SafeArea(
        child: Consumer<CartProvider>(
          builder: (context, cartProvider, child) {
            int totalCartCount = cartProvider.cartList.fold(0, (sum, item) => sum + item.cartQuantity);
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ReusableText(
                    text: "$totalCartCount items in cart",
                    style: appStyle(40.sp, Colors.black.withOpacity(0.8), FontWeight.bold),
                  ),
                  SizedBox(height: 20.h),
                  Expanded(
                    child: ListView.builder(
                      itemCount: cartProvider.cartList.length,
                      itemBuilder: (context, index) {
                        ReviewCartModel item = cartProvider.cartList[index];
                        return Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: 16.h),
                              height: 60.h,
                              width: 110.w,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16.r),
                                child: Image.network(
                                  item.cartImage,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(width: 15.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: ReusableText(
                                      text: item.cartName,
                                      style: appStyle(26.sp, Colors.black, FontWeight.w600),
                                    ),
                                  ),
                                  SizedBox(height: 5.h),
                                  ReusableText(
                                    text: "\$${item.cartPrice}",
                                    style: appStyle(26.sp, Color(0xffD97706), FontWeight.bold),
                                  ),
                                  SizedBox(height: 10.h),
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          if (item.cartQuantity > 1) {
                                            cartProvider.addToCart(
                                              cartId: item.cartId,
                                              cartName: item.cartName,
                                              cartImage: item.cartImage,
                                              cartPrice: item.cartPrice,
                                              cartQuantity: item.cartQuantity - 1,
                                              restaurantId: item.restaurantId,
                                            );
                                          }
                                        },
                                        icon: Icon(Icons.remove_circle_outline,
                                            size: 24.sp,
                                            color: const Color(0xFF644AB5)),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8.w),
                                        child: ReusableText(
                                          text: "${item.cartQuantity}",
                                          style: appStyle(18, Colors.black,
                                              FontWeight.bold),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          cartProvider.addToCart(
                                            cartId: item.cartId,
                                            cartName: item.cartName,
                                            cartImage: item.cartImage,
                                            cartPrice: item.cartPrice,
                                            cartQuantity: item.cartQuantity + 1,
                                            restaurantId: item.restaurantId,
                                          );
                                        },
                                        icon: Icon(Icons.add_circle_outline,
                                            size: 24.sp,
                                            color: const Color(0xFF644AB5)),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () => cartProvider.deleteCartItem(item.cartId),
                              child: Icon(Icons.cancel_outlined, color: Colors.red.shade400, size: 24.sp),
                            ),
                          ],
                        );
                      },
                    ),
                  ),

                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ReusableText(
                        text: "Subtotal :",
                        style: appStyle(30.sp, Colors.black, FontWeight.bold),
                      ),
                      ReusableText(
                        text: "\$${cartProvider.getTotalPrice().toStringAsFixed(2)}",
                        style: appStyle(30.sp, Color(0xffD97706), FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  SizedBox(
                    width: double.infinity,
                    height: 55.h,
                    child: ElevatedButton(
                      onPressed: () {
                        String? restaurantId;
                        if (cartProvider.cartList.isNotEmpty) {
                          restaurantId = cartProvider.cartList.first.restaurantId;
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CheckoutPage(
                              items: cartProvider.cartList,
                              restaurantId: restaurantId,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8a2ae4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                      ),
                      child: ReusableText(
                        text: "Checkout",
                        style: appStyle(30.sp, Colors.white, FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
