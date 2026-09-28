import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:fastfeast/controllers/provider/user_provider.dart';
import 'package:fastfeast/views/cart/cart_page.dart';
import 'package:fastfeast/views/home/home_page.dart';
import 'package:fastfeast/views/profile/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/provider/bottom_navigation_bar_provider.dart';
import '../../controllers/provider/restaurant_provider.dart';
import '../../controllers/provider/review_cart_provider.dart';
import '../search/search_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  late List<Widget> screens;
  late HomePage homePage;
  late SearchPage searchPage;
  late CartPage cartPage;
  late ProfilePage profilePage;



  @override
  void initState(){
    super.initState();
    homePage = const HomePage();
    searchPage = SearchPage();
    cartPage = const CartPage();
    profilePage = const ProfilePage();
    
    screens = [
      homePage,
      searchPage,
      cartPage,
      profilePage,
    ];
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final restaurantProvider = Provider.of<RestaurantProvider>(context, listen: false);
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      final userData = userProvider.currentUserData;
      
      // fetch cart on startup
      cartProvider.getCartData();
      
      if (userData != null && userData.latitude != null && userData.longitude != null) {
        restaurantProvider.fetchNearbyRestaurants(context, userData.latitude!, userData.longitude!);
      } else {
        // retry fetch if user data was null
        await userProvider.getUserData();
        final updatedData = userProvider.currentUserData;
        if (updatedData != null && updatedData.latitude != null && updatedData.longitude != null) {
          restaurantProvider.fetchNearbyRestaurants(context, updatedData.latitude!, updatedData.longitude!);
        }
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Consumer2<TabIndexController, CartProvider>(
        builder: (context, provider, cartProvider, child){
          int totalCartCount = cartProvider.cartList.fold(0, (sum, item) => sum + item.cartQuantity);

          return CurvedNavigationBar(
            height: 70,
            backgroundColor: const Color(0xFF8a2ae4),
            color: const Color(0xFFFFFFFF),
            animationDuration: const Duration(milliseconds: 500),
            index: provider.tabIndex,
            onTap: (int index){
              provider.tabIndex = index;
            },
            items: [
              Icon(Icons.home, color: Colors.grey[600], size: 30.0,),
              Icon(Icons.search, color: Colors.grey[600], size: 30.0,),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(Icons.shopping_cart, color: Colors.grey[600], size: 30.0,),
                  if (totalCartCount > 0)
                    Positioned(
                      right: -6,
                      top: -6,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        child: Text(
                          '$totalCartCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              Icon(Icons.person, color: Colors.grey[600], size: 30.0,),
            ],
          );
        },
      ),
      body: screens[Provider.of<TabIndexController>(context).tabIndex],
    );
  }

}







