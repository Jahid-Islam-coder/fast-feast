import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:fastfeast/controllers/provider/category_provider.dart';
import 'package:fastfeast/controllers/provider/restaurant_provider.dart';
import 'package:fastfeast/views/home/widgets/category_widget.dart';

void main() {
  Widget createWidgetToTest({required Map<String, dynamic> category, CategoryController? categoryController, RestaurantProvider? restaurantProvider}) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CategoryController>(create: (_) => categoryController ?? CategoryController()),
        ChangeNotifierProvider<RestaurantProvider>(create: (_) => restaurantProvider ?? RestaurantProvider()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) => MaterialApp(
          home: Scaffold(
            body: CategoryWidget(category: category),
          ),
        ),
      ),
    );
  }

  group('CategoryWidget Tests', () {
    testWidgets('renders category with String asset image path correctly', (WidgetTester tester) async {
      final category = {
        '_id': '1',
        'title': 'Burger',
        'icon': 'assets/images/burger.png',
      };

      await tester.pumpWidget(createWidgetToTest(category: category));
      await tester.pumpAndSettle();

      expect(find.text('Burger'), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('renders category with IconData correctly', (WidgetTester tester) async {
      final category = {
        '_id': '5',
        'title': 'More',
        'icon': Icons.more_horiz,
      };

      await tester.pumpWidget(createWidgetToTest(category: category));
      await tester.pumpAndSettle();

      expect(find.text('More'), findsOneWidget);
      expect(find.byIcon(Icons.more_horiz), findsOneWidget);
    });

    testWidgets('toggles category selection on tap', (WidgetTester tester) async {
      final categoryController = CategoryController();
      final restaurantProvider = RestaurantProvider();
      final category = {
        '_id': '1',
        'title': 'Burger',
        'icon': 'assets/images/burger.png',
      };

      await tester.pumpWidget(createWidgetToTest(
        category: category,
        categoryController: categoryController,
        restaurantProvider: restaurantProvider,
      ));
      await tester.pumpAndSettle();

      expect(categoryController.categoryValue, isEmpty);

      // Tap to select
      await tester.tap(find.byType(CategoryWidget));
      await tester.pumpAndSettle();

      expect(categoryController.categoryValue, equals('1'));
      expect(categoryController.titleValue, equals('Burger'));
      expect(restaurantProvider.selectedCategory, equals('burger'));

      // Tap again to unselect
      await tester.tap(find.byType(CategoryWidget));
      await tester.pumpAndSettle();

      expect(categoryController.categoryValue, isEmpty);
      expect(categoryController.titleValue, isEmpty);
      expect(restaurantProvider.selectedCategory, isEmpty);
    });
  });
}
