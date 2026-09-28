import 'package:cached_network_image/cached_network_image.dart';
import 'package:fastfeast/common/shimmers/shimmer_widget.dart';
import 'package:fastfeast/models/foods_model.dart';
import 'package:fastfeast/views/food/food_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import '../../../controllers/provider/review_cart_provider.dart';
import '../../../common/custom_snackbar.dart';

class MenuItemCard extends StatelessWidget {
  final FoodModel item;
  final void Function()? onTap;
  const MenuItemCard({super.key, required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () {
        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.fade,
            child: FoodPage(food: item),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
                child: CachedNetworkImage(
                  imageUrl: item.image,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => ShimmerWidget(
                    shimmerWidth: double.infinity,
                    shimmerHeight: double.infinity,
                    shimmerRadius: 0,
                    padding: EdgeInsets.zero,
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.error, color: Colors.red),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "\$${item.price.toStringAsFixed(2)}",
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.green[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          final cartProvider = Provider.of<CartProvider>(context, listen: false);
                          int currentQty = cartProvider.getQuantity(item.id);
                          await cartProvider.addToCart(
                            cartId: item.id,
                            cartName: item.name,
                            cartImage: item.image,
                            cartPrice: item.price,
                            cartQuantity: currentQty + 1,
                            restaurantId: item.restaurantId,
                          );
                          if (context.mounted) {
                            showCustomSnackBar(context, "Item added to cart successfully!");
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.all(6.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFF8a2ae4),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Icon(Icons.add, color: Colors.white, size: 16.sp),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

