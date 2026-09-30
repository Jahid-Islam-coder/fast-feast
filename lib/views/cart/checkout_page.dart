import 'package:fastfeast/controllers/provider/payment_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../common/app_style.dart';
import '../../common/reusable_appbar.dart';
import '../../common/reusable_text.dart';
import '../../controllers/provider/review_cart_provider.dart';
import '../../controllers/provider/order_provider.dart';
import '../../models/review_cart_model.dart';
import 'order_success_page.dart';

class CheckoutPage extends StatelessWidget {
  final List<ReviewCartModel> items;
  final String? restaurantId;
  const CheckoutPage({super.key, required this.items, this.restaurantId});

  double _getSubtotal() {
    double subtotal = 0;
    for (var item in items) {
      subtotal += item.cartPrice * item.cartQuantity;
    }
    return double.parse(subtotal.toStringAsFixed(2));
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final paymentProvider = Provider.of<PaymentProvider>(context);
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);

    double subtotal = _getSubtotal();
    double deliveryFee = 2.0;
    double total = subtotal + deliveryFee;

    return Scaffold(
      backgroundColor: const Color(0xFFECE3F7),
      appBar: CustomReusableAppBar(
        backgroundColor: const Color(0xFFECE3F7),
        elevation: 0,
        titleText: "Checkout",
        titleStyle: appStyle(30.sp, Colors.black, FontWeight.bold),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ReusableText(
              text: "Order Summary",
              style: appStyle(30.sp, Colors.black, FontWeight.w500),
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
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                             ReusableText(
                                    text: item.cartName,
                                    style: appStyle(26.sp, Colors.black, FontWeight.bold),
                                  ),


                              SizedBox(height: 5.h),
                              ReusableText(
                                text: "\$${item.cartPrice}",
                                style: appStyle(26.sp, Color(0xffD97706), FontWeight.bold),
                              ),
                              SizedBox(height: 10.h),
                              Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8.w),
                                    child: Row(
                                      children: [
                                        ReusableText(
                                          text: "Item Quantity: ",
                                          style: appStyle(24.sp, Colors.grey,
                                              FontWeight.w600),
                                        ),
                                        ReusableText(
                                          text: "${item.cartQuantity}",
                                          style: appStyle(18, Colors.black,
                                              FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const Divider(),
            ReusableText(
              text: "Select Payment Method",
              style: appStyle(33.sp, Colors.black, FontWeight.bold),
            ),
            SizedBox(height: 20.h),
            _buildPaymentOption(
              context,
              method: PaymentMethod.stripe,
              title: "Stripe (Card)",
              icon: Icons.credit_card,
              provider: paymentProvider,
            ),
            _buildPaymentOption(
              context,
              method: PaymentMethod.cod,
              title: "Cash on Delivery",
              icon: Icons.money,
              provider: paymentProvider,
            ),
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(15.r),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Subtotal",
                        style: appStyle(30.sp, Colors.grey, FontWeight.w500),
                      ),
                      Text(
                        "\$${subtotal.toStringAsFixed(2)}",
                        style: appStyle(30.sp, Color(0xffD97706), FontWeight.w600),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Delivery Fee",
                        style: appStyle(30.sp, Colors.grey, FontWeight.w500),
                      ),
                      Text(
                        "\$${deliveryFee.toStringAsFixed(2)}",
                        style: appStyle(30.sp, Colors.grey, FontWeight.w600),
                      ),
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total",
                        style: appStyle(30.sp, Colors.black, FontWeight.bold),
                      ),
                      Text(
                        "\$${total.toStringAsFixed(2)}",
                        style: appStyle(
                          30.sp,
                          const Color(0xFF8a2ae4),
                          FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            SizedBox(
              width: double.infinity,
              height: 55.h,
              child: ElevatedButton(
                onPressed:
                    paymentProvider.isProcessing || orderProvider.isLoading
                    ? null
                    : () async {
                        bool success = await paymentProvider.processPayment(
                          total,
                        );
                        if (success && context.mounted) {
                          await orderProvider.addOrder(
                            cartItems: items,
                            totalAmount: total,
                            restaurantId: restaurantId,
                          );
                          if (context.mounted) {
                            for (var item in items) {
                              cartProvider.deleteCartItem(item.cartId);
                            }
                            _showPaymentStatus(
                              context,
                              true,
                              restaurantId,
                              null,
                            );
                          }
                        } else if (context.mounted) {
                          _showPaymentStatus(
                            context,
                            false,
                            null,
                            paymentProvider.errorMessage,
                          );
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8a2ae4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                ),
                child: (paymentProvider.isProcessing || orderProvider.isLoading)
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        "Place Order",
                        style: appStyle(34.sp, Colors.white, FontWeight.bold),
                      ),
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  void _showPaymentStatus(
    BuildContext context,
    bool isSuccess,
    String? restaurantId, [
    String? errorMessage,
  ]) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSuccess ? Icons.check_circle : Icons.error,
              color: isSuccess ? Colors.green : Colors.red,
              size: 60.sp,
            ),
            SizedBox(height: 20.h),
            Text(
              isSuccess ? "Payment Successful!" : "Payment Failed",
              style: appStyle(20.sp, Colors.black, FontWeight.bold),
            ),
            SizedBox(height: 10.h),
            Text(
              isSuccess
                  ? "Your order has been placed successfully."
                  : (errorMessage ??
                        "There was an issue processing your payment. Please try again."),
              textAlign: TextAlign.center,
              style: appStyle(14.sp, Colors.grey, FontWeight.w400),
            ),
            SizedBox(height: 30.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  if (isSuccess) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            OrderSuccessPage(restaurantId: restaurantId),
                      ),
                      (route) => false,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isSuccess ? Colors.green : Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                child: Text(
                  "Continue",
                  style: appStyle(16.sp, Colors.white, FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption(
    BuildContext context, {
    required PaymentMethod method,
    required String title,
    required IconData icon,
    required PaymentProvider provider,
  }) {
    bool isSelected = provider.selectedMethod == method;
    return GestureDetector(
      onTap: () => provider.setPaymentMethod(method),
      child: Container(
        margin: EdgeInsets.only(bottom: 15.h),
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? const Color(0xFF8a2ae4) : Colors.grey.shade300,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12.r),
          color: isSelected
              ? const Color(0xFF8a2ae4).withOpacity(0.05)
              : Colors.white,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFF8a2ae4) : Colors.grey,
            ),
            SizedBox(width: 15.w),
            Text(
              title,
              style: appStyle(
                26.sp,
                isSelected ? const Color(0xFF644AB5) : Colors.black,
                FontWeight.w600,
              ),
            ),
            const Spacer(),
            if (isSelected)
              const Icon(Icons.check_circle, color: Color(0xFF8a2ae4)),
          ],
        ),
      ),
    );
  }
}
