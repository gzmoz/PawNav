import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pawnav/app/router.dart';
import 'package:pawnav/app/theme/colors.dart';
import 'package:pawnav/features/account/presentations/cubit/profile_cubit.dart';
import 'package:pawnav/features/account/presentations/cubit/profile_state.dart';
import 'package:pawnav/features/account/presentations/widgets/user_rank_card.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().loadProfile();
  }
  @override
  Widget build(BuildContext context) {
    final screenInfo = MediaQuery.of(context);
    final double height = screenInfo.size.height;
    final double width = screenInfo.size.width;
    return Scaffold(
      extendBodyBehindAppBar: false,
      // backgroundColor: AppColors.background2,
      backgroundColor: AppColors.white5,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (BuildContext context, ProfileState state) {
            if (state is ProfileLoaded){
              return Text(
                state.profile.username,
                style: const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.w600),
              );
            }
            return const Text(
              "",
              style: TextStyle(color: Colors.black),
            );
          },
        ),


        actions: [
          GestureDetector(
            onTap: () {
              context.push('/menuProfile');
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 15),
              child: Icon(Icons.menu),
            ),
          ),
        ],
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (BuildContext context, ProfileState state) {
          if(state is ProfileLoading){
            return const Center(child: CircularProgressIndicator());
          }

          if(state is ProfileError){
            return Center(child: Text(state.message));
          }

          if(state is! ProfileLoaded){
            return const SizedBox.shrink();
          }
          final user = state.profile;

          return ScrollConfiguration(
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
                            radius: width * 0.15,
                            backgroundImage: user.photoUrl.isNotEmpty ? NetworkImage(user.photoUrl): null,
                            backgroundColor: Colors.grey.shade200,
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
                              user.name,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: width * 0.05),
                            ),
                            SizedBox(
                              height: width * 0.01,
                            ),
                            UserRankCard(
                              rankTitle: "Gold Helper",
                              rankIcon: Icons.workspace_premium,
                              rankColor: Colors.amber.shade700,
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      "8",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: width * 0.038),
                                    ),
                                    Text(
                                      "Listings",
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: width * 0.03),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 15),
                                Column(
                                  children: [
                                    Text(
                                      "22",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: width * 0.038),
                                    ),
                                    Text(
                                      "Saved",
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: width * 0.03),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 15),
                                Column(
                                  children: [
                                    Text(
                                      "8",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: width * 0.038),
                                    ),
                                    Text(
                                      "Successes",
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: width * 0.03),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),


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
                                Tab(icon: Icon(Icons.apps)),
                                // My Listings
                                Tab(icon: Icon(Icons.bookmark)),
                                // Saved
                                Tab(icon: Icon(Icons.emoji_events)),
                                // Success Stories
                              ],
                            ),
                          ),
                          SizedBox(
                            height: height * 0.4,
                            child: const TabBarView(
                              children: [
                                Center(
                                    child: Text("Your Listings will appear here.")),
                                Center(
                                    child: Text("Saved posts will appear here.")),
                                Center(
                                    child:
                                    Text("Success stories will appear here.")),
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
          );
        },

      ),
    );
  }
}
