import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pawnav/app/router.dart';
import 'package:pawnav/app/theme/colors.dart';
import 'package:pawnav/core/widgets/button_component.dart';
import 'package:pawnav/core/widgets/button_component.dart';
import 'package:pawnav/core/widgets/custom_text_form_field.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  /*Flutter’da birden fazla TextFormField içeren formları yönetmek için Form widget’ı kullanılır.
  Ama bu formun geçerli olup olmadığını (örneğin kullanıcı boş bıraktı mı, mail geçerli mi vs.) kontrol etmek için FormState’e erişmemiz gerekir.

  Bu yüzden GlobalKey<FormState> tanımlıyoruz.
  Bu key, Form’un durumuna (validate(), save() gibi fonksiyonlara) dışarıdan erişmemizi sağlar.*/

  TextEditingController nameController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isObscure = true;

  Future<void> _signUpUser() async {
    try {
      //acess the Supabase client
      final supabase = Supabase.instance.client;

      final response = await supabase.auth.signUp(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      //to confirm e mail
      if (response.user != null && response.session == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration successful! Please verify your email.'),
          ),
        );

        if (mounted) {
          context.go('/verify_email_screen');
        }

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
                height: height * 0.27,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(190),
                    bottomRight: Radius.circular(190),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: height * 0.1),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    "Create an account",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: width * 0.07,
                    ),
                  ),
                ),
              ),
            ],
          ),

          //inputfield
          Expanded(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      /*Padding(
                        padding: EdgeInsets.only(
                            top: height * 0.05,
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
                      ),*/
                      /*Padding(
                        padding: EdgeInsets.only(
                            top: height * 0.025,
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
                      ),*/
                      Padding(
                        padding: EdgeInsets.only(
                            top: height * 0.025,
                            left: width * 0.08,
                            right: width * 0.08),
                        child: CustomTextFormField(
                          hintText: "E-mail",
                          controller: emailController,
                          obscureText: false,
                          prefixIcon: Image.asset(
                            'assets/login_screen/emailIcon.png',
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'E-mail cannot be empty';
                            }
                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                .hasMatch(value.trim())) {
                              return 'Enter a valid e-mail address';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: height * 0.025,
                            left: width * 0.08,
                            right: width * 0.08),
                        child: CustomTextFormField(
                          hintText: "Password",
                          controller: passwordController,
                          obscureText: isObscure,
                          prefixIcon: Image.asset(
                            'assets/login_screen/passwordIcon.png',
                          ),
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  isObscure = !isObscure;
                                });
                              },
                              icon: Icon(
                                isObscure
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              )),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Password cannot be empty';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters long';
                            }
                            if (!RegExp(r'[A-Z]').hasMatch(value)) {
                              return 'Password must contain at least one uppercase letter';
                            }
                            if (!RegExp(r'[a-z]').hasMatch(value)) {
                              return 'Password must contain at least one lowercase letter';
                            }
                            if (!RegExp(r'[0-9]').hasMatch(value)) {
                              return 'Password must contain at least one number';
                            }
                            if (!RegExp(r'[!@#\$&*~]').hasMatch(value)) {
                              return 'Password should contain at least one special character (!@#\$&*~)';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: height * 0.05,
                            left: width * 0.08,
                            right: width * 0.08),
                        child: ButtonComponent(
                            "Next", Colors.white, AppColors.primary, () async {
                          if (_formKey.currentState!.validate()) {
                            await _signUpUser();

                          }
                        }),
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
