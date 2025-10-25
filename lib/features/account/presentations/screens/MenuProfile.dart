import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pawnav/app/theme/colors.dart';
import 'package:pawnav/features/account/presentations/widgets/AccountMenuComponent.dart';

class MenuProfile extends StatefulWidget {
  const MenuProfile({super.key});

  @override
  State<MenuProfile> createState() => _MenuProfileState();
}

class _MenuProfileState extends State<MenuProfile> {
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
          "Profile Options",
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: width * 0.05),
        ),
        leading: IconButton(
            onPressed: () {
              context.pop();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
      ),
      body: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).padding.bottom + 50),
          child: Padding(
            padding: EdgeInsetsDirectional.symmetric(
                horizontal: width * 0.05, vertical: height * 0.03),
            child: Column(
              children: [
                //account
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "ACCOUNT",
                      style: TextStyle(
                          fontSize: width * 0.035,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                    Container(
                      padding: EdgeInsetsDirectional.symmetric(
                          horizontal: width * 0.02, vertical: height * 0.02),
                      margin: const EdgeInsets.only(top: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Column(
                        children: [
                          AccountMenuComponent(
                            icon: Icons.person_outline,
                            title: 'My Profile',
                          ),
                          AccountMenuComponent(
                            icon: Icons.list_alt,
                            title: 'My Posts',
                          ),
                          AccountMenuComponent(
                            icon: Icons.bookmark_border_outlined,
                            title: 'Saved Posts',
                          ),
                          AccountMenuComponent(
                            icon: Icons.emoji_events_outlined,
                            title: 'Success Stories',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                //SECURITY & PRIVACY
                Padding(
                  padding: EdgeInsets.only(top: height * 0.02),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "SECURITY & PRIVACY",
                        style: TextStyle(
                            fontSize: width * 0.035,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      ),
                      Container(
                        padding: EdgeInsetsDirectional.symmetric(
                            horizontal: width * 0.02, vertical: height * 0.02),
                        margin: const EdgeInsets.only(top: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Column(
                          children: [
                            AccountMenuComponent(
                              icon: Icons.lock_outlined,
                              title: 'Login & Security',
                            ),
                            AccountMenuComponent(
                              icon: Icons.location_on_outlined,
                              title: 'Location Permissions',
                            ),
                            AccountMenuComponent(
                              icon: Icons.notifications_on_outlined,
                              title: 'Notifications Settings',
                            ),
                            AccountMenuComponent(
                              icon: Icons.settings_outlined,
                              title: 'App Settings',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                //COMMUNITY & GROWTH
                Padding(
                  padding: EdgeInsets.only(top: height * 0.02),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "COMMUNITY & GROWTH",
                        style: TextStyle(
                            fontSize: width * 0.035,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      ),
                      Container(
                        padding: EdgeInsetsDirectional.symmetric(
                            horizontal: width * 0.02, vertical: height * 0.02),
                        margin: const EdgeInsets.only(top: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Column(
                          children: [
                            AccountMenuComponent(
                              icon: Icons.workspace_premium_outlined,
                              title: 'Badges & Achievements',
                            ),
                            AccountMenuComponent(
                              icon: Icons.people_outline,
                              title: 'Community Guidelines',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                //HELP & APP INFO
                Padding(
                  padding: EdgeInsets.only(top: height * 0.02),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "HELP & APP INFO",
                        style: TextStyle(
                            fontSize: width * 0.035,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      ),
                      Container(
                        padding: EdgeInsetsDirectional.symmetric(
                            horizontal: width * 0.02, vertical: height * 0.02),
                        margin: const EdgeInsets.only(top: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            const AccountMenuComponent(
                              icon: Icons.help_outline,
                              title: 'Help & Support',
                            ),
                            const AccountMenuComponent(
                              icon: Icons.info_outline,
                              title: 'About PawNav',
                            ),
                            // LOG OUT
                            ListTile(
                              leading: Container(
                                width: width * 0.1,
                                height: width * 0.1,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFFFFE6E6), // açık kırmızı arka plan
                                ),
                                child: const Icon(Icons.logout, color: Colors.red),
                              ),
                              title: Text(
                                "Log Out",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: width * 0.04,
                                ),
                              ),
                              onTap: () {
                                // logout logic
                              },
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
      ),
    );
  }
}
