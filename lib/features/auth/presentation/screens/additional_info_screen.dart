import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pawnav/app/theme/colors.dart';
import 'package:pawnav/core/widgets/button_component.dart';
import 'package:pawnav/core/widgets/custom_text_form_field.dart';
import 'package:pawnav/features/auth/presentation/widgets/profile_input_field.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

  /*Future<void> requestPermission() async {
    if (Platform.isAndroid) {
      if (await Permission.photos.isDenied ||
          await Permission.photos.isPermanentlyDenied) {
        await Permission.photos.request();
      }
    }
  }*/

  Future<void> pickImage() async {
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }


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
      print("Upload error: $e");
      return null;
    }
  }

  Future<void> _saveProfile() async {
    final supabase = Supabase.instance.client;

    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No user logged in.')),
        );
        return;
      }

      //check if there is userName is taken
      final existingUsername = await supabase
          .from('profiles')
          .select('id')
          .eq('username', userNameController.text.trim())
          .neq('id', user.id)
          .maybeSingle(); //kayıt yoksa hata vermesin, sadece null dönsün diye kullanılır.

      if (existingUsername != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('This username is already taken')),
        );
        return;
      }

      if (nameController.text.trim().isEmpty ||
          userNameController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Name and username are required')),
        );
        return;
      }

      final existingProfile = await supabase
          .from('profiles')
          .select('id')
          .eq('id', user.id)
          .maybeSingle(); //ya tek bir sonuç döner ya da hiç sonuç yoksa null döner.

      final String? photoUrl = await uploadPhoto(user.id);

      if (existingProfile == null) {
        //new user -> insert
        await supabase.from('profiles').insert({
          'id': user.id,
          'email': user.email,
          'name': nameController.text.trim(),
          'username': userNameController.text.trim(),
          'location': locationController.text.trim(),
          'photo_url': photoUrl,
        });

        if (mounted) {
          context.go('/onboarding');
        }
      } else {
        //already have an account -> update
        await supabase.from('profiles').update({
          'email': user.email,
          'name': nameController.text.trim(),
          'username': userNameController.text.trim(),
          'location': locationController.text.trim(),
          'photo_url': photoUrl,
        }).eq('id', user.id);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile saved successfully!')),
      );

      //kullanıcı kayıtlıysa ana ekrana yönlendir
      if (existingProfile != null && mounted) {
        context.go('/home');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenInfo = MediaQuery.of(context);
    final double height = screenInfo.size.height;
    final double width = screenInfo.size.width;

    return Scaffold(
      // backgroundColor: const Color(0xFFF7F8FB),
      backgroundColor: AppColors.background2,
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
                  onTap: pickImage,
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
                          backgroundImage: selectedImage != null
                              ? FileImage(selectedImage!)
                              : null,
                          child: selectedImage == null
                              ? Icon(
                                  Icons.camera_alt,
                                  size: 40,
                                  color: Colors.grey.shade700,
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
                      Align(
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
                      ),
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
