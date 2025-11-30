import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pawnav/app/theme/colors.dart';
import 'package:pawnav/core/errors/error_messages.dart';
import 'package:pawnav/core/errors/supabase_exceptions.dart';
import 'package:pawnav/core/utils/custom_snack.dart';
import 'package:pawnav/features/auth/presentation/widgets/profile_input_field.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pawnav/core/services/permission_service.dart';
import 'package:pawnav/core/services/image_picker_service.dart';


class AdditionalInfoScreen extends StatefulWidget {
  const AdditionalInfoScreen({super.key});

  @override
  State<AdditionalInfoScreen> createState() => _AdditionalInfoScreenState();
}

class _AdditionalInfoScreenState extends State<AdditionalInfoScreen> {
  TextEditingController locationController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  double imageOpacity = 1.0;

  File? selectedImage;

  final permissionService = PermissionService();
  final imagePickerService = ImagePickerService();

  Future<void> pickCameraImage() async {
    final allowed = await permissionService.requestCameraPermission();
    if (!allowed) {
      AppSnackbar.error(context, "Camera permission is required.");
      return;
    }

    final XFile? photo = await imagePickerService.pickSingle(ImageSource.camera);
    if (photo == null) return;

    final cropped = await ImageCropper().cropImage(
      sourcePath: photo.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      compressQuality: 95,
    );

    if (cropped == null) return;

    setState(() {
      selectedImage = File(cropped.path);
    });
  }


  Future<void> pickImage() async {
    try {
      // ---- 1) Gallery izni kontrolü ----
      final allowed = await permissionService.requestGalleryPermission();
      if (!allowed) {
        AppSnackbar.error(context, "Gallery permission is required.");
        return;
      }

      // ---- 2) Fotoğraf seçme işlemi ----
      final XFile? photo = await imagePickerService.pickSingle(ImageSource.gallery);
      if (photo == null) return;

      // ---- 3) Fotoğrafı kırpma ----
      final cropped = await ImageCropper().cropImage(
        sourcePath: photo.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 95,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Photo',
            toolbarColor: Colors.white,
            toolbarWidgetColor: Colors.black,
            lockAspectRatio: true,
            cropStyle: CropStyle.circle,
          ),
          IOSUiSettings(
            title: 'Crop Photo',
            aspectRatioLockEnabled: true,
          ),
        ],
      );

      if (cropped == null) return;

