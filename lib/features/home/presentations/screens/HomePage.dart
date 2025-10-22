import 'package:flutter/material.dart';
import 'package:pawnav/app/theme/colors.dart';
import 'package:pawnav/features/home/presentations/widgets/home_screen_up_buttons.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final screenInfo = MediaQuery.of(context);
    final double height = screenInfo.size.height;
    final double width = screenInfo.size.width;
    return Scaffold(
      backgroundColor: AppColors.background2,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              // Row sadece içerik kadar yer kaplar
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/app_icon/android_icon.png',
                  height: 28,
                ),
                const SizedBox(width: 8),
                const Text(
                  "PawNav",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Row(
              children: [
                Icon(Icons.notifications_none, color: Colors.black),
                SizedBox(width: 12),
                // CircleAvatar(
                //   radius: 14,
                //   backgroundImage: AssetImage('assets/profile_pic.png'),
                // ),
              ],
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: height * 0.02),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12), // sol & sağ boşluk

                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      HomeButtonComponent(
                        icon: Icons.search,
                        title: "Lost a Pet",
                        subtitle:
                            "Post details to help others find your missing friend.",
                        onTap: () {
                          // Navigator.push(...)
                        },
                      ),
                      SizedBox(width: width * 0.01),

                      HomeButtonComponent(
                        icon: Icons.place_outlined,
                        title: "Found a Pet",
                        subtitle: "Share a post to reunite the pet with its owner.",
                        onTap: () {},
                      ),
                      SizedBox(width: width * 0.01),

                      HomeButtonComponent(
                        icon: Icons.home_outlined,
                        title: "Adopt a Pet",
                        subtitle:
                            "Browse adoption posts and give a pet a new home.",
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
