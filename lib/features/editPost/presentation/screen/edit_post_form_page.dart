import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pawnav/app/theme/colors.dart';
import 'package:pawnav/core/services/json_service.dart';
import 'package:pawnav/core/services/permission_service.dart';
import 'package:pawnav/core/utils/custom_snack.dart';
import 'package:pawnav/core/utils/gender_selector.dart';
import 'package:pawnav/core/utils/image_source_enum.dart';
import 'package:pawnav/core/widgets/custom_bottomsheet_select.dart';
import 'package:pawnav/core/widgets/custom_dropdown.dart';
import 'package:pawnav/core/widgets/date_picker_select.dart';
import 'package:pawnav/core/widgets/photo_picker.dart';
import 'package:pawnav/core/widgets/photo_source_sheet.dart';
import 'package:pawnav/features/editPost/presentation/cubit/edit_post_cubit.dart';
import 'package:pawnav/features/editPost/presentation/cubit/edit_post_state.dart';
import 'package:pawnav/features/post/presentations/cubit/post_detail_cubit.dart';
import 'package:pawnav/features/post/presentations/widgets/location_card.dart';

class EditPostFormPage extends StatefulWidget {
  final String postId;

  const EditPostFormPage({super.key, required this.postId});

  @override
  State<EditPostFormPage> createState() => _EditPostFormPageState();
}

class _EditPostFormPageState extends State<EditPostFormPage> {
  String? selectedSpecies;
  String? selectedBreed;
  String? selectedColor;
  DateTime? selectedDate;
  String selectedGender = "Male";


  Map<String, List<String>> breedMap = {};
  Map<String, List<String>> colorMap = {};

  final TextEditingController animalNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final PermissionService permissionService = PermissionService();
  final ImagePicker picker = ImagePicker();

  List<XFile> selectedImages = [];


  @override
  void initState() {
    super.initState();
    loadData();
    context.read<EditPostCubit>().load(widget.postId);

  }

  @override
  Widget build(BuildContext context) {
    final screenInfo = MediaQuery.of(context);
    final double height = screenInfo.size.height;
    final double width = screenInfo.size.width;


    return Scaffold(
      backgroundColor: AppColors.white5,
      body: BlocBuilder<EditPostCubit,EditPostState>(
        buildWhen: (prev, curr) => curr is EditPostLoaded,

        builder: (BuildContext context, EditPostState state) {

          /*if (state is EditPostLoading) {
            return const Center(child: CircularProgressIndicator());
          }*/

          if (state is EditPostError) {
            return Center(child: Text(state.message));
          }

          if (state is! EditPostLoaded) {
            return const SizedBox.shrink();
          }

          final post = state.post;
        return  CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              backgroundColor: Colors.white,
              centerTitle: true,
              elevation: 10,
              title: Text(
                "Edit Post",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: width * 0.05,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Save",
                    style: TextStyle(
                        color: Colors.blueGrey, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),

            //InfoBox
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF), // açık mavi
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFFD6E8FF),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Sol ikon
                      Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          color: Color(0xFF2563EB), // mavi
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.info_outline,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),

                      const SizedBox(width: 12),

                      // Sağ metinler
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Editing Existing Post",
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "You are making changes to a published post visible to the community.",
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF475569),
                                height: 1.4,
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
                                    placeholder: "Select breed",
                                    value: selectedBreed,
                                    items: selectedSpecies == null
                                        ? []
                                        : breedMap[selectedSpecies] ?? [],
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
                                    placeholder: "Select color",
                                    value: selectedColor,
                                    items: selectedSpecies == null
                                        ? []
                                        : colorMap[selectedSpecies] ?? [],
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


            //location
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
                          //LOCATION CARD
                          /// LOCATION
                          LocationCard(
                            title: "Last Seen Location",
                            address: post.location,
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
                          SizedBox(
                            width: double.infinity,
                            height: 54,
                            child: ElevatedButton.icon(
                              onPressed: () {},
                              label: const Text("Save Changes"),
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

                          /// cancel + DELETE
                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 52,
                                  child: OutlinedButton.icon(
                                    onPressed: ()  {
                                      Navigator.pop(context);

                                    },
                                    icon: const Icon(Icons.cancel_outlined),
                                    label: const Text("Cancel"),
                                  ),

                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: SizedBox(
                                  height: 52,
                                  child: OutlinedButton.icon(

                                    onPressed: () => showDeleteDialog(context),
                                    // onPressed: () {},

                                    icon: const Icon(Icons.delete_outline),
                                    label: const Text("Delete Post"),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.red,
                                      side: BorderSide(color: Colors.red.shade200),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
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
                  ],
                ),
              ),
            ),



          ],
        );
      },

      ),
    );
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
          hintText: "Buddy",
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


  void showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            "Delete post?",
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          content: const Text(
            "Are you sure you want to permanently delete this post? "
                "This action cannot be undone.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.pop(context); // dialog kapat
                deletePost(context);
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  void deletePost(BuildContext context) async {
    final cubit = context.read<PostDetailCubit>();

    try {
      await cubit.deletePost(widget.postId); // postId içeride tutuluyor varsayımı

      // SUCCESS SNACK
      AppSnackbar.success(
        context,
        "Post deleted successfully",
      );

      // AccountPage’e sinyal gönder
      Navigator.pop(context, true);
    } catch (e) {
      AppSnackbar.error(
        context,
        "Failed to delete post. Please try again.",
      );
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

    final image = await picker.pickImage(
      source: source == ImageSourceType.gallery
          ? ImageSource.gallery
          : ImageSource.camera,
      imageQuality: 80,
    );

    if (image != null && selectedImages.length < 5) {
      setState(() {
        selectedImages.add(image);
      });
    }
  }

  void removePhoto(int index) {
    setState(() {
      selectedImages.removeAt(index);
    });
  }


}
