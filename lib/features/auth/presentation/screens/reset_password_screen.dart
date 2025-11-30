import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pawnav/app/theme/colors.dart';
import 'package:pawnav/core/utils/custom_snack.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final supabase = Supabase.instance.client;

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();

  bool obscure1 = true;
  bool obscure2 = true;

  Future<void> _resetPassword() async {
    final pass = passwordController.text.trim();
    final confirm = confirmController.text.trim();

    if (pass.isEmpty || confirm.isEmpty) {
      AppSnackbar.error(context, "Please fill all fields.");
      return;
    }
    if (pass.length < 6) {
      AppSnackbar.error(context, "Password must be at least 6 characters.");
      return;
    }
    if (pass != confirm) {
      AppSnackbar.error(context, "Passwords do not match.");
      return;
    }

    try {
      await supabase.auth.updateUser(
        UserAttributes(password: pass),
      );

      AppSnackbar.success(context, "Password updated successfully!");

      if (!mounted) return;
      context.go('/login');

    } catch (e) {
      AppSnackbar.error(context, "Something went wrong. Try again.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.white2,
      resizeToAvoidBottomInset: true,

      body: SafeArea(
        child: Column(
          children: [

            /// 🟦 ÜST KISIM (scrollable)
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: width * 0.07),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // Back Arrow
                    Padding(
                      padding: EdgeInsets.only(top: height * 0.015),
                      child: GestureDetector(
                        onTap: (){
                          context.go('/login');
                        },
                        child: const Icon(Icons.arrow_back, size: 28),
                      ),
                    ),

                    SizedBox(height: height * 0.04),

                    // Paw icon
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            )
                          ],
                        ),
                        child: Image.asset(
                          'assets/app_icon/icon_transparent.png',
                          width: 40,
                          height: 40,
                        ),
                      ),
                    ),

                    SizedBox(height: height * 0.035),

                    // Title
                    Center(
                      child: Text(
                        "Reset Password",
                        style: TextStyle(
                          fontSize: width * 0.07,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),

                    SizedBox(height: height * 0.01),

                    Center(
                      child: Text(
                        "Enter your new password below.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: width * 0.038,
                          color: Colors.grey,
                        ),
                      ),
                    ),

                    SizedBox(height: height * 0.05),

                    Text(
                      "New Password",
                      style: TextStyle(
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Password input
                    TextField(
                      controller: passwordController,
                      obscureText: obscure1,
                      decoration: InputDecoration(
                        hintText: "Enter new password",
                        filled: true,
                        fillColor: Colors.white,
                        suffixIcon: IconButton(
                          icon: Icon(
                              obscure1 ? Icons.visibility_off : Icons.visibility
                          ),
                          onPressed: () {
                            setState(() => obscure1 = !obscure1);
                          },
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 15),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade200),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder( //kullanıcı yazmaya basladıgında
                          borderSide: BorderSide(color: Colors.grey.shade100),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    SizedBox(height: height * 0.03),

                    Text(
                      "Confirm Password",
                      style: TextStyle(
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 8),

                    TextField(
                      controller: confirmController,
                      obscureText: obscure2,
                      decoration: InputDecoration(
                        hintText: "Re-enter your new password",
                        filled: true,
                        fillColor: Colors.white,
                        suffixIcon: IconButton(
                          icon: Icon(
                              obscure2 ? Icons.visibility_off : Icons.visibility
                          ),
                          onPressed: () {
                            setState(() => obscure2 = !obscure2);
                          },
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 15),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade200),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade100),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    SizedBox(height: height * 0.03),

                    Padding(
                      padding: EdgeInsets.only(bottom: height * 0.03),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: _resetPassword,
                            child: Container(
                              width: width * 0.88,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF233E96), Color(0xFF3C59C7)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                "Update Password",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: width * 0.035,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // SizedBox(height: height * 0.28),


          ],
        ),
      ),
    );
  }
}
