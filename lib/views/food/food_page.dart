import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../common/app_style.dart';
import '../../common/custom_snackbar.dart';
import '../../common/shimmers/food_page_shimmer.dart';
import '../../common/shimmers/shimmer_widget.dart';
import '../../controllers/provider/review_cart_provider.dart';
import '../../models/foods_model.dart';
import '../../models/review_cart_model.dart';
import '../cart/checkout_page.dart';

class FoodPage extends StatefulWidget {
  final FoodModel food;
  const FoodPage({super.key, required this.food});

  @override
  State<FoodPage> createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {
  int quantity = 1;
  bool _isAddingToCart = false;
  bool _isBuyingNow = false;
  bool _isLoadingPage = true;

  @override
  void initState() {
    super.initState();
    _loadExistingQuantity();
    _initPageLoading();
  }

  void _initPageLoading() {
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) {
        setState(() {
          _isLoadingPage = false;
        });
      }
    });
  }

  void _loadExistingQuantity() {
    final cartProvider = context.read<CartProvider>();
    int existingQty = cartProvider.getQuantity(widget.food.id);
    if (existingQty > 0) {
      setState(() => quantity = existingQty);
    }
  }

  void _updateQuantity(int newQty) {
    setState(() {
      quantity = newQty;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingPage) {
      return const FoodPageShimmer();
    }

    return Scaffold(
      backgroundColor: const Color(0xFF8a2ae4),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          return Stack(
            children: [
              // food image header
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 0.45.sh,
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 40.h),
                    child: CachedNetworkImage(
                      imageUrl: widget.food.image,
                      fit: BoxFit.contain,
                      width: 0.8.sw,
                      errorWidget: (context, url, error) => const Icon(
                        Icons.error_outline,
                        color: Colors.white,
                        size: 50,
                      ),
                    ),
                  ),
                ),
              ),

              // back button
              Positioned(
                top: 50.h,
                left: 20.w,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                    size: 24.sp,
                  ),
                ),
              ),

              // details sheet
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 0.6.sh,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFECE3F7),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(100.r),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // price tag
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: 20.w),
                              child: Text(
                                "\$${widget.food.price}",
                                style: appStyle(40.sp, const Color(0xffD97706), FontWeight.bold),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 20.h),

                        // title and quantity selector
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                widget.food.name,
                                style: appStyle(36.sp, Colors.black, FontWeight.bold),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(width: 15.w),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 5.w),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(30.r),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    constraints: const BoxConstraints(),
                                    padding: EdgeInsets.all(8.w),
                                    onPressed: () {
                                      if (quantity > 1) _updateQuantity(quantity - 1);
                                    },
                                    icon: Icon(Icons.remove_circle_outline,
                                        size: 24.sp, color: Colors.grey),
                                  ),
                                  Text(
                                    "$quantity",
                                    style: appStyle(20, Colors.black, FontWeight.bold),
                                  ),
                                  IconButton(
                                    constraints: const BoxConstraints(),
                                    padding: EdgeInsets.all(8.w),
                                    onPressed: () => _updateQuantity(quantity + 1),
                                    icon: Icon(Icons.add_circle_outline,
                                        size: 24.sp,
                                        color: const Color(0xFF8a2ae4)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 20.h),

                        // food description
                        Text(
                          widget.food.description,
                          style: appStyle(26.sp, Colors.grey.shade600, FontWeight.normal),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Spacer(),

                        // cart and buy buttons
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 55.h,
                                child: ElevatedButton(
                                  onPressed: (_isAddingToCart || _isBuyingNow) ? null : () async {
                                    setState(() => _isAddingToCart = true);
                                    await cartProvider.addToCart(
                                      cartId: widget.food.id,
                                      cartName: widget.food.name,
                                      cartImage: widget.food.image,
                                      cartPrice: widget.food.price,
                                      cartQuantity: quantity,
                                      restaurantId: widget.food.restaurantId,
                                    );
                                    if (context.mounted) {
                                      setState(() => _isAddingToCart = false);
                                      showCustomSnackBar(context, "Item added to cart successfully!");
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    side: const BorderSide(color: Color(0xFF8a2ae4), width: 2),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.r),
                                    ),
                                  ),
                                  child: _isAddingToCart 
                                    ? const CircularProgressIndicator(color: Color(0xFF8a2ae4))
                                    : Text(
                                        "Add to Cart",
                                        style: appStyle(24.sp, const Color(0xFF8a2ae4), FontWeight.bold),
                                      ),
                                ),
                              ),
                            ),
                            SizedBox(width: 15.w),
                            Expanded(
                              child: SizedBox(
                                height: 55.h,
                                child: ElevatedButton(
                                  onPressed: (_isAddingToCart || _isBuyingNow) ? null : () async {
                                    setState(() => _isBuyingNow = true);
                                    
                                    ReviewCartModel buyNowItem = ReviewCartModel(
                                      cartId: widget.food.id,
                                      cartName: widget.food.name,
                                      cartImage: widget.food.image,
                                      cartPrice: widget.food.price,
                                      cartQuantity: quantity,
                                      restaurantId: widget.food.restaurantId,
                                    );
                                    
                                    if (mounted) {
                                      setState(() => _isBuyingNow = false);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => CheckoutPage(
                                            items: [buyNowItem],
                                            restaurantId: widget.food.restaurantId,
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF8a2ae4),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.r),
                                    ),
                                  ),
                                  child: _isBuyingNow 
                                    ? const CircularProgressIndicator(color: Colors.white)
                                    : Text(
                                        "Buy Now",
                                        style: appStyle(24.sp, Colors.white, FontWeight.bold),
                                      ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
