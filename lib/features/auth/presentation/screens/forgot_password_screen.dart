import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:pawnav/app/theme/colors.dart';
import 'package:pawnav/core/utils/custom_snack.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final supabase = Supabase.instance.client;
  final TextEditingController emailController = TextEditingController();
  bool resetSent = false;
  bool _isSending = false;


  Future<void> _playFeedback() async {
    HapticFeedback.lightImpact();
  }


  Future<void> _sendResetLink() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      AppSnackbar.error(context, "Please enter an email.");
      return;
    }

    // 1) Database'de kullanıcı var mı kontrol et
    final exist = await supabase
        .from('profiles')
        .select('id')
        .eq('email', email)
        .maybeSingle();

    if (exist == null) {
      AppSnackbar.error(context, "This email is not registered.");
      return;
    }

    try {
      // 2) Reset mail gönder
      await supabase.auth.resetPasswordForEmail(
        email,
        redirectTo: 'io.supabase.flutter://reset-callback',
      );

      setState(() {
        resetSent = true;   // input yerine mesaj gösterilecek
      });

      AppSnackbar.info(
        context,
        "A reset link has been sent to your email.",
      );

    } catch (e) {
      AppSnackbar.error(
        context,
        "Something went wrong. Please try again.",
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
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.07),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Back Arrow
                Padding(
                  padding: EdgeInsets.only(top: height * 0.015),
                  child: GestureDetector(
                    onTap: () => context.pop(),
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
                    "Forgot Password",
                    style: TextStyle(
                      fontSize: width * 0.07,
                      fontWeight: FontWeight.bold,
                      // color: Colors.black87,
                      color: AppColors.primary,
                    ),
                  ),
                ),

                SizedBox(height: height * 0.01),

                // Subtitle
                Center(
                  child: Text(
                    "We'll send you a link to reset your password.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: width * 0.038,
                      color: Colors.grey,
                    ),
                  ),
                ),

                SizedBox(height: height * 0.05),

                // Email label
                Text(
                  "Email Address",
                  style: TextStyle(
                    fontSize: width * 0.04,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 8),
                resetSent
                    ? Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green.shade200),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "A reset link has been sent. Please check your email.",
                          style: TextStyle(
                            fontSize: width * 0.038,
                            color: Colors.green.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                    : TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: "Enter your email",
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 15),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade200),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      // borderSide: BorderSide(color: AppColors.primary),
                      borderSide: BorderSide(color: Colors.grey.shade100),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),


                SizedBox(height: height * 0.05),

                if (!resetSent)
                  Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: _isSending
                          ? null
                          : () async {
                        setState(() => _isSending = true);

                        HapticFeedback.lightImpact();

                        await _sendResetLink();

                        if (mounted) {
                          setState(() => _isSending = false);
                        }
                      },
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
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // NORMAL TEXT
                            AnimatedOpacity(
                              duration: const Duration(milliseconds: 200),
                              opacity: _isSending ? 0.0 : 1.0,
                              child: Text(
                                "Send Reset Link",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: width * 0.035,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            // LOADING + TEXT
                            if (_isSending)
                              const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    "Reset link is being sent...",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),

                      ),
                    ),
                  ),



                /*if (!resetSent)
                  GestureDetector(
                    onTap: () async {
                      await _sendResetLink();
                    },
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
                        "Send Reset Link",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: width * 0.035,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),*/

                const SizedBox(height: 15),

                if (!resetSent)
                // Back to login
                  Center(
                    child: GestureDetector(
                      onTap: () => context.pop(),
                      child: Text(
                        "Back to Login",
                        style: TextStyle(
                          fontSize: width * 0.04,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),

                SizedBox(height: height * 0.09),
              ],
            ),
          ),
        ),
      ),
    );
  }
}