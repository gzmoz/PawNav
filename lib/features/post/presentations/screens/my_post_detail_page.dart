
import 'package:flutter/material.dart';
import 'package:pawnav/app/theme/colors.dart';
import 'package:pawnav/core/utils/post_status.dart';
import 'package:pawnav/features/post/presentations/widgets/info_mini_card.dart';
import 'package:pawnav/features/post/presentations/widgets/location_card.dart';
import 'package:pawnav/features/post/presentations/widgets/my_carousel.dart';
import 'package:pawnav/features/post/presentations/widgets/section_card.dart';
import 'package:pawnav/features/post/presentations/widgets/top_info_card.dart';

class MyPostDetailPage extends StatefulWidget {
  final String postId;
  const MyPostDetailPage({super.key, required this.postId});

  @override
  State<MyPostDetailPage> createState() => _MyPostDetailPageState();
}

class _MyPostDetailPageState extends State<MyPostDetailPage> {
  @override
  Widget build(BuildContext context) {



    //dummy data
    const postType = "Lost";
    const petName = "Buddy";
    const breed = "Golden Retriever";
    const views = 1204;
    const postedAgo = "Posted 2 days ago";
    const species = "Dog";
    const gender = "unknown";
    const color = "Golden";
    const lastSeen = "Oct 24, 2023";

    final genderUI = getGenderUI(gender);


    const about =
        "Buddy went missing near Central Park on Tuesday afternoon. He is very friendly but might be scared. He was wearing a blue collar with a tag, but it might have fallen off. He loves treats and responds to his name. Please help us bring him home!";

    const locationText = "5th Ave & 72nd St, New York, NY";

    final images = [
      "https://images.unsplash.com/photo-1552053831-71594a27632d?w=1600",
      "https://images.unsplash.com/photo-1517849845537-4d257902454a?w=1600",
      "https://images.unsplash.com/photo-1548199973-03cce0bbc87b?w=1600",
    ];

    final statusColor = PostStatusStyle.color(postType);
    final statusBg = PostStatusStyle.background(postType);

    return Scaffold(
      backgroundColor: AppColors.white5,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            title: const Text(
              "Post Detail",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
              ),
            ),
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
            ),
            actions: [
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.share,
                    color: Colors.black,
                  )),
            ],
          ),

          //carousel
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
              child: MyCarousel(
                images: images,
                statusText: postType.toUpperCase(),
                statusColor: statusColor,
                statusBg: statusBg,
              ),
            ),
          ),

          //content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 28),
              child: Column(
                children: [
                  //top info card (name +views+ posted)
                  const TopInfoCard(
                    name: petName,
                    breed: breed,
                    views: views,
                    postedAgo: postedAgo,
                  ),

                  const SizedBox(height: 12),

                  // 2x2 info cards
                  Row(
                    children: [
                      const Expanded(
                        child: InfoMiniCard(
                          title: "SPECIES",
                          value: species,
                          icon: Icons.pets,
                          iconBg: Color(0xFFE9EDFF),
                          iconColor: Color(0xFF3B5BDB),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: InfoMiniCard(
                          title: "GENDER",
                          value: gender,
                          icon: genderUI.icon,
                          iconBg: genderUI.bgColor,
                          iconColor: genderUI.iconColor,
                        ),
                      ),

                    ],
                  ),
                  const SizedBox(height: 12),
                  const Row(
                    children: [
                      Expanded(
                        child: InfoMiniCard(
                          title: "COLOR",
                          value: color,
                          icon: Icons.palette,
                          iconBg: Color(0xFFFFF1E6),
                          iconColor: Color(0xFFFF7A00),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: InfoMiniCard(
                          title: "LAST SEEN",
                          value: lastSeen,
                          icon: Icons.calendar_month,
                          iconBg: Color(0xFFFFE9E9),
                          iconColor: Color(0xFFE03131),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // About card
                  const SectionCard(
                    title: "About $petName",
                    icon: Icons.description_outlined,
                    child: Text(
                      about,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 15,
                        height: 1.35,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Location card (map placeholder)
                  const LocationCard(
                    title: "Last Seen Location",
                    address: locationText,
                  ),
                  const SizedBox(height: 20),

                  // OWNER ACTIONS
                  const Text(
                    "OWNER ACTIONS",
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 15),


                  // Mark as reunited
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.celebration_outlined),
                      label: const Text("Mark as Reunited!"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF18B394),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  //edit+delete row
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 52,
                          child: OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.edit_outlined),
                            label: const Text("Edit Post"),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.black87,
                              side: BorderSide(color: Colors.grey.shade300),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SizedBox(
                          height: 52,
                          child: OutlinedButton.icon(
                            onPressed: () {},
                            label: const Text("Delete Post"),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              side: BorderSide(color: Colors.red.shade200),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GenderUIData {
  final IconData icon;
  final Color bgColor;
  final Color iconColor;

  const GenderUIData({
    required this.icon,
    required this.bgColor,
    required this.iconColor,
  });
}

GenderUIData getGenderUI(String? gender) {
  switch (gender?.toLowerCase()) {
    case "female":
      return const GenderUIData(
        icon: Icons.female,
        bgColor: Color(0xFFFFE4EC),
        iconColor: Color(0xFFE91E63),
      );

    case "male":
      return const GenderUIData(
        icon: Icons.male,
        bgColor: Color(0xFFE9EDFF),
        iconColor: Color(0xFF3B5BDB),
      );

    default: // unknown
      return const GenderUIData(
        icon: Icons.help_outline,
        bgColor: Color(0xFFF1F3F5),
        iconColor: Color(0xFF868E96),
      );
  }
}
