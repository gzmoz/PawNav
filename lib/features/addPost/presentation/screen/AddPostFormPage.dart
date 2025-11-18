import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pawnav/app/theme/colors.dart';
import 'package:pawnav/features/addPost/data/datasources/state_service_typeahead.dart';
import 'package:pawnav/features/addPost/presentation/widget/custom_rounded_input.dart';

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
  String? selectedLocation;
  String? gender = "Male";
  DateTime? eventDate;
  List<String> breedList = [];
  List<XFile> selectedImages = [];

  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController descCtrl = TextEditingController();
  final TextEditingController locationCtrl = TextEditingController();

  final Map<String, List<String>> breedMap = {
    "Dog": [
      "Golden Retriever",
      "German Shepherd",
      "Labrador",
      "Husky",
      "Pug",
      "Mixed"
    ],
    "Cat": ["Siamese", "Persian", "British Shorthair", "Maine Coon", "Mixed"],
    "Bird": ["Parrot", "Canary", "Finch", "Cockatiel", "Other"],
    "Other": ["Unknown"],
  };

  final List<String> colorList = [
    "Black",
    "White",
    "Brown",
    "Gray",
    "Golden",
    "Mixed",
  ];

  final List<Map<String, dynamic>> genderOptions = [
    {
      "label": "Male",
      "icon": Icons.male,
    },
    {
      "label": "Female",
      "icon": Icons.female,
    },
    {
      "label": "Unknown",
      "icon": Icons.help_outline,
    },
  ];

  //create an instance form the ImagePicker class
  //allows to choose images from the gallery or camera
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // breedList = breedMap[selectedSpecies]!;
    breedList = [];
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
      backgroundColor: AppColors.white4,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).padding.bottom + 50,
              top: width * 0.055,
              right: width * 0.055,
              left: width * 0.055),

          //padding: EdgeInsets.all(width * 0.055),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //subtitle
              Align(
                alignment: Alignment.topCenter,
                child: Text(
                  "Share details to help an animal in need",
                  style: TextStyle(
                      fontSize: width * 0.037, color: Colors.grey[600]),
                ),
              ),
              const SizedBox(height: 18),

              //section title
              _sectionTitle("Animal's Details", width),

              const SizedBox(height: 10),

              //Animal name
              CustomRoundedInput(
                leftIcon: Icons.pets,
                child: TextField(
                  controller: nameCtrl,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Animal's Name (if known)",
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              CustomRoundedInput(
                leftIcon: Icons.category_rounded,
                child: GestureDetector(
                  onTap: () => _openSpeciesSelector(context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        selectedSpecies ?? "Species",
                        style: TextStyle(
                          fontSize: 16,
                          color: selectedSpecies == null
                              ? Colors.grey[400]
                              : Colors.black87,
                        ),
                      ),
                      Icon(Icons.keyboard_arrow_down_rounded,
                          color: Colors.grey[500]),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 10),

              //BREED AND COLOR
              Row(
                children: [
                  // Breed
                  Expanded(
                    child: CustomRoundedInput(
                      leftIcon: Icons.account_tree,
                      child: GestureDetector(
                        onTap: () => _openBreedSelector(context),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                selectedBreed ?? "Breed",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: selectedBreed == null
                                      ? Colors.grey[500]
                                      : Colors.black87,
                                ),
                              ),
                            ),
                            Icon(Icons.keyboard_arrow_down_rounded,
                                color: Colors.grey[500]),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  // Color
                  Expanded(
                    child: CustomRoundedInput(
                      leftIcon: Icons.color_lens,
                      child: GestureDetector(
                        onTap: () => _openColorSelector(context),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              selectedColor ?? "Color",
                              style: TextStyle(
                                fontSize: 16,
                                color: selectedColor == null
                                    ? Colors.grey[500]
                                    : Colors.black87,
                              ),
                            ),
                            Icon(Icons.keyboard_arrow_down_rounded,
                                color: Colors.grey[500]),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 13),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: genderOptions.map((item) {
                    final bool isSelected = gender == item["label"];

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          gender = item["label"];
                        });
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        margin: EdgeInsets.symmetric(horizontal: 6),
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                        decoration: BoxDecoration(
                          color:
                              isSelected ? Colors.blue.shade50 : Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color:
                                isSelected ? Colors.blue : Colors.grey.shade300,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              item["icon"],
                              size: width * 0.055,
                              color: isSelected
                                  ? Colors.blueAccent
                                  : Colors.black87,
                            ),
                            SizedBox(width: 6),
                            Text(
                              item["label"],
                              style: TextStyle(
                                fontSize: width * 0.03,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                                color: isSelected
                                    ? Colors.blueAccent
                                    : Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 15),

              //event's details
              _sectionTitle("Event's Details", width),

              const SizedBox(height: 10),

              CustomRoundedInput(
                leftIcon: Icons.calendar_month_rounded,
                child: GestureDetector(
                  onTap: () {
                    _pickEventDate(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        eventDate == null
                            ? "Lost/Found Date"
                            : "${eventDate!.day}/${eventDate!.month}/${eventDate!.year}",
                        style: TextStyle(
                          fontSize: 16,
                          color: eventDate == null
                              ? Colors.grey[400]
                              : Colors.black87,
                        ),
                      ),
                      Icon(Icons.keyboard_arrow_down_rounded,
                          color: Colors.grey[500]),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 10),

              CustomRoundedInput(
                leftIcon: Icons.location_on_outlined,
                rightWidget: GestureDetector(
                  onTap: () {
                    //context.push("/map"); //MAP ICON DIRECTION
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.map, color: Colors.blue, size: 18),
                        SizedBox(width: 6),
                        Text(
                          "Map",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                child: TypeAheadField<String>(
                  hideWithKeyboard: false,
                  //Klavye açılınca öneri kutusu kaybolmasın.
                  direction: VerticalDirection.down,
                  //Öneriler input'un altına doğru açılsın.
                  autoFlipDirection: true,
                  //Eğer ekranın altına sığmazsa üst tarafa açılabilir.
                  // autoFlipMinHeight: 120,

                  // Kullanıcı input'a yazdıkça çalışan fonksiyon
                  suggestionsCallback: (pattern) async {
                    //Kullanıcı input'a her yazdığında burası çalışır.
                    // pattern = kullanıcının yazdığı metin ("ank", "ist", vb.)
                    //LocationService().search() → API’ye isteği atan fonksiyon
                    return await LocationService().search(pattern);
                  },
                  builder: (context, controller, focusNode) {
                    //Input kutusunun nasıl görüneceği
                    // Daha önce seçtiğin bir lokasyon varsa input içine yazılır
                    controller.text = selectedLocation ?? "";

                    return TextField(
                      controller: controller, // TypeAhead'in kendi controller'ı
                      focusNode: focusNode,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Last Seen Location",
                        hintStyle: TextStyle(color: Colors.grey[400]),
                      ),
                    );
                  },
                  // Öneri listesindeki her satırın nasıl görüneceği
                  itemBuilder: (context, suggestion) {
                    final parts = suggestion.split(", ");
                    final main = parts.first; // "Ankara"
                    final sub = parts.length > 1
                        ? parts.sublist(1).join(", ")
                        : ""; // "Çankaya, Turkey"

                    return Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 14),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /*Icon(Icons.location_on_outlined,
                          color: Colors.redAccent, size: 22),*/
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  main,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                // Alt bilgi (ilçe + ülke)
                                if (sub.isNotEmpty)
                                  Text(
                                    sub,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                  // Kullanıcı öneriye tıklarsa çalışan kısım
                  onSelected: (suggestion) {
                    setState(() {
                      selectedLocation = suggestion;
                    });

                    locationCtrl.text = suggestion;
                  },
                  // API boş dönerse gösterilecek widget

                  emptyBuilder: (context) => Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      "No matching locations",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                  decorationBuilder: (context, child) {
                    return Container(
                      margin: const EdgeInsets.only(top: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.12),
                            blurRadius: 18,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: child,
                    );
                  },
                ),
              ),

              const SizedBox(height: 15),

              //Additional Information
              _sectionTitle("Additional Information", width),

              const SizedBox(height: 10),

              //description
              // DESCRIPTION TEXTAREA
              Container(
                // Yükseklik elle kontrol edebilirsin, auto büyür
                constraints: BoxConstraints(
                  minHeight: height * 0.15, // minimum yükseklik
                  maxHeight: height * 0.9, // çok büyümesin
                ),

                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 14),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: Colors.grey.shade200),
                ),

                child: TextField(
                  controller: descCtrl,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  // sınırsız satır
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Add a description...",
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 15,
                    ),
                  ),
                  style: TextStyle(fontSize: 15, color: Colors.black87),
                ),
              ),

              const SizedBox(height: 15),

              //Photos
              _sectionTitle("Photos", width),

              const SizedBox(height: 10),

              //photos area
              SizedBox(
                height: 120,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    // Eklenen her foto

                    //spread operator (...) ->bir listenin elemanlarını başka bir listenin içine tek tek eklemeye yarar.
                    ...selectedImages.asMap().entries.map((entry) {
                      int index = entry.key;
                      XFile image = entry.value;

                      //recorded as |
                      /*MapEntry(0, img1),
                      MapEntry(1, img2),
                      MapEntry(2, img3)*/

                      return Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 12),
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: FileImage(File(image.path)),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),

                          // X (silme butonu)
                          Positioned(
                            right: 0,
                            top: 0,
                            child: GestureDetector(
                              onTap: () => _removePhoto(index),
                              child: Container(
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black.withOpacity(0.6),
                                ),
                                child: Icon(Icons.close, color: Colors.white, size: 16),
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),


                    // Add Photo Bubble
                    if(selectedImages.length <5) GestureDetector(
                      onTap: _showPhotoSourceSelector,
                      child: Container(
                        width: 100,
                        height: 100,
                        margin: EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.grey.shade400,
                            style: BorderStyle.solid,
                            width: 2,
                          ),
                        ),
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_a_photo_outlined, size: 28, color: Colors.grey),
                              SizedBox(height: 5),
                              Text("Add", style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  void _openBreedSelector(BuildContext context) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Container(
            height: 300,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
            ),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 15),
                Expanded(
                  child: ListView(
                    children: breedList.map((item) {
                      bool isSelected = item == selectedBreed;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedBreed = item;
                            Navigator.pop(context);
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 6),
                          padding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 12),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.blue.shade50
                                : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                item,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color:
                                      isSelected ? Colors.blue : Colors.black87,
                                ),
                              ),
                              if (isSelected)
                                const Icon(Icons.check, color: Colors.blue),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        });
  }

  void _openSpeciesSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      backgroundColor: Colors.transparent, // dışını tamamen kaldırıyor
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 50,
            top: 10,
          ),
          child: Container(
            height: 300,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
            ),
            child: Column(
              children: [
                const SizedBox(height: 10),
                // drag handle
                Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                const SizedBox(height: 15),

                // LİSTE
                Expanded(
                  child: ListView(
                    children: animalTypeList.map((item) {
                      bool isSelected = item == selectedSpecies;

                      return GestureDetector(
                        onTap: () {
                          //setState(() => selectedSpecies = item);
                          setState(() {
                            selectedSpecies = item;
                            breedList = breedMap[item]!;
                            selectedBreed = null;
                          });
                          Navigator.pop(context);
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 6),
                          padding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 12),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.blue.shade50
                                : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                item,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color:
                                      isSelected ? Colors.blue : Colors.black87,
                                ),
                              ),
                              if (isSelected)
                                const Icon(Icons.check, color: Colors.blue)
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 15),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openColorSelector(BuildContext context) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Container(
            height: 300,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
            ),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 15),
                Expanded(
                  child: ListView(
                    children: colorList.map((item) {
                      bool isSelected = item == selectedColor;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedColor = item;
                          });
                          Navigator.pop(context);
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 6),
                          padding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 12),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.blue.shade50
                                : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                item,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color:
                                      isSelected ? Colors.blue : Colors.black87,
                                ),
                              ),
                              if (isSelected)
                                const Icon(Icons.check, color: Colors.blue),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        });
  }

  Future<void> _pickEventDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 1)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        eventDate = pickedDate;
      });
    }
  }

  // source = camera or gallery?
  Future<void> _pickMultipleImages() async {
    final List<XFile> images = await _picker.pickMultiImage(
      //pickImage() metodu çalıştırılır ve kullanıcıdan fotoğraf seçmesi beklenir.
      //source: source,
      imageQuality: 70,
    );

    if (images.isNotEmpty) {
      //max 5 kontrolu
      if(selectedImages.length + images.length >5){
        int available = 5 - selectedImages.length;

        if(available <= 0){
          //kullanici 5 foto zaten ekledi
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("You can upload max 5 photos")),
          );
          return;
        }
        // Kullanıcının seçtiği fotoğrafları kısıtla
        selectedImages.addAll(images.take(available));
      }else{
        selectedImages.addAll(images);
      }
      setState(() {

      });
    }
  }

  void _showPhotoSourceSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.only(bottom: 70, left:20, right:20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 10),

              const Text("Select Photo Source",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 10),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text("Pick from Gallery"),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: Icon(Icons.add_photo_alternate),
                title: Text("Pick Multiple Photos"),
                onTap: () {
                  Navigator.pop(context);
                  _pickMultipleImages();
                },
              ),

              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text("Take a Photo"),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _removePhoto(int index){
    setState(() {
      selectedImages.removeAt(index);
    });
  }

  Future <void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(
      source: source, imageQuality: 70,
    );
    if (image != null) { setState(() { selectedImages.add(image); }); }
  }
}

// STYLED SECTION TITLE
Widget _sectionTitle(String title, double width) {
  return Text(
    title,
    style: TextStyle(
        fontSize: width * 0.038,
        fontWeight: FontWeight.w600,
        color: Colors.black87),
  );
}
