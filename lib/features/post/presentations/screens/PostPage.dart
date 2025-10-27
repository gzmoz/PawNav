import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pawnav/app/router.dart';
import 'package:pawnav/app/theme/colors.dart';
import 'package:pawnav/features/post/presentations/widgets/post_card.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  /*String formatTimeAgo(DateTime postDate) {
    final diff = DateTime.now().difference(postDate);

    if (diff.inSeconds < 60) {
      return "Just now";
    } else if (diff.inMinutes < 60) {
      return "Posted ${diff.inMinutes} minutes ago";
    } else if (diff.inHours < 24) {
      return "Posted ${diff.inHours} hours ago";
    } else if (diff.inDays < 7) {
      return "Posted ${diff.inDays} days ago";
    } else {
      final weeks = (diff.inDays / 7).floor();
      return "Posted $weeks week${weeks > 1 ? 's' : ''} ago";
    }
  }*/

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  @override
  Widget build(BuildContext context) {
    final screenInfo = MediaQuery.of(context);
    final double height = screenInfo.size.height;
    final double width = screenInfo.size.width;

    // Örnek ilan verileri
    /*final posts = [
      {
        "image":
        "https://images.unsplash.com/photo-1558788353-f76d92427f16",
        "name": "Buddy",
        "location": "Near Central Park, NYC",
        "description":
        "Friendly Golden Retriever, last seen near Prospect Park. Has a blue collar.",
        "status": "Lost",
        "postDate": DateTime.now().subtract(const Duration(minutes: 45)),
      },
      {
        "image":
        "https://images.unsplash.com/photo-1592194996308-7b43878e84a6",
        "name": "Luna",
        "location": "Downtown, Brooklyn",
        "description":
        "Found this sweet cat near the library. Very friendly and appears to be well-cared for.",
        "status": "Found",
        "postDate": DateTime.now().subtract(const Duration(hours: 3)),
      },
      {
        "image":
        "https://images.unsplash.com/photo-1601758123927-1960c88fda55",
        "name": "Milo",
        "location": "Queens, NYC",
        "description":
        "Lovely kitten looking for a new home. Vaccinated and very playful.",
        "status": "Adoption",
        "postDate": DateTime.now().subtract(const Duration(days: 1, hours: 5)),
      },
    ];*/
    return Scaffold(
      // backgroundColor: AppColors.white3,
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
          IconButton(
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: CustomSearchDelegate(),
                );
              },
              icon: const Icon(Icons.search))
        ],
      ),
      body: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.only(
              bottom: MediaQuery
                  .of(context)
                  .padding
                  .bottom + 50),
          child: Column(
            children: [
              Padding(
                padding:
                EdgeInsets.symmetric(horizontal: width * 0.07, vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.01),
                            blurRadius: 8,
                            offset: Offset(1, 1),
                          ),
                        ],
                      ),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: AppColors.white5,
                            // sheet’in arka plan rengi
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                              ),
                            ),
                            builder: (BuildContext context) {
                              String selectedOption = "Newest"; //default secim

                              return StatefulBuilder(
                                builder: (context, setState) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30, vertical: 16),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        //drag indicator
                                        Center(
                                          child: Container(
                                            width: width * 0.2,
                                            height: 2,
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade400,
                                              borderRadius:
                                              BorderRadius.circular(12),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 16),

                                        //title
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Sort by Date",
                                              style: TextStyle(
                                                fontSize: width * 0.05,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                context.pop();
                                              },
                                              icon: const Icon(Icons.close),
                                            ),
                                          ],
                                        ),

                                        const SizedBox(height: 3),
                                        Divider(
                                            color: Colors.grey.shade300,
                                            height: 1),
                                        const SizedBox(height: 10),

                                        //radio buttons
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(12),
                                            /* border: Border.all(
                                                color:
                                                    selectedOption == "Newest"
                                                        ? AppColors.primary
                                                        : Colors.grey.shade300),*/
                                            color: selectedOption == "Newest"
                                                ? AppColors.background
                                                : Colors.white,
                                          ),
                                          child: RadioListTile<String>(
                                            title:
                                            const Text("Newest to Oldest"),
                                            value: "Newest",
                                            groupValue: selectedOption,
                                            activeColor: AppColors.primary,
                                            onChanged: (value) {
                                              setState(() =>
                                              selectedOption = value!);
                                            },
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(12),
                                            /* border: Border.all(
                                                color:
                                                    selectedOption == "Newest"
                                                        ? AppColors.primary
                                                        : Colors.grey.shade300),*/
                                            color: selectedOption == "Oldest"
                                                ? AppColors.background
                                                : Colors.white,
                                          ),
                                          child: RadioListTile<String>(
                                            title:
                                            const Text("Oldest to Newest"),
                                            value: "Oldest",
                                            groupValue: selectedOption,
                                            activeColor: AppColors.primary,
                                            onChanged: (value) {
                                              setState(() =>
                                              selectedOption = value!);
                                            },
                                          ),
                                        ),
                                        //close and approve buttons
                                        Padding(
                                          padding:
                                          const EdgeInsets.only(top: 12.0),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [
                                              /*TextButton(
                                                onPressed: () {
                                                  context.pop();
                                                },
                                                child: const Text(
                                                  "Cancel",
                                                  style: TextStyle(
                                                      color: Colors.grey),
                                                ),
                                              ),*/
                                              ElevatedButton(
                                                onPressed: () {
                                                  context.pop(selectedOption);
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                  AppColors.primary,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        15),
                                                  ),
                                                  minimumSize: Size(width * 0.8,
                                                      height * 0.05),
                                                ),
                                                child: const Text(
                                                  "Apply",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                        icon: const Icon(
                          Icons.swap_vert,
                          size: 18,
                        ),
                        label: const Text("Sort"),
                        style: ElevatedButton.styleFrom(
                          // backgroundColor: Colors.grey.shade200,
                          backgroundColor: AppColors.background,
                          foregroundColor: Colors.grey.shade700,
                          // foregroundColor: Colors.grey.shade700,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                        ),
                      ),
                    ),
                    //FILTER BUTTON
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.01),
                            blurRadius: 8,
                            offset: Offset(1, 1),
                          ),
                        ],
                      ),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.white,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                              ),
                            ),
                            builder: (BuildContext context) {
                              String selectedPostType = "Lost";
                              double radiusValue = 10;
                              String selectedAnimal = "Dog";
                              String selectedBreed = "Any";
                              final TextEditingController locationController =
                              TextEditingController();

                              return StatefulBuilder(
                                builder: (context, setState) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 16),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          //drag indicator
                                          Center(
                                            child: Container(
                                              width: width * 0.2,
                                              height: 2,
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade400,
                                                borderRadius:
                                                BorderRadius.circular(12),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 16),

                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Filters",
                                                style: TextStyle(
                                                  fontSize: width * 0.05,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  context.pop();
                                                },
                                                icon: const Icon(Icons.close),
                                              ),
                                            ],
                                          ),

                                          Divider(
                                            color: Colors.grey.shade300,
                                            height: 1,
                                          ),

                                          const SizedBox(height: 15),

                                          Text(
                                            "Post Type",
                                            style: TextStyle(
                                              fontSize: width * 0.042,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),

                                          const SizedBox(height: 4),

                                          Text(
                                            "Select one or more post types.",
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: width * 0.033),
                                          ),

                                          const SizedBox(height: 12),


                                          Center(
                                            child: Wrap(
                                              spacing: 10,
                                              children: ["Lost", "Found", "Adoption"].map((type) {
                                                final isSelected = selectedPostType == type;

                                                return GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      selectedPostType = type;
                                                    });
                                                  },
                                                  child: AnimatedContainer(
                                                    duration: const Duration(milliseconds: 200),
                                                    padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                                                    decoration: BoxDecoration(
                                                      color: isSelected ? Colors.blueAccent : const Color(0xFFF3F4F6),
                                                      borderRadius: BorderRadius.circular(30),
                                                      boxShadow: isSelected
                                                          ? [
                                                        BoxShadow(
                                                          color: Colors.blue.withOpacity(0.25),
                                                          blurRadius: 6,
                                                          offset: const Offset(0, 2),
                                                        )
                                                      ]
                                                          : [],
                                                    ),
                                                    child: Text(
                                                      type,
                                                      style: TextStyle(
                                                        color: isSelected ? Colors.white : Colors.black87,
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                          ),

                                          const SizedBox(height: 15),

                                          Text(
                                            "Location Filter",
                                            style: TextStyle(
                                              fontSize: width * 0.042,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),



                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                        icon: const Icon(
                          Icons.filter_list,
                          size: 18,
                        ),
                        label: const Text("Filters"),
                        style: ElevatedButton.styleFrom(
                          // backgroundColor: Colors.grey.shade200,
                          backgroundColor: AppColors.background,
                          foregroundColor: Colors.grey.shade700,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                EdgeInsets.symmetric(horizontal: width * 0.07, vertical: 4),
                child: const Column(
                  children: [
                    PostCardComponent(
                        imageUrl:
                        "https://images.unsplash.com/photo-1558788353-f76d92427f16",
                        name: "Buddy",
                        location: "Near Central Park, NYC",
                        description:
                        "Friendly Golden Retriever, last seen near Prospect Park. Has a blue collar.",
                        status: "Lost",
                        timeAgoText: "Posted 3 hours ago"),
                    PostCardComponent(
                        imageUrl:
                        "https://images.unsplash.com/photo-1558788353-f76d92427f16",
                        name: "Buddy",
                        location: "Near Central Park, NYC",
                        description:
                        "Friendly Golden Retriever, last seen near Prospect Park. Has a blue collar.",
                        status: "Found",
                        timeAgoText: "Posted 3 hours ago"),
                    PostCardComponent(
                        imageUrl:
                        "https://images.unsplash.com/photo-1558788353-f76d92427f16",
                        name: "Buddy",
                        location: "Near Central Park, NYC",
                        description:
                        "Friendly Golden Retriever, last seen near Prospect Park. Has a blue collar.",
                        status: "Adoption",
                        timeAgoText: "Posted 3 hours ago"),
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

class CustomSearchDelegate extends SearchDelegate {
  List<String> searchTerms = [];

  @override
  List<Widget>? buildActions(BuildContext context) {
    // AppBar’ın sağındaki ikonları oluşturur (örneğin temizleme ikonu)
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.clear))
    ];

    throw UnimplementedError();
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // AppBar’ın solundaki ikon (örneğin geri butonu)
    return IconButton(
        onPressed: () {
          close(context, null); //close the search bar
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    // Kullanıcı “search” tuşuna bastığında ne gösterileceğini tanımlar
    List<String> matchQuery = [];
    for (var item in searchTerms) {
      if (item.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(item);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(matchQuery[index]),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Kullanıcı yazarken çıkan önerileri gösterir
    List<String> matchQuery = [];
    for (var item in searchTerms) {
      if (item.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(item);
      }
    }
    return Container(
      color: AppColors.white3,
      child: ListView.builder(
        itemCount: matchQuery.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(matchQuery[index]),
          );
        },
      ),
    );
  }
}
