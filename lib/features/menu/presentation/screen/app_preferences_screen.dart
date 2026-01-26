import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pawnav/app/theme/colors.dart';
import 'package:pawnav/features/account/presentations/widgets/AccountMenuComponent.dart';

class AppPreferencesPage extends StatelessWidget {
  const AppPreferencesPage({super.key});

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
          "App Preferences",
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
                /// APPEARANCE
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "APPEARANCE",
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
                            icon: Icons.dark_mode_outlined,
                            title: 'Theme',
                            //subtitle: 'Light / Dark / System',
                            onTap: () {
                              // theme selection bottom sheet (sonra bağlarız)
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                /// LANGUAGE
                Padding(
                  padding: EdgeInsets.only(top: height * 0.02),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "LANGUAGE",
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
                              icon: Icons.language_outlined,
                              title: 'Language',
                              //subtitle: 'English',
                              onTap: () {
                                // language picker (bottom sheet)
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: height * 0.04),

                /// INFO TEXT
                Text(
                  "Customize how PawNav looks and feels.\nYour preferences are saved on this device.",
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
