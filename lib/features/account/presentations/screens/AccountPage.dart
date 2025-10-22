import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pawnav/app/theme/colors.dart';
import 'package:pawnav/core/widgets/custom_text_form_field.dart';
import 'package:pawnav/features/Account/presentations/widgets/AccountPageListingComponent.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    final screenInfo = MediaQuery.of(context);
    final double height = screenInfo.size.height;
    final double width = screenInfo.size.width;
    return Scaffold(
      backgroundColor: AppColors.background2,
      body: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false), //kaydırırken gözüken rengi kapat
        child: SingleChildScrollView(
          // physics: const ClampingScrollPhysics(),
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: height * 0.06,
                    bottom: height * 0.02,
                    left: width * 0.07),
                child: Text(
                  "Profile",
                  style: TextStyle(
                      fontSize: width * 0.06,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54),
                ),
              ),
              //charts
              Center(
                child: Column(
                  children: [
                    //top - profile name username
                    Container(
                      width: width * 0.9,
                      height: height * 0.1,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: width * 0.06, right: height * 0.03),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: width * 0.15,
                              height: height * 0.15,
                              child: Image.asset(
                                  "assets/login_screen/profile-picture.png"),
                            ),
                            SizedBox(width: width * 0.05),

                            //name-username
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Name",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: width * 0.05,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: height * 0.005),
                                Text(
                                  "UserName",
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: width * 0.03,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),

                            const Spacer(),

                            //edit button
                            Container(
                              width: width * 0.1,
                              height: width * 0.1,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.edit),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: height * 0.03),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: height * 0.001,
                            bottom: height * 0.02,
                            left: width * 0.07),
                        child: Text(
                          "Account",
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: width * 0.04,
                          ),
                        ),
                      ),
                    ),

                    Container(
                      width: width * 0.9,
                      // height: height * 0.35,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ListView(
                        physics: const NeverScrollableScrollPhysics(),
                        // kaydırmayı kapatır
                        shrinkWrap: true,
                        // container yüksekliğine göre sıkıştırır
                        children: const [
                          AccountPageListingComponent(
                            icon: Icons.person,
                            title: "My Profile",
                            subtitle: "Add or update your contact information. ",
                          ),
                          AccountPageListingComponent(
                            icon: Icons.pets,
                            title: "My Posts",
                            subtitle:
                                "See all your lost/found/adoption listings.",
                          ),
                          AccountPageListingComponent(
                            icon: Icons.bookmark,
                            title: "Saved Pets",
                            subtitle: "View the posts you bookmarked.",
                          ),

                        ],
                      ),
                    ),

                    SizedBox(height: height * 0.03),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: height * 0.001,
                            bottom: height * 0.02,
                            left: width * 0.07),
                        child: Text(
                          "Security & Privacy",
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: width * 0.04,
                          ),
                        ),
                      ),
                    ),

                    Container(
                      width: width * 0.9,
                      //height: height * 0.35,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ListView(
                        physics: const NeverScrollableScrollPhysics(),
                        // kaydırmayı kapatır
                        shrinkWrap: true,
                        // container yüksekliğine göre sıkıştırır
                        children: const [
                          AccountPageListingComponent(
                            icon: Icons.password,
                            title: "Login & Security",
                            subtitle:
                                "Change your password or manage your sign-in methods.",
                          ),
                          AccountPageListingComponent(
                            icon: Icons.pin_drop,
                            title: "Location Permissions",
                            subtitle:
                                "Allow PawNav to access your location to show nearby pets.",
                          ),
                          AccountPageListingComponent(
                            icon: Icons.notifications,
                            title: "Notification Settings",
                            subtitle:
                                "Choose when to receive alerts, new messages, and more.",
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: height * 0.03),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: height * 0.001,
                            bottom: height * 0.02,
                            left: width * 0.07),
                        child: Text(
                          "Community & Growth",
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: width * 0.04,
                          ),
                        ),
                      ),
                    ),

                    Container(
                      width: width * 0.9,
                      // height: height * 0.35,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ListView(
                        physics: const NeverScrollableScrollPhysics(),
                        // kaydırmayı kapatır
                        shrinkWrap: true,
                        // container yüksekliğine göre sıkıştırır
                        children: const [
                          AccountPageListingComponent(
                            icon: Icons.badge,
                            title: "Badges & Achievements",
                            subtitle:
                                "Check your current level and view the badges you’ve earned.",
                          ),
                          AccountPageListingComponent(
                            icon: Icons.people,
                            title: "Community Guidelines",
                            subtitle:
                                "Read the posting and messaging rules to keep PawNav safe for everyone.",
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: height * 0.03),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: height * 0.001,
                            bottom: height * 0.02,
                            left: width * 0.07),
                        child: Text(
                          "Help & App Info",
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: width * 0.04,
                          ),
                        ),
                      ),
                    ),

                    Container(
                      width: width * 0.9,
                      // height: height * 0.35,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ListView(
                        physics: const NeverScrollableScrollPhysics(),
                        // kaydırmayı kapatır
                        shrinkWrap: true,
                        // container yüksekliğine göre sıkıştırır
                        children: const [
                          AccountPageListingComponent(
                            icon: Icons.help,
                            title: "Help & Support",
                            subtitle:
                                "Contact us or report an issue with the app.",
                          ),
                          AccountPageListingComponent(
                            icon: Icons.info,
                            title: "About PawNav",
                            subtitle:
                                "Learn more about the app, its mission, and version details.",
                          ),AccountPageListingComponent(
                            icon: Icons.exit_to_app,
                            title: "Log Out",
                            subtitle:
                                "Sign out of your account.",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
