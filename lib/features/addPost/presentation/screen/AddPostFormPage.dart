import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pawnav/app/theme/colors.dart';
import 'package:pawnav/core/services/image_picker_service.dart';
import 'package:pawnav/core/services/json_service.dart';
import 'package:pawnav/core/services/permission_service.dart';
import 'package:pawnav/core/services/user_badge_activity_service.dart';
import 'package:pawnav/core/utils/custom_snack.dart';
import 'package:pawnav/core/utils/gender_selector.dart';
import 'package:pawnav/core/utils/image_source_enum.dart';
import 'package:pawnav/core/widgets/custom_bottomsheet_select.dart';
import 'package:pawnav/core/widgets/date_picker_select.dart';
import 'package:pawnav/core/widgets/photo_picker.dart';
import 'package:pawnav/core/widgets/photo_source_sheet.dart';
import 'package:pawnav/features/addPost/data/datasources/state_service_typeahead.dart';
import 'package:pawnav/features/addPost/domain/entities/add_post_entity.dart';
import 'package:pawnav/features/addPost/presentation/cubit/add_post_cubit.dart';
import 'package:pawnav/features/addPost/presentation/cubit/add_post_state.dart';
import 'package:pawnav/features/addPost/presentation/widget/custom_rounded_input.dart';
import 'package:pawnav/features/badges/presentation/widget/badge_unlocked_modal.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const List<String> animalTypeList = <String>["Dog", "Cat", "Bird", "Other"];

class AddPostFormPage extends StatefulWidget {
  final String type;

  const AddPostFormPage({super.key, required this.type});

  @override
  State<AddPostFormPage> createState() => _AddPostFormPageState();
}

class _AddPostFormPageState extends State<AddPostFormPage> {
  String? selectedSpecies;
  String? selectedBreed;
  String? selectedColor;
  DateTime? selectedDate;
  String selectedGender = "Male";
  String? selectedLocation;
  DateTime? eventDate;
  double? selectedLat;
  double? selectedLon;


  Map<String, List<String>> breedMap = {};
  Map<String, List<String>> colorMap = {};

  final TextEditingController animalNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  final PermissionService permissionService = PermissionService();
  final ImagePicker picker = ImagePicker();

  List<XFile> selectedImages = [];

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenInfo = MediaQuery.of(context);
    final double height = screenInfo.size.height;
    final double width = screenInfo.size.width;

    String title = "Create Post";
    if (widget.type == "Lost") title = "Report a Missing Pet";
    if (widget.type == "Found") title = "Share a Found Pet";
    if (widget.type == "Adoption") title = "Adopting a Pet";

