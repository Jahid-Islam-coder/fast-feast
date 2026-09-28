import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../common/app_style.dart';
import '../../../common/reusable_text.dart';
import '../../../controllers/provider/category_provider.dart';
import '../../../controllers/provider/restaurant_provider.dart';

class CategoryWidget extends StatelessWidget {
  final Map<String, dynamic> category;

  const CategoryWidget({super.key, required this.category});

  Widget _buildCategoryIcon(dynamic rawIcon, bool isSelected) {
    if (rawIcon == null) {
      return Icon(
        Icons.fastfood,
        size: 28.sp,
        color: isSelected ? Colors.white : const Color(0xFFFFFFFF),
      );
    }

    if (rawIcon is IconData) {
      return Icon(
        rawIcon,
        size: 28.sp,
        color: isSelected ? Colors.white : const Color(0xFFFFFFFF),
      );
    }

    if (rawIcon is ImageProvider) {
      return Image(
        image: rawIcon,
        width: 32.w,
        height: 32.h,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => Icon(
          Icons.fastfood,
          size: 28.sp,
          color: isSelected ? Colors.white : const Color(0xFFFFFFFF),
        ),
      );
    }

    if (rawIcon is String) {
      String imagePath = rawIcon.trim();

      if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
        return Image.network(
          imagePath,
          width: 32.w,
          height: 32.h,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => Icon(
            Icons.fastfood,
            size: 28.sp,
            color: isSelected ? Colors.white : const Color(0xFFFFFFFF),
          ),
        );
      }

      if (!imagePath.startsWith('assets/')) {
        if (!imagePath.endsWith('.png') && !imagePath.endsWith('.jpg') && !imagePath.endsWith('.jpeg')) {
          imagePath = 'assets/images/$imagePath.png';
        } else {
          imagePath = 'assets/images/$imagePath';
        }
      }

      return Image.asset(
        imagePath,
        width: 60.w,
        height: 30.h,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Icon(
            Icons.fastfood,
            size: 28.sp,
            color: isSelected ? Colors.white : const Color(0xFFFFFFFF),
          );
        },
      );
    }

    return Icon(
      Icons.fastfood,
      size: 28.sp,
      color: isSelected ? Colors.white : const Color(0xFFFFFFFF),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<CategoryController>(context);
    final restaurantProvider = Provider.of<RestaurantProvider>(context, listen: false);
    final categoryId = category['_id'] ?? category['id'] ?? '';
    final categoryTitle = category['title'] ?? category['name'] ?? 'Food';
    final isSelected = controller.categoryValue == categoryId;
    final iconData = category['icon'] ?? category['image'] ?? category['imageUrl'] ?? category['value'] ?? categoryTitle;

    return GestureDetector(
      onTap: () {
        if (isSelected) {
          controller.updateCategory = '';
          controller.updateTitle = '';
          restaurantProvider.setCategory('');
        } else {
          controller.updateCategory = categoryId;
          controller.updateTitle = categoryTitle;
          restaurantProvider.setCategory(categoryTitle.toString().toLowerCase());
        }
      },
      child: Container(
        margin: EdgeInsets.all(20.w),
        width: 100.w,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF8a2ae4) : const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 3.r,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildCategoryIcon(iconData, isSelected),
            SizedBox(height: 4.h),
            ReusableText(
              text: categoryTitle,
              style: appStyle(20.sp, isSelected ? Colors.white : Colors.black, FontWeight.w500),
            )
          ],
        ),
      ),
    );
  }
}
