import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:go_router/go_router.dart';
import 'package:pawnav/app/router.dart';
import 'package:pawnav/app/theme/colors.dart';
import 'package:pawnav/features/account/presentations/widgets/user_rank_card.dart';

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
      extendBodyBehindAppBar: false,
      // backgroundColor: AppColors.background2,
      backgroundColor: AppColors.white4,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "sara.p",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        actions: [
          GestureDetector(
            onTap: (){
              context.push('/menuProfile');
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 15),
              child: Icon(Icons.menu),
            ),
          ),
        ],
      ),
      body: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
        //kaydırırken gözüken rengi kapat
        child: SingleChildScrollView(
          // physics: const ClampingScrollPhysics(),
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).padding.bottom + 50),
          //profile photo-name-badge
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.only(left: width * 0.09, top: height * 0.02),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 3,
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: width * 0.17,
                        // backgroundImage: const AssetImage('assets/representative/zomzom.png'),
                        // backgroundColor: Colors.transparent,
                      ),
                    ),
                  ),
                  //name- badge
                  Padding(
                    padding:
                        EdgeInsets.only(left: width * 0.05, top: height * 0.02),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "Sara Pawlson",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: width * 0.055),
                        ),
                        SizedBox(
                          height: width * 0.02,
                        ),
                        UserRankCard(
                          rankTitle: "Gold Helper",
                          rankIcon: Icons.workspace_premium,
                          rankColor: Colors.amber.shade700,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              /*//edit button
              Padding(
                padding: EdgeInsets.only(top: height * 0.03),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      // backgroundColor: AppColors.primary.withOpacity(0.2),
                      backgroundColor: AppColors.background,
                      // backgroundColor: Colors.grey[300],
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                    ),
                    child: const Text("Edit Profile",
                        style: TextStyle(color: Colors.black)),
                  ),
                ),
              ),*/

              Padding(
                padding: EdgeInsets.only(top: height * 0.03),
                child: DefaultTabController(
                  length: 3,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                        child: const TabBar(
                          indicatorColor: AppColors.primary,
                          labelColor: AppColors.primary,
                          unselectedLabelColor: Colors.grey,
                          tabs: [
                            Tab(icon: Icon(Icons.apps)),           // My Listings
                            Tab(icon: Icon(Icons.bookmark)),// Saved
                            Tab(icon: Icon(Icons.emoji_events)),   // Success Stories
                          ],
                        ),
                      ),
                      SizedBox(
                        height: height * 0.4,
                        child: const TabBarView(
                          children: [
                            Center(child: Text("Your Listings will appear here.")),
                            Center(child: Text("Saved posts will appear here.")),
                            Center(child: Text("Success stories will appear here.")),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
