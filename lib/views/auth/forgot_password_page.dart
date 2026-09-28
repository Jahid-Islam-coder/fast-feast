import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../common/app_style.dart';
import '../../common/custom_snackbar.dart';
import '../../common/reusable_appbar.dart';
import '../../common/reusable_text.dart';
import '../../controllers/provider/auth_provider.dart';

// screen to request password reset link
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFECE3F7),
      appBar: CustomReusableAppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 20.h),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),
                ReusableText(
                  text: "Reset your password",
                  style: appStyle(34.sp, Colors.black, FontWeight.bold),
                ),
                SizedBox(height: 10.h),
                ReusableText(
                  text: "Enter the email address associated with your account, and we'll send you a link to reset your password.",
                  style: appStyle(26.sp, Colors.grey.shade600, FontWeight.normal),
                ),
                SizedBox(height: 30.h),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: "Enter your email",
                    prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF8a2ae4)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: const BorderSide(color: Color(0xFF8a2ae4), width: 2),
                    ),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return "Please enter your email";
                    }
                    if (!val.contains('@') || !val.contains('.')) {
                      return "Please enter a valid email";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 40.h),
                SizedBox(
                  width: double.infinity,
                  height: 50.h,
                  child: ElevatedButton(
                    onPressed: authProvider.isLoading
                        ? null
                        : () async {
                            if (_formKey.currentState!.validate()) {
                              final email = _emailController.text.trim();
                              try {
                                await authProvider.resetPassword(email);
                                if (!mounted) return;
                                showCustomSnackBar(
                                  context,
                                  "Password reset email sent! Check your inbox.",
                                );
                                if (!mounted) return;
                                Navigator.pop(context);
                              } catch (e) {
                                if (!mounted) return;
                                showCustomSnackBar(
                                  context,
                                  e.toString().replaceAll("Exception: ", ""),
                                  isError: true,
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
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : ReusableText(
                            text: "Send Reset Link",
                            style: appStyle(34.sp, Colors.white, FontWeight.bold),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
