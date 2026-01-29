import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pawnav/app/theme/colors.dart';
import 'package:pawnav/features/account/presentations/widgets/AccountMenuComponent.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPawNavPage extends StatelessWidget {
  const AboutPawNavPage({super.key});

  static const String supportEmail = 'pawnavoz@gmail.com';

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
          "About PawNav",
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
                // WHAT IS PAWNAV
                _Section(
                  title: "WHAT IS PAWNAV?",
                  width: width,
                  child: Padding(
                    padding: EdgeInsets.all(width * 0.04),
                    child: Text(
                      "PawNav is a community driven platform designed to help lost pets find their way home.\n\n"
                          "Users can share lost and found pet posts, view nearby reports on a map, and connect directly "
                          "with others to reunite pets with their families.",
                      style: TextStyle(
                        fontSize: width * 0.035,
                        color: Colors.black87,
                        height: 1.35,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: height * 0.02),

                // MISSION
                _Section(
                  title: "OUR MISSION",
                  width: width,
                  child: Padding(
                    padding: EdgeInsets.all(width * 0.04),
                    child: Text(
                      "Our mission is to make pet recovery faster, more local, and more human.\n\n"
                          "We believe that small, location-based actions can make a huge difference "
                          "when time matters the most.",
                      style: TextStyle(
                        fontSize: width * 0.035,
                        color: Colors.black87,
                        height: 1.35,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: height * 0.02),

                // HOW IT WORKS
                _Section(
                  title: "HOW IT WORKS",
                  width: width,
                  child: Padding(
                    padding: EdgeInsets.all(width * 0.04),
                    child: Text(
                      "• Create a lost or found pet post\n"
                          "• Add photos, details, and last known location\n"
                          "• View nearby reports on the map\n"
                          "• Contact the post owner directly\n\n"
                          "PawNav does not act as an intermediary communication happens directly between users.",
                      style: TextStyle(
                        fontSize: width * 0.035,
                        color: Colors.black87,
                        height: 1.35,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: height * 0.02),

                // PRIVACY & DATA
                _Section(
                  title: "PRIVACY & DATA",
                  width: width,
                  child: Padding(
                    padding: EdgeInsets.all(width * 0.04),
                    child: Text(
                      "Your privacy matters.\n\n"
                          "PawNav only stores the information necessary to operate the app. "
                          "We never sell personal data or share it with third parties.\n\n"
                          "You are always in control of your content and can delete your account at any time.",
                      style: TextStyle(
                        fontSize: width * 0.035,
                        color: Colors.black87,
                        height: 1.35,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: height * 0.02),

                // CONTACT
                _Section(
                  title: "CONTACT",
                  width: width,
                  child: Column(
                    children: [
                      AccountMenuComponent(
                        icon: Icons.help_outline,
                        title: "Contact Support",
                        onTap: () async {
                          final uri = Uri(
                            scheme: 'mailto',
                            path: supportEmail,
                            query:
                            'subject=${Uri.encodeComponent("PawNav Support")}'
                                '&body=${Uri.encodeComponent("Hi PawNav Team,\\n\\n")}',
                          );
                          await launchUrl(
                            uri,
                            mode: LaunchMode.externalApplication,
                          );
                        },
                      ),
                    ],
                  ),
                ),

                SizedBox(height: height * 0.04),

                // FOOTER
                Text(
                  "PawNav is an independent project built with care.\nThank you for being part of the community.",
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
