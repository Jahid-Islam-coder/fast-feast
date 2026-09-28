import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/provider/auth_provider.dart';
import '../address/splash_screen.dart';
import '../onboarding/onboarding_page.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    if (authProvider.user == null) {
      return const OnboardingPage();
    } else {
      return const SplashScreen(); // splash screen routes to home or set address
    }
  }
}
