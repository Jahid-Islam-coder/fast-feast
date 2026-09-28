import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../common/app_style.dart';
import '../../common/reusable_text.dart';
import '../../controllers/provider/auth_provider.dart';
import '../../controllers/provider/user_provider.dart';
import '../address/set_address_page.dart';
import '../auth/forgot_password_page.dart';

// landing / onboarding screen
class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  void _showAuthBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return const AuthBottomSheetContent();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 2),
            Center(
              child: Container(
                width: 430.w,
                height: 270.h,
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage('assets/images/chef.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const Spacer(),
            ReusableText(
              text: "Enjoy",
              style: TextStyle(
                fontSize: 34.sp,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            ReusableText(
              text: "Your Food",
              style: TextStyle(
                fontSize: 34.sp,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 50.w),
              child: SizedBox(
                width: double.infinity,
                height: 55.h,
                child: ElevatedButton(
                  onPressed: () => _showAuthBottomSheet(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8a2ae4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                  ),
                  child: Text(
                    "Get Started",
                    style: TextStyle(
                      fontSize: 36.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}

// modal bottom sheet for login & signup tabs
class AuthBottomSheetContent extends StatefulWidget {
  const AuthBottomSheetContent({super.key});

  @override
  State<AuthBottomSheetContent> createState() => _AuthBottomSheetContentState();
}

class _AuthBottomSheetContentState extends State<AuthBottomSheetContent> {
  final TextEditingController _loginEmailController = TextEditingController();
  final TextEditingController _loginPasswordController =
      TextEditingController();
  final TextEditingController _signupNameController = TextEditingController();
  final TextEditingController _signupEmailController = TextEditingController();
  final TextEditingController _signupPasswordController =
      TextEditingController();

  final _loginFormKey = GlobalKey<FormState>();
  final _signupFormKey = GlobalKey<FormState>();

  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);

    return Container(
      height: 0.65.sh,
      decoration: BoxDecoration(
        color: const Color(0xFFECE3F7),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(70.r),
          topRight: Radius.circular(70.r),
        ),
      ),
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            SizedBox(height: 10.h),
            Container(
              width: 50.w,
              height: 5.h,
              decoration: BoxDecoration(color: Colors.grey.shade300),
            ),
            SizedBox(height: 20.h),
            TabBar(
              labelColor: const Color(0xFF8a2ae4),
              unselectedLabelColor: Colors.grey,
              indicatorColor: const Color(0xFF8a2ae4),
              tabs: const [
                Tab(text: "Login"),
                Tab(text: "Sign Up"),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // Login Tab
                  SingleChildScrollView(
                    padding: EdgeInsets.only(
                      left: 25.w,
                      right: 25.w,
                      top: 25.w,
                      bottom: MediaQuery.of(context).viewInsets.bottom + 25.w,
                    ),
                    child: Form(
                      key: _loginFormKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _loginEmailController,
                            decoration: InputDecoration(
                              hintText: "Email",
                              prefixIcon: const Icon(Icons.email_outlined),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                            ),
                            validator: (val) =>
                                val!.isEmpty ? "Enter email" : null,
                          ),
                          SizedBox(height: 20.h),
                          TextFormField(
                            controller: _loginPasswordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: "Password",
                              prefixIcon: const Icon(Icons.lock_outline),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                            ),
                            validator: (val) =>
                                val!.length < 6 ? "Password too short" : null,
                          ),

                          SizedBox(height: 15.h),
                          SizedBox(
                            width: double.infinity,
                            height: 50.h,
                            child: ElevatedButton(
                              onPressed: authProvider.isLoading
                                  ? null
                                  : () async {
                                      if (_loginFormKey.currentState!
                                          .validate()) {
                                        try {
                                          await authProvider.login(
                                            _loginEmailController.text.trim(),
                                            _loginPasswordController.text
                                                .trim(),
                                          );
                                          if (mounted) Navigator.pop(context);
                                        } catch (e) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                                SnackBar(
                                                  content: Text(e.toString()),
                                                ),
                                              );
                                        }
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF8a2ae4),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                              ),
                              child: authProvider.isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : Text(
                                      "Login",
                                      style: appStyle(
                                        36.sp,
                                        Colors.white,
                                        FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                          SizedBox(height: 20.h),
                          OutlinedButton.icon(
                            onPressed: () async {
                              try {
                                await authProvider.googleSignIn();
                                if (mounted) Navigator.pop(context);
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(e.toString())),
                                );
                              }
                            },
                            icon: const Icon(
                              Icons.g_mobiledata,
                              size: 30,
                              color: Colors.red,
                            ),
                            label: Text(
                              "Continue with Google",
                              style: appStyle(
                                36.sp,
                                Colors.black,
                                FontWeight.w600,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              backgroundColor: const Color(0xFFECE3F7),
                              minimumSize: Size(double.infinity, 50.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                            ),
                          ),
                          SizedBox(height: 10.h),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ForgotPasswordPage(),
                                ),
                              );
                            },
                            child: Text(
                              "Forgot Password?",
                              style: appStyle(
                                26.sp,
                                const Color(0xFF8a2ae4),
                                FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Signup Tab
                  SingleChildScrollView(
                    padding: EdgeInsets.only(
                      left: 25.w,
                      right: 25.w,
                      top: 25.w,
                      bottom: MediaQuery.of(context).viewInsets.bottom + 25.w,
                    ),
                    child: Form(
                      key: _signupFormKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _signupNameController,
                            decoration: InputDecoration(
                              hintText: "Full Name",
                              prefixIcon: const Icon(Icons.person_outline),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                            ),
                            validator: (val) =>
                                val!.isEmpty ? "Enter name" : null,
                          ),
                          SizedBox(height: 15.h),
                          TextFormField(
                            controller: _signupEmailController,
                            decoration: InputDecoration(
                              hintText: "Email",
                              prefixIcon: const Icon(Icons.email_outlined),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                            ),
                            validator: (val) =>
                                val!.isEmpty ? "Enter email" : null,
                          ),
                          SizedBox(height: 15.h),
                          TextFormField(
                            controller: _signupPasswordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: "Password",
                              prefixIcon: const Icon(Icons.lock_outline),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                            ),
                            validator: (val) => val!.length < 6
                                ? "Password must be 6+ chars"
                                : null,
                          ),
                          SizedBox(height: 30.h),
                          SizedBox(
                            width: double.infinity,
                            height: 50.h,
                            child: ElevatedButton(
                              onPressed:
                                  authProvider.isLoading ||
                                      userProvider.isLoading
                                  ? null
                                  : () async {
                                      if (_signupFormKey.currentState!
                                          .validate()) {
                                        try {
                                          await authProvider.signUp(
                                            _signupEmailController.text.trim(),
                                            _signupPasswordController.text
                                                .trim(),
                                            _signupNameController.text.trim(),
                                          );

                                          final user = authProvider.user;
                                          if (user != null) {
                                            await userProvider.addUserData(
                                              currentUser: user,
                                              userName: _signupNameController
                                                  .text
                                                  .trim(),
                                              userEmail: _signupEmailController
                                                  .text
                                                  .trim(),
                                            );
                                          }
                                          if (mounted) Navigator.pop(context);
                                        } catch (e) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                                SnackBar(
                                                  content: Text(e.toString()),
                                                ),
                                              );
                                        }
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF8a2ae4),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                              ),
                              child:
                                  (authProvider.isLoading ||
                                      userProvider.isLoading)
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : Text(
                                      "Create Account",
                                      style: appStyle(
                                        36.sp,
                                        Colors.white,
                                        FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                          SizedBox(height: 20.h),
                          OutlinedButton.icon(
                            onPressed: () async {
                              try {
                                await authProvider.googleSignIn();
                                if (mounted) Navigator.pop(context);
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(e.toString())),
                                );
                              }
                            },
                            icon: const Icon(
                              Icons.g_mobiledata,
                              size: 30,
                              color: Colors.red,
                            ),
                            label: Text(
                              "Continue with Google",
                              style: appStyle(
                                36.sp,
                                Colors.black,
                                FontWeight.w600,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              backgroundColor: const Color(0xFFECE3F7),
                              minimumSize: Size(double.infinity, 50.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
