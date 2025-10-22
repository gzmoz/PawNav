import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pawnav/app/theme/colors.dart';
import 'package:pawnav/core/widgets/button_component.dart';
import 'package:pawnav/core/widgets/custom_text_form_field.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdditionalInfoScreen extends StatefulWidget {
  const AdditionalInfoScreen({super.key});

  @override
  State<AdditionalInfoScreen> createState() => _AdditionalInfoScreenState();
}

class _AdditionalInfoScreenState extends State<AdditionalInfoScreen> {
  TextEditingController locationController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController userNameController = TextEditingController();

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
          .maybeSingle();

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

      if(existingProfile == null){
        //new user -> insert
        await supabase.from('profiles').insert({
          'id': user.id,
          'email': user.email,
          'name': nameController.text.trim(),
          'username': userNameController.text.trim(),
        });

        if (mounted) {
          context.go('/onboarding');
        }

      }else{
        //already have an account -> update
        await supabase.from('profiles').update({
          'email': user.email,
          'name': nameController.text.trim(),
          'username': userNameController.text.trim(),
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
      backgroundColor: AppColors.background,
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

                      /*Padding(
                        padding: EdgeInsets.only(
                            top: height * 0.03,
                            left: width * 0.08,
                            right: width * 0.08,
                        ),
                        child: Container(
                          width: width * 0.9,
                          height: height * 0.2,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: width * 0.01,),
                                  child: SizedBox(
                                    width: width * 0.40,
                                    height: height * 0.15,
                                    child: Image.asset(
                                        'assets/login_screen/addphotoarea.png'),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: width * 0.03),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      SizedBox(
                                        width: width * 0.35,
                                        height: height * 0.04,
                                        child: ElevatedButton.icon(
                                          onPressed: () {},
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors.background,

                                          ),
                                          label: Text(
                                            "Add Profile Photo",
                                            style: TextStyle(
                                              fontSize: width * 0.025,
                                              color: AppColors.primary,
                                            ),
                                          ),
                                          icon: Image.asset(
                                              "assets/login_screen/addprofilephoto.png"),
                                          iconAlignment: IconAlignment.start,
                                        ),
                                      ),
                                      SizedBox(
                                        width: width * 0.35,
                                        height: height * 0.04,
                                        child: ElevatedButton.icon(
                                          onPressed: () {},
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors.background,

                                          ),
                                          label: Text(
                                            "Remove Photo",
                                            style: TextStyle(
                                              fontSize: width * 0.025,
                                              color: AppColors.primary,
                                            ),
                                          ),
                                          icon: Image.asset(
                                              "assets/login_screen/removephoto.png",),
                                          iconAlignment: IconAlignment.start,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ),
                      ),*/

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
                      /*Padding(
                        padding: EdgeInsets.only(
                            top: height * 0.01,
                            left: width * 0.08,
                            right: width * 0.08),
                        child: CustomTextFormField(
                          hintText: "Location (optional)",
                          controller: locationController,
                          obscureText: false,
                          prefixIcon: Image.asset(
                            'assets/login_screen/lcoationiconblue.png',
                          ),
                          */ /*validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Username cannot be empty';
                            }
                            if(value.trim().length <4){
                              return 'Username must be at least 4 characters long';
                            }
                            if (!RegExp(r"^[a-zA-Z0-9_]+$").hasMatch(value.trim())) {
                              return 'Username can only contain letters, numbers, or underscores';
                            }
                            return null;
                          },*/ /*
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: height * 0.01,
                            left: width * 0.08,
                            right: width * 0.08),
                        child: CustomTextFormField(
                          hintText: "Phone Number (optional)",
                          controller: numberController,
                          obscureText: false,
                          prefixIcon: Image.asset(
                            'assets/login_screen/phonenumbericon.png',
                          ),
                          keyboardType: TextInputType.number,
                          */ /*validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Username cannot be empty';
                            }
                            if(value.trim().length <4){
                              return 'Username must be at least 4 characters long';
                            }
                            if (!RegExp(r"^[a-zA-Z0-9_]+$").hasMatch(value.trim())) {
                              return 'Username can only contain letters, numbers, or underscores';
                            }
                            return null;
                          },*/ /*

                        ),
                      ),*/
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
      ),
    );
  }
}