    return Scaffold(
      backgroundColor: AppColors.white5,
      body: BlocListener<AddPostCubit, AddPostState>(
        listener: (BuildContext context, AddPostState state) async {
          if (state is AddPostLoading) {
            AppSnackbar.info(context, "Uploading Post...");
          }
          if (state is AddPostSuccess) {
            AppSnackbar.success(context, "Post successfully created");

            final supabase = Supabase.instance.client;
            final uid = supabase.auth.currentUser!.id;

            // 1) posts_count++
            await supabase.rpc('inc_post_created');

            // 2) posts_count çek
            final stats = await supabase
                .from('user_stats')
                .select('posts_count')
                .eq('user_id', uid)
                .maybeSingle();

            final postsCount = (stats?['posts_count'] as int?) ?? 0;

            // 3) hangi badge?
            String? badgeKey;
            if (postsCount == 1) badgeKey = 'first_paw';
            if (postsCount == 5) badgeKey = 'animal_advocate';

            // badge yoksa direkt home
            if (badgeKey == null) {
              if (!context.mounted) return;
              context.pushReplacement('/home');
              return;
            }

            // 4) badge datasını çek (key ile)
            final badgeRow = await supabase
                .from('badges')
                .select('name, description, icon_url')
                .eq('key', badgeKey)
                .maybeSingle();

            if (badgeRow != null && context.mounted) {
              final action = await showModalBottomSheet<String>(
                context: context,
                useRootNavigator: true,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                barrierColor: Colors.black.withOpacity(0.55),
                builder: (sheetCtx) => BadgeUnlockedModal(
                  title: badgeRow['name'] as String? ?? 'Badge Unlocked',
                  message: badgeRow['description'] as String? ?? '',
                  iconUrl: badgeRow['icon_url'] as String? ?? '',
                  onContinue: () => Navigator.of(sheetCtx).pop('continue'),
                  onViewBadges: () => Navigator.of(sheetCtx).pop('badges'), earned: true,
                ),
              );
              if (!context.mounted) return;

              if (action == 'badges') {
                context.pushReplacement('/badges'); // veya pushReplacement
                return; // çok önemli: home'a gitmesin
              }

            }

            if (!context.mounted) return;
            context.pushReplacement('/home');
          }

          /*if (state is AddPostSuccess) {
            AppSnackbar.success(context, "Post successfully created");

            Future.delayed(const Duration(milliseconds: 500), () {
              context.pushReplacement('/home');
            });
          }*/
          if (state is AddPostError) {
            AppSnackbar.error(context, state.message);
          }
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              backgroundColor: Colors.white,
              centerTitle: true,
              elevation: 10,
              title: Text(
                title,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: width * 0.05,
                ),
              ),
              /*actions: [
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Save",
                    style: TextStyle(
                        color: Colors.blueGrey, fontWeight: FontWeight.w700),
                  ),
                ),
              ],*/
            ),

            //Animal Details
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          subTitleText("Animal Name"),
                          inputArea(animalNameController),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 4, 16, 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: BottomSheetSelect(
                                    title: "Species",
                                    placeholder: "Select species",
                                    value: selectedSpecies,
                                    items: breedMap.keys.toList(),
                                    onSelected: (val) {
                                      setState(() {
                                        selectedSpecies = val;
                                        selectedBreed = null;
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: BottomSheetSelect(
                                    title: "Breed",
                                    placeholder: selectedSpecies == null
                                        ? "Select species first"
                                        : "Select breed",
                                    value: selectedBreed,
                                    items: selectedSpecies == null
                                        ? []
                                        : breedMap[selectedSpecies] ?? [],
                                    onTap: () {
                                      if (selectedSpecies == null) {
                                        AppSnackbar.info(context,
                                            "Please select species first");
                                      }
                                    },
                                    onSelected: (val) {
                                      setState(() {
                                        selectedBreed = val;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 4, 16, 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: BottomSheetSelect(
                                    title: "Color",
                                    placeholder: selectedSpecies == null
                                        ? "Select species first"
                                        : "Select color",
                                    value: selectedColor,
                                    items: selectedSpecies == null
                                        ? []
                                        : colorMap[selectedSpecies] ?? [],
                                    onTap: () {
                                      if (selectedSpecies == null) {
                                        AppSnackbar.info(context,
                                            "Please select species first");
                                      }
                                    },
                                    onSelected: (val) {
                                      setState(() {
                                        selectedColor = val;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 4, 16, 4),
                            child: DatePickerSelect(
                              title: "Lost / Found Date",
                              placeholder: "Select date",
                              value: selectedDate,
                              onSelected: (date) {
                                setState(() {
                                  selectedDate = date;
                                });
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 4, 16, 4),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                subTitleText("Last Seen Location"),
                                // inputArea(locationController),
                                TextFormField(
                                  controller: locationController,
                                  readOnly: true,
                                  onTap: () async {
                                    final result =
                                        await context.push('/select-location');

                                    if (result != null && result is Map<String, dynamic>) {
                                      setState(() {
                                        selectedLocation = result['address'];
                                        selectedLat = result['lat'];
                                        selectedLon = result['lon'];

                                        locationController.text = result['address'];
                                      });
                                    }


                                    /*if (result != null &&
                                        result is Map<String, dynamic>) {
                                      setState(() {
                                        selectedLocation = result['address'];
                                        locationController.text =
                                            result['address'];
                                      });
                                    }*/
                                  },

                                  // map'ten seçtireceksen önerilir
                                  decoration: InputDecoration(
                                    hintText: "Select on map",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),

                                    filled: true,
                                    fillColor: Colors.white,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 14,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                        color: Color(0xFFD1D5DB), // açık gri
                                        width: 1,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                        color: Color(0xFF2563EB),
                                        // focus mavi
                                        width: 1.5,
                                      ),
                                    ),

                                    // Sağdaki ikon alanının boyutunu sabitle (taşmayı önler)
                                    suffixIconConstraints: BoxConstraints(
                                      maxHeight: height * 0.05,
                                      maxWidth: width * 0.2,
                                    ),

                                    suffixIcon: Padding(
                                      padding: const EdgeInsets.all(6),
                                      // dış boşluk
                                      child: Material(
                                        color: Color(0xFF2563EB),
                                        // senin primary rengin neyse onu ver
                                        borderRadius: BorderRadius.circular(10),
                                        child: InkWell(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          onTap: () {
                                            // Map ekranına git / bottomsheet aç / konum seç
                                            context.push('/select-location');
                                          },
                                          child: const Center(
                                            child: Icon(Icons.map_outlined,
                                                color: Colors.white, size: 22),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 4, 16, 4),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                subTitleText("Gender"),
                                GenderSelector(
                                  value: selectedGender,
                                  onChanged: (val) {
                                    setState(() {
                                      selectedGender = val;
                                    });
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

            //description
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          subTitleText("Descripton"),
                          descriptionField(descriptionController),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            //photo
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          PhotoPicker(
                            images: selectedImages,
                            onAdd: () => addPhoto(context),
                            onRemove: removePhoto,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            //buttons
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await handleSubmitPost(
                          context: context,
                          selectedImages: selectedImages,
                          uploadImages: uploadImages,
                          species: selectedSpecies,
                          breed: selectedBreed,
                          color: selectedColor,
                          gender: selectedGender,
                          name: animalNameController.text,
                          description: descriptionController.text,
                          location: selectedLocation,
                          eventDate: selectedDate,
                          postType: widget.type,
                        );
                      },
                      child: Container(
                        width: width * 0.8,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF233E96), Color(0xFF3C59C7)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "Add post",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: width * 0.035,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
  }

  Future<List<String>> uploadImages(List<XFile> images) async {
    final supabase = Supabase.instance.client;
    List<String> urls = [];

    for (final img in images) {
      try {
        final fileExt = img.path.split('.').last; //dosya uzantısını al
        final fileName = '${DateTime.now().millisecondsSinceEpoch}.$fileExt';
        final filePath = 'posts/$fileName';

        final response = await supabase.storage
            .from('post_images')
            .upload(filePath, File(img.path));

        print("UPLOAD RESPONSE: $response");

        final url = supabase.storage.from('post_images').getPublicUrl(filePath);

        urls.add(url);
      } catch (e) {
        print("UPLOAD ERROR → $e");
        rethrow;
      }
    }

    return urls;
  }

  Widget titleText(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 8, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    );
  }

  Widget subTitleText(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 8, 16, 4),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 17,
        ),
      ),
    );
  }

  Widget inputArea(TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 8, 16, 4),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: "Buddy (or leave empty)",
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Color(0xFFD1D5DB), // açık gri
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Color(0xFF2563EB), // focus mavi
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> loadData() async {
    try {
      breedMap = await JsonService.load('assets/data/animal_breeds.json');
      colorMap = await JsonService.load('assets/data/animal_colors.json');

      debugPrint("breedMap loaded: ${breedMap.length}");
      setState(() {});
    } catch (e, st) {
      debugPrint("JSON LOAD ERROR: $e");
      debugPrint("$st");
    }
  }

  Future<void> addPhoto(BuildContext context) async {
    final source = await PhotoSourceSheet.show(context);
    if (source == null) return;

    bool granted = false;

    if (source == ImageSourceType.gallery) {
      granted = await permissionService.requestGalleryPermission();
    } else {
      granted = await permissionService.requestCameraPermission();
    }

    if (!granted) return;

    /// GALERİ → ÇOKLU SEÇİM
    if (source == ImageSourceType.gallery) {
      final List<XFile> images = await picker.pickMultiImage(
        imageQuality: 80,
      );

      if (images.isEmpty) return;
      //Kullanıcı galeri açtı
      // Ama “Done” deyip hiçbir şey seçmedi

      final remainingSlots = 5 - selectedImages.length;

      if (remainingSlots <= 0) {
        AppSnackbar.error(context, "You can upload maximum 5 photos");
        return;
      }

      setState(() {
        selectedImages.addAll(images.take(remainingSlots));
        //images listesinden sadece remainingSlots kadarını al
      });

      if (images.length > remainingSlots) {
        AppSnackbar.info(
          context,
          "You selected ${images.length} photos. Only $remainingSlots can be added (max 5).",
        );
      }
    }

    /// KAMERA → TEK FOTO
    else {
      final XFile? image = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (image != null && selectedImages.length < 5) {
        setState(() {
          selectedImages.add(image);
        });
      } else if (selectedImages.length >= 5) {
        AppSnackbar.error(context, "You can upload max 5 photos");
      }
    }
  }

  Future<void> handleSubmitPost({
    required BuildContext context,
    required List<XFile> selectedImages,
    required Future<List<String>> Function(List<XFile>) uploadImages,
    required String? species,
    required String? breed,
    required String? color,
    required String gender,
    required String name,
    required String description,
    required String? location,
    required DateTime? eventDate,
    required String postType,
  }) async {
    final normalizedName = name.trim().isEmpty ? "Unknown" : name.trim();

    // Species / breed / color
    if (species == null || breed == null || color == null) {
      AppSnackbar.error(context, "Please select species, breed and color.");
      return;
    }

    // Location
    if (location == null || location.trim().isEmpty) {
      AppSnackbar.error(context, "Please select location.");
      return;
    }

// Date
    if (eventDate == null) {
      AppSnackbar.error(context, "Please select date.");
      return;
    }

    // Upload images
    final uploadedUrls = await uploadImages(selectedImages);

    //  User id
    final userId = Supabase.instance.client.auth.currentUser!.id;

    // Post entity
    final post = Post(
      id: "",
      userId: userId,
      species: species,
      breed: breed,
      color: color,
      gender: gender,
      name: normalizedName,
      description: description,
      location: location,
      lat: selectedLat,
      lon: selectedLon,
      eventDate: eventDate,
      images: uploadedUrls,
      postType: postType,
    );

    // 4️⃣ Submit
    context.read<AddPostCubit>().submitPost(post);
  }

  void removePhoto(int index) {
    setState(() {
      selectedImages.removeAt(index);
    });
  }

  Widget descriptionField(TextEditingController controller) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: controller,
            maxLines: 6,
            maxLength: 500,
            decoration: InputDecoration(
              hintText: "Describe the situation...",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFFD1D5DB),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFFD1D5DB),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFF2563EB),
                  width: 1.5,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 14,
              ),
              counterText: "", // default counter kapatıyoruz
            ),
          ),

          // Custom counter
          Align(
            alignment: Alignment.centerRight,
            child: ValueListenableBuilder<TextEditingValue>(
              valueListenable: controller,
              builder: (_, value, __) {
                return Text(
                  "${value.text.length}/500",
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
