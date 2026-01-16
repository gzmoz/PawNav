import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pawnav/app/theme/colors.dart';
import 'package:pawnav/core/services/daily_badge_runner.dart';
import 'package:pawnav/core/utils/time_ago.dart';
import 'package:pawnav/features/home/presentations/cubit/featured_posts_cubit.dart';
import 'package:pawnav/features/home/presentations/cubit/featured_posts_state.dart';
import 'package:pawnav/features/home/presentations/cubit/recent_activity_cubit.dart';
import 'package:pawnav/features/home/presentations/cubit/recent_activity_state.dart';
import 'package:pawnav/features/home/presentations/widgets/community_tips_card.dart';
import 'package:pawnav/features/home/presentations/widgets/feature_pet_card.dart';
import 'package:pawnav/features/home/presentations/widgets/home_screen_up_buttons.dart';
import 'package:pawnav/features/home/presentations/widgets/recent_activity_card.dart';
import 'package:pawnav/features/home/presentations/widgets/success_stories_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

final List<String> imagePaths = [
  "assets/representative/cat1.jpg",
  "assets/representative/cat2.jpg",
  "assets/representative/dog1.jpg"
];

late List<Widget> _pages;

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pages = List.generate(imagePaths.length,
        (index) => SuccessStoriesCustom(imagePath: imagePaths[index]));

    //context.read<FeaturedPostsCubit>().loadTop5();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      DailyBadgeRunner.run(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenInfo = MediaQuery.of(context);
    final double height = screenInfo.size.height;
    final double width = screenInfo.size.width;
    return Scaffold(
      backgroundColor: AppColors.white5,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: Padding(
          padding: EdgeInsets.all(width * 0.035),
          child: Image.asset(
            "assets/app_icon/icon_transparent.png",
            fit: BoxFit.contain,
          ),
        ),
        title: const Text(
          "PawNav",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        actions: [
          GestureDetector(
            onTap: () {},
            child: const Padding(
              padding: EdgeInsets.only(right: 15),
              child: Icon(Icons.notifications_none),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 50),
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: height * 0.02),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  // sol & sağ boşluk

                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      HomeButtonComponent(
                        icon: Icons.search,
                        title: "Lost a Pet",
                        subtitle:
                            "Post details to help others find your missing friend.",
                        onTap: () {
                          this.context.push('/addPostForm?type=Lost');
                        },
                      ),
                      SizedBox(width: width * 0.01),
                      HomeButtonComponent(
                        icon: Icons.place_outlined,
                        title: "Found a Pet",
                        subtitle:
                            "Share a post to reunite the pet with its owner.",
                        onTap: () {
                          this.context.push('/addPostForm?type=Found');
                        },
                      ),
                      SizedBox(width: width * 0.01),
                      HomeButtonComponent(
                        icon: Icons.home_outlined,
                        title: "Rehome a Pet",
                        subtitle:
                            "Post an adoption ad and connect with adopters.",
                        onTap: () {
                          this.context.push('/addPostForm?type=Adoption');
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

            //SUCCESS STORIES
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: width * 0.05,
                      right: width * 0.05,
                      top: height * 0.02,
                      bottom: height * 0.015),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Success Stories",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: width * 0.05,
                        ),
                      ),
                      Text(
                        "View More",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: width * 0.03,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: height * 0.25,
                  child: CarouselSlider(
                    options: CarouselOptions(
                      height: height * 0.25,
                      autoPlay: true,
                      enlargeCenterPage: true,
                      // ortadaki büyür, kenarlarda boşluk olur
                      padEnds: true,
                      enlargeFactor: 0.19,
                      viewportFraction: 0.85,
                    ),
                    items: imagePaths.map((imagePath) {
                      return Builder(
                        builder: (context) {
                          return SuccessStoriesCustom(
                            imagePath: imagePath,
                            title: "Reunited: Rocky & His Family",
                            description:
                                "We never lost hope, and thanks to a fellow PawNav user, Rocky is back home!",
                          );
                        },
                      );
                    }).toList(),
                  ),

                  /*PageView.builder(
                      itemCount: imagePaths.length,
                      itemBuilder: (context, index ) {
                        return _pages[index];
                      }),*/
                ),
              ],
            ),

            Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: width * 0.05,
                      right: width * 0.05,
                      top: height * 0.02,
                      bottom: height * 0.015),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Featured Pets",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: width * 0.05,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          context.push('/most-viewed');
                        },
                        child: Text(
                          "View More",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: width * 0.03,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: BlocBuilder<FeaturedPostsCubit, FeaturedPostsState>(
                    builder: (context, state) {
                      if (state is FeaturedPostsLoading) {
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (state is FeaturedPostsLoaded) {
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Row(
                              children: state.posts.map((post) {
                                return FeaturedPetCard(
                                  petName: post.name ?? '',
                                  status: post.postType,
                                  location: post.location,
                                  imageUrl: post.images.isNotEmpty
                                      ? post.images.first
                                      : '',
                                  onTap: () {
                                    context.push('/post-detail/${post.id}');
                                  },
                                );
                              }).toList(),
                            ),
                          ),
                        );
                      }

                      if (state is FeaturedPostsError) {
                        return Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            state.message,
                            style: const TextStyle(color: Colors.red),
                          ),
                        );
                      }

                      return const SizedBox.shrink();
                    },
                  ),

                  /*Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        */ /*FeaturedPetCard(
                          petName: "Buddy",
                          status: "Lost",
                          location: "San Francisco, CA",
                          imageUrl:
                              "https://images.unsplash.com/photo-1592194996308-7b43878e84a6?w=800",
                        ),
                        FeaturedPetCard(
                          petName: "Lucy",
                          status: "Found",
                          location: "Oakland, CA",
                          imageUrl:
                              "https://images.unsplash.com/photo-1568572933382-74d440642117?w=800",
                        ),
                        FeaturedPetCard(
                          petName: "Max",
                          status: "Lost",
                          location: "Los Angeles, CA",
                          imageUrl:
                              "https://images.unsplash.com/photo-1558788353-f76d92427f16?w=800",
                        ),
                        FeaturedPetCard(
                          petName: "Bella",
                          status: "Adoption",
                          location: "San Diego, CA",
                          imageUrl:
                              "https://images.unsplash.com/photo-1507149833265-60c372daea22?w=800",
                        ),*/ /*
                      ],
                    ),
                  ),*/
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: width * 0.05,
                      right: width * 0.05,
                      top: height * 0.02,
                      bottom: height * 0.015),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Community Tips",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: width * 0.05,
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    children: [
                      CommunityTipsCard(
                          icon: Icons.tips_and_updates,
                          iconColor: AppColors.primary,
                          title: "What to do if you find a lost pet",
                          description:
                              "Check for ID, take them to a vet to scan for a microchip, and post on PawNav."),
                      SizedBox(
                        height: 0.05,
                      ),
                      CommunityTipsCard(
                          icon: Icons.pets,
                          iconColor: AppColors.primary,
                          title: "Keeping your pet safe",
                          description:
                              "Ensure your pet is microchipped and wears a collar with your contact information."),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: width * 0.05,
                      right: width * 0.05,
                      top: height * 0.02,
                      bottom: height * 0.015),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Recent Activity",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: width * 0.05,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          context.push('/recent-activity');
                        },
                        child: Text(
                          "View More",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: width * 0.03,
                            color: AppColors.primary,
                          ),
                        ),
                      ),

                      /*Text(
                        "Recent Activity",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: width * 0.05,
                        ),
                      ),
                      Text(
                        "View More",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: width * 0.03,
                          color: AppColors.primary,
                        ),
                      ),*/
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: width * 0.05,
                      right: width * 0.05,
                      // top: height * 0.02,
                      bottom: height * 0.015),
                  child: BlocBuilder<RecentActivityCubit, RecentActivityState>(
                    builder: (context, state) {
                      if (state is RecentActivityLoading) {
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (state is RecentActivityLoaded) {
                        return Column(
                          children: state.posts.map((post) {
                            return RecentActivityCard(
                              imageUrl: post.imageUrl,
                              title: "${post.postType}: ${post.name}",
                              subtitle:
                                  "${post.location} • ${timeAgo(post.createdAt)}",
                              onTap: () {
                                context.push('/post-detail/${post.id}');
                              },
                            );
                          }).toList(),
                        );
                      }

                      if (state is RecentActivityError) {
                        return Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            'Error: ${state.message}',
                            style: const TextStyle(color: Colors.red),
                          ),
                        );
                      }

                      return const SizedBox.shrink();
                    },
                  ),

                  /*Column(
                    children: [
                      RecentActivityCard(
                        imageUrl:
                        "https://images.unsplash.com/photo-1517849845537-4d257902454a?w=400",
                        title: "Found: Calico Cat",
                        subtitle: "Near Lake Merritt, 2 hours ago",
                        onTap: () {},
                      ),
                      RecentActivityCard(
                        imageUrl:
                        "https://images.unsplash.com/photo-1507149833265-60c372daea22?w=400",
                        title: "Lost: Brown Dog \"Rocky\"",
                        subtitle: "Downtown Austin, 5 hours ago",
                        onTap: () {},
                      ),
                      RecentActivityCard(
                        imageUrl:
                        "https://images.unsplash.com/photo-1568572933382-74d440642117?w=400",
                        title: "For Adoption: 2 Kittens",
                        subtitle: "SPCA Shelter, 1 day ago",
                        onTap: () {},
                      ),
                      RecentActivityCard(
                        imageUrl:
                        "https://images.unsplash.com/photo-1555685812-4b943f1cb0eb?w=400",
                        title: "Found: Golden Retriever",
                        subtitle: "Near Riverside Park, 1 hour ago",
                        onTap: () {},
                      ),
                      RecentActivityCard(
                        imageUrl:
                        "https://images.unsplash.com/photo-1543852786-1cf6624b9987?w=400",
                        title: "Lost: Black Cat \"Luna\"",
                        subtitle: "Central Park, 3 hours ago",
                        onTap: () {},
                      ),
                    ],
                  ),*/
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
