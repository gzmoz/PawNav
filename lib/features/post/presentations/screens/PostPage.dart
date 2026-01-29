import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pawnav/app/theme/colors.dart';
import 'package:pawnav/core/services/animal_breeds_loader.dart';
import 'package:pawnav/core/utils/time_ago.dart';
import 'package:pawnav/features/addPost/presentation/screen/select_location_screen.dart';
import 'package:pawnav/features/post/domain/entities/post_filter.dart';
import 'package:pawnav/features/post/presentations/cubit/post_list_cubit.dart';
import 'package:pawnav/features/post/presentations/cubit/post_list_state.dart';
import 'package:pawnav/features/post/presentations/widgets/post_card.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  bool _newestFirst = true;
  PostFilter _currentFilter = PostFilter.empty;
  double? _selectedLat;
  double? _selectedLon;

  static const List<String> animalTypes = [
    "Any",
    "Dog",
    "Cat",
    "Bird",
    "Rabbit",
    "Rodent",
    "Reptile",
    "Other",
  ];

  @override
  void initState() {
    super.initState();

    context.read<PostListCubit>().load(
      newestFirst: _newestFirst,
      filter: _currentFilter,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenInfo = MediaQuery.of(context);
    final double height = screenInfo.size.height;
    final double width = screenInfo.size.width;

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
              bottom: MediaQuery.of(context).padding.bottom + 50),
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
                            color: AppColors.primary.withOpacity(0.02),
                            blurRadius: 10,
                            offset: Offset(1, 1),
                          ),
                        ],
                      ),
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          //  DEĞİŞTİ: sonucu bekliyoruz
                          final result = await showModalBottomSheet<String>(
                            context: context,
                            backgroundColor: AppColors.white5,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                              ),
                            ),
                            builder: (BuildContext context) {
                              String selectedOption =
                              _newestFirst ? "Newest" : "Oldest";

                              return Padding(
                                padding: EdgeInsets.only(
                                  bottom:
                                  MediaQuery.of(context).viewInsets.bottom +
                                      50,
                                  top: 10,
                                ),
                                child: StatefulBuilder(
                                  builder: (context, setState) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 16),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
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
                                                "Sort by Date",
                                                style: TextStyle(
                                                  fontSize: width * 0.05,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: () => context.pop(),
                                                icon: const Icon(Icons.close),
                                              ),
                                            ],
                                          ),

                                          const SizedBox(height: 10),

                                          // Newest
                                          RadioListTile<String>(
                                            title:
                                            const Text("Newest to Oldest"),
                                            value: "Newest",
                                            activeColor: Colors.blueAccent,
                                            groupValue: selectedOption,
                                            onChanged: (value) {
                                              setState(() =>
                                              selectedOption = value!);
                                            },
                                          ),

                                          // Oldest
                                          RadioListTile<String>(
                                            title:
                                            const Text("Oldest to Newest"),
                                            value: "Oldest",
                                            groupValue: selectedOption,
                                            activeColor: Colors.blueAccent,
                                            onChanged: (value) {
                                              setState(() =>
                                              selectedOption = value!);
                                            },
                                          ),

                                          const SizedBox(height: 12),

                                          Center(
                                            child: ElevatedButton(
                                              // DEĞİŞTİ: sadece seçimi geri gönderiyoruz
                                              onPressed: () {
                                                context.pop(selectedOption);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                AppColors.primary,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                  BorderRadius.circular(30),
                                                ),
                                                minimumSize: Size(
                                                    width * 0.4, height * 0.05),
                                              ),
                                              child: const Text(
                                                "Apply",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          );

                          //  bottom sheet kapandıktan sonra Cubit çağrılıyor
                          if (result != null) {
                            final newest = result == "Newest";

                            // UI state güncelleniyor
                            setState(() {
                              _newestFirst = newest;
                            });

                            //  Cubit çağrılıyor
                            context.read<PostListCubit>().load(
                              newestFirst: newest,
                              filter: _currentFilter,
                            );
                          }
                        },
                        icon: const Icon(Icons.swap_vert, size: 18),
                        label: const Text("Sort"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black54,
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
                            // color: Colors.black.withOpacity(0.01),
                            color: AppColors.primary.withOpacity(0.02),
                            blurRadius: 10,
                            offset: Offset(1, 1),
                          ),
                        ],
                      ),
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final result =
                          await showModalBottomSheet<Map<String, dynamic>>(
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
                              String selectedPostType =
                                  _currentFilter.postType ?? "Lost";

                              double radiusValue =
                                  _currentFilter.radiusKm ?? 10;

                              String selectedAnimal =
                                  _currentFilter.animal ?? "Any";

                              String selectedBreed =
                                  _currentFilter.breed ?? "Any";

                              double? selectedLat = _currentFilter.lat;
                              double? selectedLon = _currentFilter.lon;

                              final TextEditingController locationController =
                              TextEditingController(
                                text: _currentFilter.location ?? '',
                              );

                              return Padding(
                                padding: EdgeInsets.only(
                                  bottom:
                                  MediaQuery.of(context).viewInsets.bottom +
                                      50,
                                  top: 10,
                                ),
                                child: StatefulBuilder(
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
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Text(
                                                  "Filters",
                                                  style: TextStyle(
                                                    fontSize: width * 0.05,
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.black54,
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
                                                children: [
                                                  "Lost",
                                                  "Found",
                                                  "Adoption"
                                                ].map((type) {
                                                  final isSelected =
                                                      selectedPostType == type;

                                                  return GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        selectedPostType = type;
                                                      });
                                                    },
                                                    child: AnimatedContainer(
                                                      duration: const Duration(
                                                          milliseconds: 200),
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 22,
                                                          vertical: 10),
                                                      decoration: BoxDecoration(
                                                        color: isSelected
                                                            ? Colors.blueAccent
                                                            : const Color(
                                                            0xFFF3F4F6),
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(30),
                                                        boxShadow: isSelected
                                                            ? [
                                                          BoxShadow(
                                                            color: Colors
                                                                .blue
                                                                .withOpacity(
                                                                0.25),
                                                            blurRadius: 6,
                                                            offset:
                                                            const Offset(
                                                                0, 2),
                                                          )
                                                        ]
                                                            : [],
                                                      ),
                                                      child: Text(
                                                        type,
                                                        style: TextStyle(
                                                          color: isSelected
                                                              ? Colors.white
                                                              : Colors.black87,
                                                          fontWeight:
                                                          FontWeight.w600,
                                                          fontSize: 15,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }).toList(),
                                              ),
                                            ),

                                            const SizedBox(height: 20),

                                            Text(
                                              "Location Filter",
                                              style: TextStyle(
                                                fontSize: width * 0.042,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),

                                            const SizedBox(height: 8),

                                            // TextField(
                                            //   controller: locationController,
                                            //   decoration: InputDecoration(
                                            //     hintText:
                                            //         "Enter city or postcode",
                                            //     prefixIcon:
                                            //         const Icon(Icons.search),
                                            //     contentPadding:
                                            //         const EdgeInsets.symmetric(
                                            //             vertical: 12,
                                            //             horizontal: 23),
                                            //     filled: true,
                                            //     fillColor: Colors.grey.shade100,
                                            //     border: OutlineInputBorder(
                                            //       borderRadius:
                                            //           BorderRadius.circular(12),
                                            //       borderSide: BorderSide.none,
                                            //     ),
                                            //   ),
                                            // ),
                                            GestureDetector(
                                              onTap: () async {
                                                final result =
                                                await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) =>
                                                    const SelectLocationScreen(),
                                                  ),
                                                );

                                                if (result != null) {
                                                  setState(() {
                                                    locationController.text = result["address"];
                                                    selectedLat = result["lat"];
                                                    selectedLon = result["lon"];
                                                  });
                                                }


                                                /*if (result != null) {
                                                  setState(() {
                                                    locationController.text =
                                                    result["address"];
                                                    _selectedLat =
                                                    result["lat"];
                                                    _selectedLon =
                                                    result["lon"];
                                                  });
                                                }*/
                                              },
                                              child: AbsorbPointer(
                                                child: TextField(
                                                  controller:
                                                  locationController,
                                                  decoration: InputDecoration(
                                                    hintText:
                                                    "Select area from map",
                                                    prefixIcon: const Icon(
                                                        Icons.location_on,
                                                        color: Colors.grey),
                                                    contentPadding:
                                                    const EdgeInsets
                                                        .symmetric(
                                                      vertical: 12,
                                                      horizontal: 23,
                                                    ),
                                                    filled: true,
                                                    fillColor:
                                                    Colors.grey.shade100,
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          12),
                                                      borderSide:
                                                      BorderSide.none,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),

                                            const SizedBox(height: 20),

                                            RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: 'Radius: ',
                                                    style: TextStyle(
                                                      fontSize: width * 0.042,
                                                      fontWeight:
                                                      FontWeight.w600,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text:
                                                    '${radiusValue.toStringAsFixed(0)} km',
                                                    style: TextStyle(
                                                        fontSize: width * 0.042,
                                                        fontWeight:
                                                        FontWeight.w600,
                                                        color:
                                                        Colors.blueAccent),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Slider(
                                              value: radiusValue,
                                              min: 1,
                                              max: 100,
                                              activeColor: Colors.blueAccent,
                                              onChanged:selectedLat == null
                                                  ? null
                                                  : (val) {
                                                setState(() =>
                                                radiusValue = val);
                                              },
                                            ),

                                            /*Slider(
                                              value: radiusValue,
                                              min: 1,
                                              max: 100,
                                              activeColor: Colors.blueAccent,
                                              onChanged: (val) {
                                                setState(() {
                                                  radiusValue = val;
                                                });
                                              },
                                            ),*/

                                            const SizedBox(height: 10),

                                            Text(
                                              "Animal Details",
                                              style: TextStyle(
                                                fontSize: width * 0.042,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),

                                            const SizedBox(height: 8),

                                            //animal type
                                            Container(
                                              padding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 14,
                                                  vertical: 14),
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color:
                                                      Colors.grey.shade300),
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      12)),
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      const Icon(Icons.pets,
                                                          color: Colors.grey),
                                                      const SizedBox(width: 12),
                                                      Text(
                                                        "Animal Type",
                                                        style: TextStyle(
                                                            fontSize:
                                                            width * 0.035),
                                                      ),
                                                    ],
                                                  ),
                                                  GestureDetector(
                                                    onTap: () async {
                                                      final selected =
                                                      await showModalBottomSheet<
                                                          String>(
                                                        context: context,
                                                        backgroundColor:
                                                        Colors.white,
                                                        shape:
                                                        const RoundedRectangleBorder(
                                                          borderRadius:
                                                          BorderRadius.vertical(
                                                              top: Radius
                                                                  .circular(
                                                                  24)),
                                                        ),
                                                        builder: (_) {
                                                          return Padding(
                                                            padding:
                                                            const EdgeInsets
                                                                .fromLTRB(
                                                                16,
                                                                12,
                                                                16,
                                                                24),
                                                            child: Column(
                                                              mainAxisSize:
                                                              MainAxisSize
                                                                  .min,
                                                              children: [
                                                                // drag indicator
                                                                Container(
                                                                  width: 40,
                                                                  height: 4,
                                                                  margin:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      bottom:
                                                                      16),
                                                                  decoration:
                                                                  BoxDecoration(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade300,
                                                                    borderRadius:
                                                                    BorderRadius.circular(
                                                                        10),
                                                                  ),
                                                                ),

                                                                const Text(
                                                                  "Select Animal Type",
                                                                  style:
                                                                  TextStyle(
                                                                    fontSize:
                                                                    18,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                  ),
                                                                ),

                                                                const SizedBox(
                                                                    height: 16),

                                                                Expanded(
                                                                  child:
                                                                  ListView(
                                                                    children:
                                                                    animalTypes
                                                                        .map((animal) {
                                                                      return _AnimalTile(
                                                                        label:
                                                                        animal,
                                                                        isSelected:
                                                                        selectedAnimal ==
                                                                            animal,
                                                                        onTap: () => Navigator.pop(
                                                                            context,
                                                                            animal),
                                                                      );
                                                                    }).toList(),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                      );

                                                      if (selected != null) {
                                                        setState(() {
                                                          selectedAnimal =
                                                              selected;
                                                          selectedBreed =
                                                          "Any";
                                                        });
                                                      }
                                                    },
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          selectedAnimal,
                                                          style:
                                                          const TextStyle(
                                                            fontWeight:
                                                            FontWeight.w500,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            width: 5),
                                                        const Icon(
                                                            Icons.chevron_right,
                                                            color: Colors.grey),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            const SizedBox(height: 8),

                                            //BREED
                                            Container(
                                              padding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 14,
                                                  vertical: 14),
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color:
                                                      Colors.grey.shade300),
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      12)),
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      const Icon(Icons.science,
                                                          color: Colors.grey),
                                                      const SizedBox(width: 12),
                                                      Text(
                                                        "Breed",
                                                        style: TextStyle(
                                                            fontSize:
                                                            width * 0.035),
                                                      ),
                                                    ],
                                                  ),
                                                  GestureDetector(
                                                    onTap: () async {
                                                      final breedsMap =
                                                      await AnimalBreedsLoader
                                                          .load();
                                                      final breeds = breedsMap[
                                                      selectedAnimal] ??
                                                          [];

                                                      final selected =
                                                      await showModalBottomSheet<
                                                          String>(
                                                        context: context,
                                                        backgroundColor:
                                                        Colors.white,
                                                        shape:
                                                        const RoundedRectangleBorder(
                                                          borderRadius:
                                                          BorderRadius.vertical(
                                                              top: Radius
                                                                  .circular(
                                                                  24)),
                                                        ),
                                                        builder: (_) {
                                                          return Padding(
                                                            padding:
                                                            const EdgeInsets
                                                                .fromLTRB(
                                                                16,
                                                                12,
                                                                16,
                                                                24),
                                                            child: Column(
                                                              mainAxisSize:
                                                              MainAxisSize
                                                                  .min,
                                                              children: [
                                                                // drag indicator
                                                                Container(
                                                                  width: 40,
                                                                  height: 4,
                                                                  margin:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      bottom:
                                                                      16),
                                                                  decoration:
                                                                  BoxDecoration(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade300,
                                                                    borderRadius:
                                                                    BorderRadius.circular(
                                                                        10),
                                                                  ),
                                                                ),

                                                                const Text(
                                                                  "Select Breed",
                                                                  style:
                                                                  TextStyle(
                                                                    fontSize:
                                                                    18,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                  ),
                                                                ),

                                                                const SizedBox(
                                                                    height: 16),

                                                                Expanded(
                                                                  child:
                                                                  ListView(
                                                                    children: [
                                                                      _BreedTile(
                                                                        label:
                                                                        "Any",
                                                                        isSelected:
                                                                        selectedBreed ==
                                                                            "Any",
                                                                        onTap: () => Navigator.pop(
                                                                            context,
                                                                            "Any"),
                                                                      ),
                                                                      ...breeds.map(
                                                                              (breed) {
                                                                            return _BreedTile(
                                                                              label:
                                                                              breed,
                                                                              isSelected:
                                                                              selectedBreed == breed,
                                                                              onTap: () => Navigator.pop(
                                                                                  context,
                                                                                  breed),
                                                                            );
                                                                          }),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                      );

                                                      if (selected != null) {
                                                        setState(() {
                                                          selectedBreed =
                                                              selected;
                                                        });
                                                      }
                                                    },
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          selectedBreed,
                                                          style:
                                                          const TextStyle(
                                                            fontWeight:
                                                            FontWeight.w500,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            width: 5),
                                                        const Icon(
                                                            Icons.chevron_right,
                                                            color: Colors.grey),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            const SizedBox(height: 25),

                                            Divider(
                                                color: Colors.grey.shade300,
                                                height: 1),
                                            const SizedBox(height: 10),

                                            //bottom buttons
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                              children: [
                                                OutlinedButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      selectedPostType = "Lost";
                                                      selectedAnimal = "Any";
                                                      selectedBreed = "Any";
                                                      locationController
                                                          .clear();
                                                      radiusValue = 10;
                                                    });
                                                  },
                                                  style:
                                                  OutlinedButton.styleFrom(
                                                    shape:
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          30),
                                                    ),
                                                    side: const BorderSide(
                                                        color:
                                                        AppColors.primary),
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 24,
                                                        vertical: 12),
                                                  ),
                                                  child: const Text(
                                                    "Reset Filters",
                                                    style: TextStyle(
                                                        color:
                                                        AppColors.primary),
                                                  ),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    context.pop({
                                                      "postType":
                                                      selectedPostType,
                                                      "location":
                                                      locationController
                                                          .text,
                                                      "radius": radiusValue,
                                                      "animal": selectedAnimal,
                                                      "breed": selectedBreed,
                                                      "lat": selectedLat,
                                                      "lon": selectedLon,
                                                    });
                                                  },
                                                  style:
                                                  ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                    AppColors.primary,
                                                    shape:
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          30),
                                                    ),
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 24,
                                                        vertical: 12),
                                                  ),
                                                  child: const Text(
                                                    "Apply Filters",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          );

                          if (result != null) {
                            final filter = PostFilter(
                              postType: result["postType"],
                              location: result["location"]?.isEmpty == true
                                  ? null
                                  : result["location"],
                              radiusKm: result["radius"],
                              animal: result["animal"] == "Any"
                                  ? null
                                  : result["animal"],
                              breed: result["breed"] == "Any"
                                  ? null
                                  : result["breed"],
                              lat: result["lat"],
                              lon: result["lon"],
                            );

                            /*final filter = PostFilter(
                              postType: result["postType"]?.isEmpty == true
                                  ? null
                                  : result["postType"],
                              location: result["location"]?.isEmpty == true
                                  ? null
                                  : result["location"],
                              radiusKm: result["radius"],
                              animal: result["animal"]?.isEmpty == true
                                  ? null
                                  : result["animal"],
                              breed: result["breed"] == "Any"
                                  ? null
                                  : result["breed"],
                              lat: result["lat"],
                              lon: result["lon"],
                            );*/

                            setState(() {
                              _currentFilter = filter;
                            });

                            context.read<PostListCubit>().load(
                              newestFirst: _newestFirst,
                              filter: filter,
                            );
                          }
                        },
                        icon: const Icon(Icons.filter_list, size: 18),
                        label: const Text("Filters"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black54,
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
                padding: EdgeInsets.symmetric(horizontal: width * 0.07),
                child: RefreshIndicator(
                  onRefresh: () async {
                    context.read<PostListCubit>().load(
                      newestFirst: _newestFirst,
                      filter: _currentFilter,
                    );
                  },
                  child: BlocBuilder<PostListCubit, PostListState>(
                    builder: (context, state) {
                      if (state is PostListLoading) {
                        return const Padding(
                          padding: EdgeInsets.only(top: 40),
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (state is PostListError) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 40),
                          child: Text(
                            state.message,
                            style: const TextStyle(color: Colors.red),
                          ),
                        );
                      }

                      if (state is PostListLoaded) {
                        final posts = state.posts;

                        if (posts.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.only(top: 40),
                            child: Text("No posts found"),
                          );
                        }

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: posts.length,

                          itemBuilder: (context, index) {
                            final post = posts[index];

                            return PostCardComponent(
                              imageUrl: post.images.isNotEmpty
                                  ? post.images.first
                                  : '',
                              name: post.name ?? 'Unknown',
                              location: post.location,

                              description: post.description,
                              status: post.postType ?? 'Lost',
                              timeAgoText: timeAgo(post.eventDate),
                              onTap: () {
                                context.push('/post-detail/${post.id}');
                              },
                            );
                          },
                        );
                      }

                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: height * 0.1),
        child: FloatingActionButton(
          onPressed: () {
            context.push('/map');
          },
          backgroundColor: Colors.transparent,
          // ÖNEMLİ
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          child: Container(
            width: 56, // FAB standard size
            height: 56,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF233E96),
                  Color(0xFF3C59C7),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Icon(
              Icons.map_outlined,
              color: Colors.white,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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

class _BreedTile extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _BreedTile({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Material(
        color: isSelected ? Colors.blueAccent.withOpacity(0.12) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        child: ListTile(
          title: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.blueAccent : Colors.black87,
            ),
          ),
          trailing: isSelected
              ? const Icon(Icons.check, color: Colors.blueAccent)
              : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}

class _AnimalTile extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _AnimalTile({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Material(
        color: isSelected ? Colors.blueAccent.withOpacity(0.12) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        child: ListTile(
          title: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.blueAccent : Colors.black87,
            ),
          ),
          trailing: isSelected
              ? const Icon(Icons.check, color: Colors.blueAccent)
              : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}