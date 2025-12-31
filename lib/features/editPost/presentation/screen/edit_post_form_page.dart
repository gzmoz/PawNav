import 'package:flutter/material.dart';
import 'package:pawnav/app/theme/colors.dart';
import 'package:pawnav/core/services/json_service.dart';
import 'package:pawnav/core/widgets/custom_bottomsheet_select.dart';
import 'package:pawnav/core/widgets/custom_dropdown.dart';
import 'package:pawnav/core/widgets/date_picker_select.dart';

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

  Map<String, List<String>> breedMap = {};
  Map<String, List<String>> colorMap = {};

  final TextEditingController animalNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    final screenInfo = MediaQuery.of(context);
    final double height = screenInfo.size.height;
    final double width = screenInfo.size.width;


    return Scaffold(
      backgroundColor: AppColors.white5,
      body: CustomScrollView(
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
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),


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


                      ],
                    ),
                  ),
                ],
              ),
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
    breedMap = await JsonService.load(
      'assets/data/animal_breeds.json',
    );

    colorMap = await JsonService.load(
      'assets/data/animal_colors.json',
    );

    setState(() {});
  }
}
