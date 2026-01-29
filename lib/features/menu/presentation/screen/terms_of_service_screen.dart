import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pawnav/app/theme/colors.dart';

class TermsOfServicePage extends StatelessWidget {
  const TermsOfServicePage({super.key});

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
          "Terms of Service",
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
                _Section(
                  title: "OVERVIEW",
                  width: width,
                  child: _TextBlock(
                    width: width,
                    text:
                    "By using PawNav, you agree to these Terms of Service.\n\n"
                        "PawNav is a community based platform designed to help users share information "
                        "about lost and found pets. PawNav does not guarantee outcomes or results.",
                  ),
                ),

                SizedBox(height: height * 0.02),

                _Section(
                  title: "USER RESPONSIBILITIES",
                  width: width,
                  child: _TextBlock(
                    width: width,
                    text:
                    "You are responsible for the accuracy of the information you share on PawNav.\n\n"
                        "You agree not to post misleading, harmful, illegal, or inappropriate content. "
                        "You also agree not to misuse the platform in a way that could harm others.",
                  ),
                ),

                SizedBox(height: height * 0.02),

                _Section(
                  title: "CONTENT & COMMUNICATION",
                  width: width,
                  child: _TextBlock(
                    width: width,
                    text:
                    "PawNav allows users to communicate directly with each other.\n\n"
                        "PawNav is not responsible for interactions, agreements, or disputes between users. "
                        "All communication and decisions are made at your own discretion.",
                  ),
                ),

                SizedBox(height: height * 0.02),

                _Section(
                  title: "LIMITATION OF LIABILITY",
                  width: width,
                  child: _TextBlock(
                    width: width,
                    text:
                    "PawNav is provided on an \"as is\" and \"as available\" basis.\n\n"
                        "We do not guarantee uninterrupted access or error-free operation. "
                        "To the fullest extent permitted by law, PawNav is not liable for any damages "
                        "arising from the use of the app.",
                  ),
                ),

                SizedBox(height: height * 0.02),

                _Section(
                  title: "ACCOUNT TERMINATION",
                  width: width,
                  child: _TextBlock(
                    width: width,
                    text:
                    "You may delete your account at any time through the app.\n\n"
                        "PawNav reserves the right to suspend or terminate accounts that violate these terms "
                        "or misuse the platform.",
                  ),
                ),

                SizedBox(height: height * 0.02),

                _Section(
                  title: "CHANGES TO THESE TERMS",
                  width: width,
                  child: _TextBlock(
                    width: width,
                    text:
                    "These Terms of Service may be updated from time to time.\n\n"
                        "Continued use of PawNav after changes are made indicates acceptance of the updated terms.",
                  ),
                ),

                SizedBox(height: height * 0.02),

             /*   _Section(
                  title: "CONTACT",
                  width: width,
                  child: _TextBlock(
                    width: width,
                    text:
                    "If you have questions about these Terms of Service, you can contact us at:\n\n"
                        "pawnav.support@gmail.com",
                  ),
                ),*/

                SizedBox(height: height * 0.04),

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

  static String _formattedDate() {
    final now = DateTime.now();
    return "${now.day}.${now.month}.${now.year}";
  }
}

class _Section extends StatelessWidget {
  final String title;
  final Widget child;
  final double width;

  const _Section({
    required this.title,
    required this.child,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
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
          margin: const EdgeInsets.only(top: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: child,
        ),
      ],
    );
  }
}

class _TextBlock extends StatelessWidget {
  final String text;
  final double width;

  const _TextBlock({
    required this.text,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(width * 0.04),
      child: Text(
        text,
        style: TextStyle(
          fontSize: width * 0.035,
          color: Colors.black87,
          height: 1.35,
        ),
      ),
    );
  }
}