      // ---- 4) State güncelleme ----
      setState(() {
        selectedImage = File(cropped.path);
      });

    } catch (e) {
      AppSnackbar.error(context, "Error picking image. Please try again.");
    }
  }



  /*Future<void> pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? photo = await picker.pickImage(source: ImageSource.gallery);
      if (photo == null) return;

      final cropped = await ImageCropper().cropImage(
        sourcePath: photo.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 95,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Photo',
            toolbarColor: Colors.white,
            toolbarWidgetColor: Colors.black,
            lockAspectRatio: true,
            cropStyle: CropStyle.circle,

          ),
          IOSUiSettings(
            title: 'Crop Photo',
            aspectRatioLockEnabled: true,
          ),
        ],
      );

      if (cropped == null) return;

      setState(() {
        selectedImage = File(cropped.path);
      });

    } catch (e) {

      AppSnackbar.error(context, "Error picking image. Please try again.");
    }
  }*/


  Future<bool> showDeleteDialog() async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false, // dışarı tıklayınca kapanmasın
          builder: (context) {
            return AlertDialog(
              title: const Text("Delete Photo"),
              content:
                  const Text("Are you sure you want to delete this photo?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text(
                    "Delete",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  Future<String?> uploadPhoto(String userId) async {
    if (selectedImage == null) return null;

    try {
      final fileName = "$userId-profile.jpg";

      await Supabase.instance.client.storage.from('profile_photos').upload(
          fileName, selectedImage!,
          fileOptions: const FileOptions(upsert: true));

      final String publicUrl = Supabase.instance.client.storage
          .from('profile_photos')
          .getPublicUrl(fileName);

      return publicUrl;
    } catch (e) {
      // print("Upload error: $e");
      final failure = SupabaseErrorHandler.handle(e);
      AppSnackbar.error(context, failure.message);
      return null;
    }
  }

  Future<void> _saveProfile() async {
    final supabase = Supabase.instance.client;

    try {
      final user = supabase.auth.currentUser;
      if (user == null) {

        AppSnackbar.error(context, ErrorMessages.noSession);
        return;
      }

      // ---- 1) Validate fields ----
      final name = nameController.text.trim();
      final username = userNameController.text.trim();
      // final location = locationController.text.trim();

      if (name.isEmpty || username.isEmpty) {
        AppSnackbar.info(context, "Name and username are required.");

        return;
      }

      // ---- 2) Username already taken? ----
      final existingUsername = await supabase
          .from('profiles')
          .select('id')
          .eq('username', username)
          .neq('id', user.id)
          .maybeSingle();

      if (existingUsername != null) {

        AppSnackbar.error(context, ErrorMessages.usernameTaken);
        return;
      }

      // ---- 3) Photo upload ----
      final photoUrl = await uploadPhoto(user.id);

      // ---- 4) Bu kullanıcı için kayıt var mı? ----
      final existingProfile = await supabase
          .from('profiles')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      // ---- 5) Insert or Update ----
      if (existingProfile == null) {
        // First-time Google Login user
        await supabase.from('profiles').insert({
          'id': user.id,
          'email': user.email,
          'name': name,
          'username': username,
          // 'location': location,
          'photo_url': photoUrl,
        });

        if (mounted) context.go('/onboarding');
      } else {
        // Updating existing profile
        await supabase.from('profiles').update({
          'name': name,
          'username': username,
          // 'location': location,
          'photo_url': photoUrl,
        }).eq('id', user.id);

        AppSnackbar.success(context, "Profile saved successfully!");

        if (mounted) context.go('/home');
      }
    } catch (e) {
      final errorMessage = e.toString();

      if (errorMessage.contains('duplicate key value violates unique constraint')) {

        AppSnackbar.error(context, "This username is already taken");

        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ERROR: $e')),
      );
    }

    /*catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ERROR: $e')),
      );
    }*/
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
          padding: const EdgeInsets.only(bottom: 70, left: 20, right: 20),
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

              const Text(
                "Select Photo Source",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),

              // ---- From Gallery ----
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("Pick from Gallery"),
                onTap: () {
                  Navigator.pop(context);
                  pickImage(); // 🔵 UPDATED → senin gallery fonksiyonun
                },
              ),

              // ---- From Camera ----
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Take a Photo"),
                onTap: () {
                  Navigator.pop(context);
                  pickCameraImage();
                },
              ),
            ],
          ),
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    final screenInfo = MediaQuery.of(context);
    final double height = screenInfo.size.height;
    final double width = screenInfo.size.width;

    return Scaffold(
      // backgroundColor: const Color(0xFFF7F8FB),
      backgroundColor: AppColors.white2,
      body: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).padding.bottom + 50,
              top: width * 0.055,
              right: width * 0.055,
              left: width * 0.055),
          child: Center(
            child: Column(
              children: [
                SizedBox(height: height * 0.05),

                // Paw Icon
                Icon(Icons.pets, color: AppColors.primary, size: 36),

                const SizedBox(height: 16),

                // Title
                Text(
                  "Complete Your Profile",
                  style: TextStyle(
                    fontSize: width * 0.06,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF324067),
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  "Tell us a bit about yourself.",
                  style: TextStyle(
                    fontSize: width * 0.04,
                    color: Colors.grey.shade600,
                  ),
                ),

                SizedBox(height: height * 0.025),

                // Profile Photo
                GestureDetector(
                  // onTap: pickImage,
                  onTap: _showPhotoSourceSelector,
                  child: Stack(
                    children: [
                      // Outer circle
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              Colors.white,
                              Colors.grey.shade200,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 65,
                          backgroundColor: Colors.grey.shade300,
                          // backgroundColor: AppColors.background,
                          backgroundImage: selectedImage != null
                              ? FileImage(selectedImage!)
                              : null,
                          child: selectedImage == null
                              ? Icon(
                                  Icons.camera_alt,
                                  size: 40,
                                  color: Colors.grey[600],

                                  // color: AppColors.primary,
                                )
                              : null,
                        ),
                      ),

                      // + Icon
                      Positioned(
                        bottom: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () async {
                            if (selectedImage == null) {
                              pickImage();
                            } else {
                              final shouldDelete = await showDeleteDialog();

                              if (shouldDelete) {
                                // burada fade-out animasyonu ile sileceğiz (3. adım)
                                startFadeOut();
                              }
                              /*setState(() {
                                selectedImage = null;
                              });*/
                            }
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFF233E96), Color(0xFF3C59C7)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(7),
                            child: Icon(
                              selectedImage == null ? Icons.add : Icons.delete,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: height * 0.02),

                const Text(
                  "Profile Photo",
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF324067),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "(Optional)",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade500,
                  ),
                ),

                const SizedBox(height: 20),

                // White Card Input Container
                Container(
                  width: width * 0.88,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // FULL NAME
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "FULL NAME",
                          style: TextStyle(
                            fontSize: width * 0.03,
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      ProfileInputField(
                        hintText: "John Doe",
                        controller: nameController,
                        //obscureText: false,
                      ),

                      const SizedBox(height: 18),

                      // USERNAME
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "USERNAME",
                          style: TextStyle(
                            fontSize: width * 0.03,
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      ProfileInputField(
                        hintText: "johndoe_pets",
                        controller: userNameController,
                        // obscureText: false,
                      ),

                      const SizedBox(height: 18),

                      // LOCATION
                      /*Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "LOCATION (OPTIONAL)",
                          style: TextStyle(
                            fontSize: width * 0.03,
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      ProfileInputField(
                        hintText: "San Francisco, CA",
                        controller: locationController,
                        // obscureText: false,
                      ),*/
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Continue Button (Full width gradient)
                GestureDetector(
                  onTap: _saveProfile,
                  child: Container(
                    width: width * 0.88,
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
                      "Continue",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: width * 0.035,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void startFadeOut() {
    setState(() {
      imageOpacity = 1.0;
    });

    // animasyonu çalıştırıyoruz
    Future.delayed(const Duration(milliseconds: 60), () {
      setState(() {
        imageOpacity = 0.0; // opacity düşüyor
      });

      // animasyon bittikten sonra fotoğrafı siliyoruz
      Future.delayed(const Duration(milliseconds: 300), () {
        setState(() {
          selectedImage = null;
          imageOpacity = 1.0; // reset for next time
        });
      });
    });
  }
}
