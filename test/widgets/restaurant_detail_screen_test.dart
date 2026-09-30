import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:fastfeast/controllers/provider/restaurant_menu_provider.dart';
import 'package:fastfeast/controllers/provider/review_cart_provider.dart';
import 'package:fastfeast/models/foods_model.dart';
import 'package:fastfeast/models/restaurants_model.dart';
import 'package:fastfeast/views/home/widgets/restaurants_page.dart';

void main() {
  final testRestaurant = RestaurantDetailModel(
    id: 'res1',
    name: 'Test Fast Food',
    image: 'http://example.com/image.png',
    address: '123 Main St',
    rating: 4.5,
    cuisineType: 'Fast Food',
    isAvailable: true,
  );

  final testFoods = [
    FoodModel(
      id: 'f1',
      name: 'Beef Burger',
      image: 'http://example.com/burger.png',
      price: 8.99,
      description: 'Juicy beef burger',
      category: 'Burger',
      restaurantId: 'res1',
    ),
    FoodModel(
      id: 'f2',
      name: 'Cheese Pizza',
      image: 'http://example.com/pizza.png',
      price: 12.99,
      description: 'Delicious cheese pizza',
      category: 'Pizza',
      restaurantId: 'res1',
    ),
    FoodModel(
      id: 'f3',
      name: 'Chicken Burger',
      image: 'http://example.com/chicken_burger.png',
      price: 7.99,
      description: 'Crispy chicken burger',
      category: 'Burger',
      restaurantId: 'res1',
    ),
  ];

  Widget createWidgetToTest({required RestaurantMenuProvider menuProvider, CartProvider? cartProvider}) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<RestaurantMenuProvider>.value(value: menuProvider),
        ChangeNotifierProvider<CartProvider>(create: (_) => cartProvider ?? CartProvider()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) => MaterialApp(
          home: RestaurantDetailScreen(
            restaurant: testRestaurant,
            restaurantId: 'res1',
          ),
        ),
      ),
    );
  }

  group('RestaurantDetailScreen Category Tests', () {
    testWidgets('renders restaurant info, category options, and full menu by default', (WidgetTester tester) async {
      final menuProvider = RestaurantMenuProvider();
      menuProvider.setRestaurantMenu('res1', testFoods);

      await tester.pumpWidget(createWidgetToTest(menuProvider: menuProvider));
      await tester.pump(const Duration(milliseconds: 300));

      // Restaurant information checks
      expect(find.text('Test Fast Food'), findsOneWidget);
      expect(find.text('123 Main St'), findsOneWidget);

      // Category chips check
      expect(find.text('Categories'), findsOneWidget);
      expect(find.text('All'), findsOneWidget);
      expect(find.text('Burger'), findsOneWidget);
      expect(find.text('Pizza'), findsOneWidget);
      expect(find.text('Pasta', skipOffstage: false), findsOneWidget);
      expect(find.text('Cake', skipOffstage: false), findsOneWidget);

      // Default heading should be "Full Menus"
      expect(find.text('Full Menus'), findsOneWidget);

      // Verify items are displayed initially in menu grid
      expect(find.text('Beef Burger'), findsOneWidget);
      expect(find.text('Cheese Pizza'), findsOneWidget);
    });

    testWidgets('filters items when a category is selected and toggles back to full menu', (WidgetTester tester) async {
      final menuProvider = RestaurantMenuProvider();
      menuProvider.setRestaurantMenu('res1', testFoods);

      await tester.pumpWidget(createWidgetToTest(menuProvider: menuProvider));
      await tester.pump(const Duration(milliseconds: 300));

      // Tap on "Burger" category chip
      await tester.tap(find.text('Burger'));
      await tester.pump(const Duration(milliseconds: 300));

      // Heading should now update to "Burger Menu"
      expect(find.text('Burger Menu'), findsOneWidget);

      // Only burgers should be visible
      expect(find.text('Beef Burger'), findsOneWidget);
      expect(find.text('Chicken Burger'), findsOneWidget);
      expect(find.text('Cheese Pizza'), findsNothing);

      // Tap on "All" to return to full menu
      await tester.tap(find.text('All'));
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Full Menus'), findsOneWidget);
      expect(find.text('Cheese Pizza'), findsOneWidget);
    });
  });
}
