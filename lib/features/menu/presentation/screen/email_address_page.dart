import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pawnav/app/theme/colors.dart';
import 'package:pawnav/features/account/presentations/widgets/AccountMenuComponent.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EmailAddressPage extends StatelessWidget {
  const EmailAddressPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenInfo = MediaQuery.of(context);
    final double height = screenInfo.size.height;
    final double width = screenInfo.size.width;

    final userEmail = Supabase.instance.client.auth.currentUser?.email ?? '';

    return Scaffold(
      backgroundColor: AppColors.white4,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Email Address",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: width * 0.05,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
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
                /// EMAIL INFO
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "EMAIL INFORMATION",
                      style: TextStyle(
                        fontSize: width * 0.035,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    Container(
                      padding: EdgeInsetsDirectional.symmetric(
                        horizontal: width * 0.02,
                        vertical: height * 0.02,
                      ),
                      margin: const EdgeInsets.only(top: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          AccountMenuComponent(
                            icon: Icons.email_outlined,
                            title: userEmail,
                            onTap: null, // read-only
                          ),
                          const AccountMenuComponent(
                            icon: Icons.verified_outlined,
                            title: 'Email verified',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                /// WHY READ ONLY
                Padding(
                  padding: EdgeInsets.only(top: height * 0.02),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "WHY CAN’T I CHANGE MY EMAIL?",
                        style: TextStyle(
                          fontSize: width * 0.035,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(width * 0.04),
                        margin: const EdgeInsets.only(top: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          "Your email address is a critical part of your account security. "
                              "Changing it can cause login issues, data loss, or unauthorized access.\n\n"
                              "To keep your account safe, email changes are currently not supported.",
                          style: TextStyle(
                            fontSize: width * 0.035,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                /// SUPPORT
                Padding(
                  padding: EdgeInsets.only(top: height * 0.02),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "NEED HELP?",
                        style: TextStyle(
                          fontSize: width * 0.035,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      Container(
                        padding: EdgeInsetsDirectional.symmetric(
                          horizontal: width * 0.02,
                          vertical: height * 0.02,
                        ),
                        margin: const EdgeInsets.only(top: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            AccountMenuComponent(
                              icon: Icons.help_outline,
                              title: 'Contact Support',
                              onTap: () {
                                // ileride support page
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: height * 0.04),

                /// TRUST COPY
                Text(
                  "Your email is securely stored and never shared with third parties.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: width * 0.032,
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
}
