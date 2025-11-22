import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
      /*if (Platform.isAndroid) {
      await requestPermission();
      }*/
      final ImagePicker picker = ImagePicker();
      //kullanıcıdan galerinden bir fotoğraf seçmesini bekle
      final XFile? photo = await picker.pickImage(source: ImageSource.gallery);

      if (photo != null) {
        setState(() {
          // Seçilen fotoğrafın path değerini kullanarak bir File nesnesi oluşturuyoruz.
          // Bu File nesnesini selectedImage değişkenine atıyoruz.
          // Böylece UI (arayüz) bunu kullanarak resmi gösterebilir.
          selectedImage = File(photo.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
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
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 50),

              // Paw Icon
              Icon(Icons.pets, color: AppColors.primary, size: 36),

              const SizedBox(height: 16),

              // Title
              const Text(
                "Complete Your Profile",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF324067),
                ),
              ),

              const SizedBox(height: 6),

              Text(
                "Tell us a bit about yourself.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 35),

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
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Color(0xFF324067),
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(7),
                        child:
                            const Icon(Icons.add, color: Colors.white, size: 20),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

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

              const SizedBox(height: 35),

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
                        "FULL NAME *",
                        style: TextStyle(
                          fontSize: 13,
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
                        "USERNAME *",
                        style: TextStyle(
                          fontSize: 13,
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
                          fontSize: 13,
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

              const SizedBox(height: 40),

              // Continue Button (Full width gradient)
              GestureDetector(
                onTap: _saveProfile,
                child: Container(
                  width: width * 0.88,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF233E96), Color(0xFF3C59C7)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    "Continue",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
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
      /*backgroundColor: AppColors.background,
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                width: double.infinity,
                height: height * 0.2,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(250),
                    bottomRight: Radius.circular(250),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: height * 0.1),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    'Complete Your Profile',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: width * 0.05,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Form(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: height * 0.01,
                            left: width * 0.08,
                            right: width * 0.08),
                        child: CustomTextFormField(
                          hintText: "Name",
                          controller: nameController,
                          obscureText: false,
                          prefixIcon: Image.asset(
                            'assets/login_screen/nameIcon.png',
                          ),
                          keyboardType: TextInputType.name,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Name cannot be empty';
                            }
                            if (value.trim().length < 2) {
                              return 'Name must be at least 2 characters long';
                            }
                            if (!RegExp(r"^[a-zA-Z\s]+$")
                                .hasMatch(value.trim())) {
                              return 'Name can only contain letters';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: height * 0.01,
                            left: width * 0.08,
                            right: width * 0.08),
                        child: CustomTextFormField(
                          hintText: "Username",
                          controller: userNameController,
                          obscureText: false,
                          prefixIcon: Image.asset(
                            'assets/login_screen/usernameIcon.png',
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Username cannot be empty';
                            }
                            if (value.trim().length < 4) {
                              return 'Username must be at least 4 characters long';
                            }
                            if (!RegExp(r"^[a-zA-Z0-9_]+$")
                                .hasMatch(value.trim())) {
                              return 'Username can only contain letters, numbers, or underscores';
                            }
                            return null;
                          },
                        ),
                      ),

                      //bottom buttons
                      Padding(
                        padding: EdgeInsets.only(top: width * 0.05),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ButtonComponent("Finish", Colors.white,
                                AppColors.primary, () async {
                                  await _saveProfile();
                                }),
                            //ButtonComponent("Skip for now", Colors.white, AppColors.primary, (){}),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),*/
    );
  }
}
