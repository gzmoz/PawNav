import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pawnav/app/theme/colors.dart';
import 'package:pawnav/features/account/presentations/widgets/AccountMenuComponent.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  static const String supportEmail = 'pawnav.support@gmail.com';

  @override
  Widget build(BuildContext context) {
    final screenInfo = MediaQuery.of(context);
    final double height = screenInfo.size.height;
    final double width = screenInfo.size.width;

    final user = Supabase.instance.client.auth.currentUser;
    final userEmail = user?.email ?? '';
    final userId = user?.id ?? '';

    return Scaffold(
      backgroundColor: AppColors.white4,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Support",
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
                // QUICK HELP
                _Section(
                  title: "QUICK HELP",
                  width: width,
                  child: Column(
                    children: [
                      AccountMenuComponent(
                        icon: Icons.email_outlined,
                        title: "Email Support",
                        onTap: () async {
                          await _openSupportMail(
                            subject: "PawNav Support",
                            body: _basicBody(userEmail: userEmail, userId: userId),
                          );
                        },
                      ),
                      AccountMenuComponent(
                        icon: Icons.bug_report_outlined,
                        title: "Report a Bug",
                        onTap: () async {
                          await _openSupportMail(
                            subject: "Bug Report – PawNav",
                            body: _bugBody(userEmail: userEmail, userId: userId),
                          );
                        },
                      ),
                      AccountMenuComponent(
                        icon: Icons.privacy_tip_outlined,
                        title: "Privacy & Account Questions",
                        onTap: () async {
                          await _openSupportMail(
                            subject: "Privacy / Account – PawNav",
                            body: _privacyBody(userEmail: userEmail, userId: userId),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                SizedBox(height: height * 0.02),

                // WHAT TO INCLUDE
                _Section(
                  title: "WHAT SHOULD I WRITE?",
                  width: width,
                  child: Padding(
                    padding: EdgeInsets.all(width * 0.04),
                    child: Text(
                      "To help you faster, include:\n"
                          "• What you were trying to do\n"
                          "• What happened (and what you expected)\n"
                          "• The page/feature name (e.g., Login & Security)\n"
                          "• If it’s a bug: screenshots + steps to reproduce\n\n"
                          "We usually reply using the same email thread.",
                      style: TextStyle(
                        fontSize: width * 0.035,
                        color: Colors.black87,
                        height: 1.35,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: height * 0.02),

                // CONTACT INFO (READ ONLY)
                _Section(
                  title: "YOUR INFO",
                  width: width,
                  child: Column(
                    children: [
                     /* AccountMenuComponent(
                        icon: Icons.person_outline,
                        title: userId.isEmpty ? "User ID: (not available)" : "User ID: $userId",
                        onTap: null,
                      ),*/
                      AccountMenuComponent(
                        icon: Icons.alternate_email,
                        title: userEmail.isEmpty ? "Email: (not available)" : "Email: $userEmail",
                        onTap: null,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: height * 0.04),

                Text(
                  "PawNav support is handled via email.\nWe never share your personal data.",
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

  // ---------- Email helpers ----------

  Future<void> _openSupportMail({
    required String subject,
    required String body,
  }) async {
    final uri = Uri(
      scheme: 'mailto',
      path: supportEmail,
      query: 'subject=${Uri.encodeComponent(subject)}'
          '&body=${Uri.encodeComponent(body)}',
    );

    // canLaunchUrl bazen false dönebiliyor; launchUrl denemek genelde yeterli
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  String _basicBody({required String userEmail, required String userId}) {
    return [
      "Hi PawNav Support,",
      "",
      "I need help with:",
      "- (write your issue here)",
      "",
      "Details:",
      "- What I did:",
      "- What happened:",
      "- What I expected:",
      "",
      "My info:",
      "- Email: ${userEmail.isEmpty ? "(not available)" : userEmail}",
      "",
      "Thanks!",
    ].join("\n");
  }

  String _bugBody({required String userEmail, required String userId}) {
    return [
      "Hi PawNav Support,",
      "",
      "Bug summary:",
      "- (one sentence)",
      "",
      "Steps to reproduce:",
      "1) ",
      "2) ",
      "3) ",
      "",
      "Expected result:",
      "- ",
      "",
      "Actual result:",
      "- ",
      "",
      "Extras (optional):",
      "- Screenshots / screen recording:",
      "- Device model:",
      "- Android/iOS version:",
      "- App version:",
      "",
      "My info:",
      "- Email: ${userEmail.isEmpty ? "(not available)" : userEmail}",
      "",
      "Thanks!",
    ].join("\n");
  }

  String _privacyBody({required String userEmail, required String userId}) {
    return [
      "Hi PawNav Support,",
      "",
      "I have a privacy/account question:",
      "- (write your question here)",
      "",
      "My info:",
      "- Email: ${userEmail.isEmpty ? "(not available)" : userEmail}",
      "",
      "Thanks!",
    ].join("\n");
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
