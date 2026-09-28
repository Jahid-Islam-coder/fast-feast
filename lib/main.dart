import 'package:fastfeast/views/auth/auth_wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'package:flutter_stripe/flutter_stripe.dart';
import 'controllers/provider/auth_provider.dart';
import 'controllers/provider/bottom_navigation_bar_provider.dart';
import 'controllers/provider/category_provider.dart';
import 'controllers/provider/restaurant_menu_provider.dart';
import 'controllers/provider/restaurant_provider.dart';
import 'controllers/provider/review_cart_provider.dart';
import 'controllers/provider/location_provider.dart';
import 'controllers/provider/order_provider.dart';
import 'controllers/provider/order_tracking_provider.dart';
import 'controllers/provider/search_provider.dart';
import 'controllers/provider/user_provider.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Stripe.publishableKey = StripeConstants.publishableKey;
  Stripe.merchantIdentifier = 'merchant.com.example.fastfeast';
  await Stripe.instance.applySettings();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(600, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
            ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider()),
            ChangeNotifierProvider<CartProvider>(create: (_) => CartProvider()),
            ChangeNotifierProvider<RestaurantProvider>(create: (_) => RestaurantProvider()),
            ChangeNotifierProxyProvider<RestaurantProvider, SearchProvider>(
                create: (_) => SearchProvider(),
                update: (context, restaurantProvider, searchProvider){
                  searchProvider!.updateData(restaurantProvider.restaurants);
                  return searchProvider;
                }),
            ChangeNotifierProvider<RestaurantMenuProvider>(create: (_) => RestaurantMenuProvider()),
            ChangeNotifierProvider<TabIndexController>(create: (_) => TabIndexController()),
            ChangeNotifierProvider<CategoryController>(create: (_) => CategoryController()),
            ChangeNotifierProvider<OrderTrackingProvider>(create: (_) => OrderTrackingProvider()),
            ChangeNotifierProvider<OrderProvider>(create: (_) => OrderProvider()),
            ChangeNotifierProvider<LocationProvider>(create: (_) => LocationProvider()),
            // ChangeNotifierProvider<PaymentProvider>(create: (_) => PaymentProvider()),
          ],
          child: MaterialApp(
              theme: ThemeData(
                primaryColor: Colors.redAccent,),
              debugShowCheckedModeBanner: false,
              home: const AuthWrapper(),
          ),
        );
      },

    );
  }
}
