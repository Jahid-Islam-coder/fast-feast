import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../common/app_style.dart';
import '../../common/responsive_avatar.dart';
import '../../common/reusable_text.dart';
import '../../controllers/provider/user_provider.dart';
import '../../controllers/provider/auth_provider.dart';
import '../../controllers/provider/order_provider.dart';
import '../auth/auth_wrapper.dart';

// user profile page
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _DailyMembersProfileState();
}

class _DailyMembersProfileState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProvider>().getUserData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final user = authProvider.user;

    Widget listTile({required IconData icon, required String title}) {
      return Column(
        children: [
          const Divider(height: 3),
          ListTile(
            leading: Icon(icon),
            title: Text(title, style: const TextStyle(color: Colors.white)),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white54,
            ),
          ),
        ],
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF8a2ae4),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              Column(
                children: [
                  Container(height: MediaQuery.of(context).size.height * 0.2),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      decoration: const BoxDecoration(
                        color: Color(0xFFECE3F7),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50),
                        ),
                      ),
                      child: ListView(
                        children: [
                          Center(
                            child: Column(
                              children: [
                                Text(
                                  userProvider.currentUserData?.userName ??
                                      "Loading...",
                                  style: appStyle(
                                    34.sp,
                                    Colors.black,
                                    FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),
                          ReusableText(
                            text: "Email Address",
                            style: appStyle(
                              20.sp,
                              Colors.grey,
                              FontWeight.w600,
                            ),
                          ),

                          Text(
                            userProvider.currentUserData?.userEmail ??
                                user?.email ??
                                "Not signed in",
                            style: appStyle(
                              28.sp,
                              Colors.black,
                              FontWeight.w600,
                            ),
                          ),

                          const SizedBox(height: 30),

                          // delivery address
                          ReusableText(
                            text: "Delivery Address",
                            style: appStyle(
                              20.sp,
                              Colors.grey,
                              FontWeight.w600,
                            ),
                          ),

                          FutureBuilder(
                            future: FirebaseDatabase.instance
                                .ref()
                                .child("users/${user?.uid}/address/address")
                                .get(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Text("Loading address...");
                              }
                              return Text(
                                snapshot.data?.value?.toString() ??
                                    "No address set",
                                style: appStyle(
                                  28.sp,
                                  Colors.black,
                                  FontWeight.w600,
                                ),
                              );
                            },
                          ),

                          const SizedBox(height: 30),

                          InkWell(
                            onTap: () {},
                            child: Text(
                              "View Orders",
                              style: appStyle(
                                28.sp,
                                Colors.black,
                                FontWeight.w600,
                              ),
                            ),
                          ),

                          SizedBox(height: 210.h),

                          // logout button
                          SizedBox(
                            height: 50.h,
                            child: ElevatedButton(
                              onPressed: () async {
                                await authProvider.logout();
                                userProvider.clearUserData();
                                orderProvider.clearOrders();
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const AuthWrapper(),
                                  ),
                                  (route) => false,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF8a2ae4),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.r),
                                ),
                              ),
                              child: Text(
                                "Log out",
                                style: appStyle(
                                  34.sp,
                                  Colors.white,
                                  FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const ResponsiveAvatar(isProfilePage: true),
            ],
          );
        },
      ),
    );
  }
}
