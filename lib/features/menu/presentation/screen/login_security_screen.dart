import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pawnav/app/theme/colors.dart';
import 'package:pawnav/features/account/presentations/widgets/AccountMenuComponent.dart';

class LoginSecurityPage extends StatelessWidget {
  const LoginSecurityPage({super.key});

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
          "Login & Security",
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
                /// ACCOUNT ACCESS
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "ACCOUNT ACCESS",
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
                            icon: Icons.lock_outline,
                            title: 'Change Password',
                            onTap: () {
                              // mevcut reset password ekranı
                              context.push('/reset_password');
                            },
                          ),
                          AccountMenuComponent(
                            icon: Icons.email_outlined,
                            title: 'Email Address',
                            onTap: () {
                              context.push('/email-address');
                            },
                          ),

                        ],
                      ),
                    ),
                  ],
                ),

                /// SESSIONS
                Padding(
                  padding: EdgeInsets.only(top: height * 0.02),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "SESSIONS",
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
                              icon: Icons.devices_outlined,
                              title: 'Active Sessions',
                              onTap: () {
                                // ileride eklenecek
                              },
                            ),
                            AccountMenuComponent(
                              icon: Icons.logout,
                              title: 'Log out from all devices',
                              onTap: () {
                                // supabase global sign out
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                /// RECOVERY
                Padding(
                  padding: EdgeInsets.only(top: height * 0.02),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "RECOVERY",
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
                              icon: Icons.refresh,
                              title: 'Reset Password',
                              onTap: () {
                                context.push('/reset_password');
                              },
                            ),
                            AccountMenuComponent(
                              icon: Icons.delete_outline,
                              title: 'Delete Account',
                              onTap: () {
                                // confirm dialog sonra
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: height * 0.04),

                /// TRUST COPY (opsiyonel ama güzel)
                Text(
                  "PawNav never shares your personal data.\nYour account security matters to us.",
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
