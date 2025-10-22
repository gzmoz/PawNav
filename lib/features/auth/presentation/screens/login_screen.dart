import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pawnav/app/router.dart';
import 'package:pawnav/app/theme/colors.dart';
import 'package:pawnav/core/widgets/button_component.dart';
import 'package:pawnav/core/widgets/password_text_field_component.dart';
import 'package:pawnav/core/widgets/text_field_component.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final supabase = Supabase.instance.client;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> _loginUser() async{
    try{
      final response = await supabase.auth.signInWithPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      final user = response.user;

      if(user == null){ //kullanıcı bulunamadı
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Login failed. Check your credentials.")),
        );
        return;
      }

      //check whether the email is confirmed or not
      if(user.emailConfirmedAt == null){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please verify your email before logging in'),),
        );
        return;
      }

      final profile = await supabase
        .from('profiles')
        .select('name,username')
        .eq('id', user.id)
        .maybeSingle();

      if(profile == null ||
          profile['name'] == null ||
          profile['username'] == null ||
          (profile['name'] as String).isEmpty ||
          (profile['username'] as String).isEmpty){

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Welcome! Please complete your profile")),
        );
        context.go('/additional_info_screen');
      }else{
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Login successful")),);
        context.go('/home');
      }



    }catch(e){
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              //to show the overflow of the cat image (Taşan kısmı kırpma, bırak görünsün)
              children: [
                Container(
                  width: width * 1.0,
                  height: height * 0.8,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Transform.translate(
                      offset: Offset(0, height * 0.03),
                      child: Image.asset(
                        "assets/login_screen/logcat.png",
                        height: height * 0.18,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                ),
                Column(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.only(top: height * 0.1),
                        child: Text(
                          "PawNav",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: width * 0.09,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(left: width * 0.1, top: width * 0.07),
                      child: const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "E-mail or Username",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    TextFieldComponent(
                      hintText: "",
                      textInputType: TextInputType.emailAddress,
                      obscureText: false,
                      controller: emailController,
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(left: width * 0.1, top: width * 0.03),
                      child: const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Password",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    /*TextFieldComponent(
                      hintText: "",
                      textInputType: TextInputType.visiblePassword,
                      obscureText: true,
                      controller: passwordController,
                    ),*/
                    PasswordTextFieldComponent("", passwordController),
                    Padding(
                      padding: EdgeInsets.only(
                          top: width * 0.09, bottom: width * 0.02),
                      /*child: ButtonComponent(
                          "Login", Colors.black, Colors.white, () {}),*/
                      child: Container(
                        width: width * 0.6,
                        height: height * 0.049,
                        decoration: BoxDecoration(
                          // color: Colors.white,
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(80),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10,
                              offset: Offset(2, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            await _loginUser();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            // backgroundColor: AppColors.background,
                          ),
                          label: Text(
                            "Sign-in",
                            style: TextStyle(
                              fontSize: width * 0.035,
                              color: Colors.black,
                            ),
                          ),
                          icon: const Icon(
                            Icons.login,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      " - or - ",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: width * 0.03,
                      ),
                    ),
                    SizedBox(
                      child: Padding(
                          padding: EdgeInsets.only(top: width * 0.02),
                          child: GestureDetector(
                            onTap: () {},
                            child: Image.asset(
                                'assets/login_screen/google_button_2x.png',
                                width: width * 0.39),
                          )),
                    )
                  ],
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: height * 0.05),
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: TextStyle(fontSize: width * 0.04),
                      ),
                      TextButton(
                        onPressed: () {
                          context.push('/sign_up');
                        },
                        child: Text(
                          "Sign-Up",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            color: AppColors.primary,
                            fontSize: width * 0.04,
                          ),
                        ),
                      )
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
