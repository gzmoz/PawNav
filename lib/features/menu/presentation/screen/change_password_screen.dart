import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pawnav/app/theme/colors.dart';
import 'package:pawnav/core/utils/custom_snack.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final supabase = Supabase.instance.client;

  final TextEditingController currentPasswordController =
  TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();

  bool obscureCurrent = true;
  bool obscureNew = true;
  bool obscureConfirm = true;

  Future<void> _changePassword() async {
    final current = currentPasswordController.text.trim();
    final newPass = newPasswordController.text.trim();
    final confirm = confirmController.text.trim();

    if (current.isEmpty || newPass.isEmpty || confirm.isEmpty) {
      AppSnackbar.error(context, "Please fill all fields.");
      return;
    }

    if (newPass.length < 6) {
      AppSnackbar.error(context, "Password must be at least 6 characters.");
      return;
    }

    if (newPass != confirm) {
      AppSnackbar.error(context, "Passwords do not match.");
      return;
    }

    try {

      final user = supabase.auth.currentUser;
      if (user == null || user.email == null) {
        AppSnackbar.error(context, "Session expired. Please log in again.");
        return;
      }

      await supabase.auth.signInWithPassword(
        email: user.email!,
        password: current,
      );


      await supabase.auth.updateUser(
        UserAttributes(password: newPass),
      );

      AppSnackbar.success(context, "Password updated successfully!");

      if (!mounted) return;
      context.pop(); // login-security ekranına geri dön

    } catch (e) {
      AppSnackbar.error(
        context,
        "Current password is incorrect.",
      );
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
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: width * 0.07),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back
                    Padding(
                      padding: EdgeInsets.only(top: height * 0.015),
                      child: GestureDetector(
                        onTap: () => context.pop(),
                        child: const Icon(Icons.arrow_back, size: 28),
                      ),
                    ),

                    SizedBox(height: height * 0.04),

                    // Icon
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

                    Center(
                      child: Text(
                        "Change Password",
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
                        "Enter your current password and choose a new one.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: width * 0.038,
                          color: Colors.grey,
                        ),
                      ),
                    ),

                    SizedBox(height: height * 0.05),

                    /// CURRENT PASSWORD
                    _passwordLabel("Current Password", width),
                    _passwordField(
                      controller: currentPasswordController,
                      obscure: obscureCurrent,
                      hint: "Enter current password",
                      toggle: () =>
                          setState(() => obscureCurrent = !obscureCurrent),
                    ),

                    SizedBox(height: height * 0.03),

                    /// NEW PASSWORD
                    _passwordLabel("New Password", width),
                    _passwordField(
                      controller: newPasswordController,
                      obscure: obscureNew,
                      hint: "Enter new password",
                      toggle: () =>
                          setState(() => obscureNew = !obscureNew),
                    ),

                    SizedBox(height: height * 0.03),

                    /// CONFIRM
                    _passwordLabel("Confirm Password", width),
                    _passwordField(
                      controller: confirmController,
                      obscure: obscureConfirm,
                      hint: "Re-enter new password",
                      toggle: () =>
                          setState(() => obscureConfirm = !obscureConfirm),
                    ),

                    SizedBox(height: height * 0.04),

                    GestureDetector(
                      onTap: _changePassword,
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

                    SizedBox(height: height * 0.03),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _passwordLabel(String text, double width) {
    return Text(
      text,
      style: TextStyle(
        fontSize: width * 0.04,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  Widget _passwordField({
    required TextEditingController controller,
    required bool obscure,
    required String hint,
    required VoidCallback toggle,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Colors.white,
          suffixIcon: IconButton(
            icon:
            Icon(obscure ? Icons.visibility_off : Icons.visibility),
            onPressed: toggle,
          ),
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
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
    );
  }
}
