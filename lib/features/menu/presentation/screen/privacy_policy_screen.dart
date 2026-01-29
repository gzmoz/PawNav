import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pawnav/app/theme/colors.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenInfo = MediaQuery.of(context);
    final double height = screenInfo.size.height;
    final double width = screenInfo.size.width;

    return Scaffold(
      backgroundColor: AppColors.white4,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Privacy Policy",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: width * 0.05,
          ),
        ),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
      ),
      body: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom + 50,
          ),
          child: Padding(
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: width * 0.05,
              vertical: height * 0.03,
            ),
            child: Column(
              children: [
                _section(
                  width,
                  "PRIVACY POLICY",
                  "PawNav values your privacy. This Privacy Policy explains how we collect, use, "
                      "and protect your information when you use the PawNav mobile application.",
                ),

                _section(
                  width,
                  "INFORMATION WE COLLECT",
                  "• Account information such as your email address\n"
                      "• User-generated content including posts and photos\n"
                      "• Location data for map-based features\n"
                      "• Device and notification data via Firebase Cloud Messaging (FCM)",
                ),

                _section(
                  width,
                  "HOW WE USE YOUR INFORMATION",
                  "We use your information to operate and maintain the app, display lost and found pet reports, "
                      "enable communication between users, send relevant notifications, and improve the app experience.",
                ),

                _section(
                  width,
                  "DATA STORAGE AND SECURITY",
                  "Your data is securely stored using trusted third-party services such as Supabase and Firebase. "
                      "We take reasonable measures to protect your information.",
                ),

                _section(
                  width,
                  "DATA SHARING",
                  "PawNav does not sell your personal data. Information is only shared when required to operate "
                      "the app or deliver notifications.",
                ),

                _section(
                  width,
                  "ACCOUNT DELETION",
                  "You may delete your account at any time through the app. "
                      "Once deleted, your data is permanently removed.",
                ),

                _section(
                  width,
                  "YOUR RIGHTS",
                  "You have the right to access or delete your data and to contact us with privacy-related questions.",
                ),

                _section(
                  width,
                  "CONTACT",
                  "For any questions about this Privacy Policy, contact us at:\n\n"
                      "pawnavoz@gmail.com",
                ),

                SizedBox(height: height * 0.03),

                Text(
                  "Last updated: ${_formattedDate()}",
                  style: TextStyle(
                    fontSize: width * 0.03,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget _section(double width, String title, String text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: width * 0.035,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 8, bottom: 16),
          padding: EdgeInsets.all(width * 0.04),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: width * 0.035,
              color: Colors.black87,
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }

  static String _formattedDate() {
    final now = DateTime.now();
    return "${now.day}.${now.month}.${now.year}";
  }
}
