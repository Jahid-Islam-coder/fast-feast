import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/provider/user_provider.dart';
import '../../controllers/provider/order_provider.dart';
import '../bottom_navigation_bar/bottom_navigation_bar.dart';
import 'set_address_page.dart';

enum AppStatus { loading, home, setAddress }

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  AppStatus _status = AppStatus.loading;

  @override
  void initState() {
    super.initState();
    _checkStatus();
  }

  Future<void> _checkStatus() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    
    // load profile & orders together
    await Future.wait([
      userProvider.getUserData(),
      orderProvider.getOrders(),
    ]);
    
    final userData = userProvider.currentUserData;

    if (mounted) {
      setState(() {
        if (userData != null && userData.latitude != null && userData.longitude != null) {
          _status = AppStatus.home;
        } else {
          _status = AppStatus.setAddress;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_status == AppStatus.loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else if (_status == AppStatus.home) {
      return const MainScreen();
    } else {
      return const SetAddressPage();
    }
  }
}
