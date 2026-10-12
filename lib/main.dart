import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'constants/stripe_constants.dart';
import 'firebase_options.dart';

// Auth Feature imports
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/usecases/login_use_case.dart';
import 'features/auth/domain/usecases/sign_up_use_case.dart';
import 'features/auth/domain/usecases/sign_out_use_case.dart';
import 'features/auth/domain/usecases/reset_password_use_case.dart';
import 'features/auth/domain/usecases/google_sign_in_use_case.dart';
import 'features/auth/presentation/providers/auth_provider.dart';

// Restaurant Feature imports
import 'features/restaurant/data/datasources/restaurant_remote_data_source.dart';
import 'features/restaurant/data/repositories/restaurant_repository_impl.dart';
import 'features/restaurant/domain/usecases/get_nearby_restaurants_use_case.dart';
import 'features/restaurant/domain/usecases/get_restaurant_details_use_case.dart';
import 'features/restaurant/domain/usecases/get_all_restaurants_use_case.dart';
import 'features/restaurant/domain/usecases/get_restaurant_menu_use_case.dart';
import 'features/restaurant/presentation/providers/restaurant_provider.dart';
import 'features/restaurant/presentation/providers/restaurant_menu_provider.dart';

// Other Providers & Views
import 'controllers/provider/bottom_navigation_bar_provider.dart';
import 'controllers/provider/category_provider.dart';
import 'controllers/provider/payment_provider.dart';
import 'controllers/provider/review_cart_provider.dart';
import 'controllers/provider/location_provider.dart';
import 'controllers/provider/order_provider.dart';
import 'controllers/provider/order_tracking_provider.dart';
import 'controllers/provider/search_provider.dart';
import 'controllers/provider/user_provider.dart';
import 'views/auth/auth_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  Stripe.publishableKey = StripeConstants.publishableKey;
  Stripe.merchantIdentifier = 'merchant.com.example.fastfeast';
  await Stripe.instance.applySettings();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Wiring up DataSources, Repositories, Use Cases, Providers
    final authRemoteDataSource = AuthRemoteDataSource();
    final authRepository = AuthRepositoryImpl(authRemoteDataSource);
    final loginUseCase = LoginUseCase(authRepository);
    final signUpUseCase = SignUpUseCase(authRepository);
    final signOutUseCase = SignOutUseCase(authRepository);
    final resetPasswordUseCase = ResetPasswordUseCase(authRepository);
    final googleSignInUseCase = GoogleSignInUseCase(authRepository);

    final restaurantRemoteDataSource = RestaurantRemoteDataSource();
    final restaurantRepository = RestaurantRepositoryImpl(restaurantRemoteDataSource);
    final getNearbyRestaurantsUseCase = GetNearbyRestaurantsUseCase(restaurantRepository);
    final getRestaurantDetailsUseCase = GetRestaurantDetailsUseCase(restaurantRepository);
    final getAllRestaurantsUseCase = GetAllRestaurantsUseCase(restaurantRepository);
    final getRestaurantMenuUseCase = GetRestaurantMenuUseCase(restaurantRepository);

    return ScreenUtilInit(
      designSize: const Size(600, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthProvider>(
              create: (_) => AuthProvider(
                loginUseCase: loginUseCase,
                signUpUseCase: signUpUseCase,
                signOutUseCase: signOutUseCase,
                resetPasswordUseCase: resetPasswordUseCase,
                googleSignInUseCase: googleSignInUseCase,
                authRepository: authRepository,
              ),
            ),
            ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider()),
            ChangeNotifierProvider<CartProvider>(create: (_) => CartProvider()),
            ChangeNotifierProvider<RestaurantProvider>(
              create: (_) => RestaurantProvider(
                getNearbyRestaurantsUseCase: getNearbyRestaurantsUseCase,
                getRestaurantDetailsUseCase: getRestaurantDetailsUseCase,
                getAllRestaurantsUseCase: getAllRestaurantsUseCase,
              ),
            ),
            ChangeNotifierProxyProvider<RestaurantProvider, SearchProvider>(
                create: (_) => SearchProvider(),
                update: (context, restaurantProvider, searchProvider){
                  searchProvider!.updateData(restaurantProvider.restaurants);
                  return searchProvider;
                }),
            ChangeNotifierProvider<RestaurantMenuProvider>(
              create: (_) => RestaurantMenuProvider(
                getRestaurantMenuUseCase: getRestaurantMenuUseCase,
              ),
            ),
            ChangeNotifierProvider<TabIndexController>(create: (_) => TabIndexController()),
            ChangeNotifierProvider<CategoryController>(create: (_) => CategoryController()),
            ChangeNotifierProvider<OrderTrackingProvider>(create: (_) => OrderTrackingProvider()),
            ChangeNotifierProvider<OrderProvider>(create: (_) => OrderProvider()),
            ChangeNotifierProvider<LocationProvider>(create: (_) => LocationProvider()),
            ChangeNotifierProvider<PaymentProvider>(create: (_) => PaymentProvider()),
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
