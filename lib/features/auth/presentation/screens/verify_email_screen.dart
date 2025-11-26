import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pawnav/app/theme/colors.dart';
import 'package:go_router/go_router.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenInfo = MediaQuery.of(context);
    final double height = screenInfo.size.height;
    final double width = screenInfo.size.width;
    return Scaffold(
      backgroundColor: AppColors.background2,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 15, right: 30, left: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LottieBuilder.asset("assets/lottie/verify_email.json",
                width: width * 0.75,
                // height: height * 0.4,
                fit: BoxFit.contain,),
              /*const Icon(Icons.email_outlined, size: 100, color: AppColors.primary),*/
              const SizedBox(height: 5),
              Text(
                "Check your email",
                style: TextStyle(
                  fontSize: width * 0.065,
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "We sent a confirmation link to your email address. "
                    "Please verify your account to continue before you sign in.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 40),

              GestureDetector(
                /*Form içindeki tüm validator’ları çalıştırır
                      Eğer hiç hata yoksa true, hata varsa false döner*/
                onTap: () {
                  context.go('/login');
                },
                child: Container(
                  width: width * 0.88,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      // colors: [Color(0xFF233E96), Color(0xFF3C59C7)],
                      colors: [Color(0xFF1F6DB2), Color(0xFF4C87BC)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "Go to Login",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: width * 0.035,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              /*ElevatedButton(
                onPressed: () {
                  context.go('/login');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: const Text(
                  "Go to Login",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),*/
            ],
          ),
        ),
      ),
    );
  }
}
