import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pawnav/app/router.dart';
import 'package:pawnav/app/theme/colors.dart';
import 'package:pawnav/core/errors/error_messages.dart';
import 'package:pawnav/core/errors/failure.dart';
import 'package:pawnav/core/errors/supabase_exceptions.dart';
import 'package:pawnav/core/utils/custom_snack.dart';
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

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isObscure = true;

  Future<bool> _signUpUser() async {
    final supabase = Supabase.instance.client;

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    try {
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
        emailRedirectTo: 'io.supabase.flutter://email-confirm',
      );

      final user = response.user;

      if (user == null) {
        AppSnackbar.error(context, "Signup failed.");
        return false;
      }

      if (user.identities == null || user.identities!.isEmpty) {
        AppSnackbar.error(context, ErrorMessages.emailAlreadyExists);
        return false;
      }

      // Yeni kullanıcı → verify email
      AppSnackbar.info(context, ErrorMessages.verifyEmailToContinue);
      return true;

    } catch (e) {
      Failure failure = SupabaseErrorHandler.handle(e);
      AppSnackbar.error(context, failure.message);
      return false;
    }
  }




  // Future<void> _signUpUser() async {
  //   final supabase = Supabase.instance.client;
  //
  //   final email = emailController.text.trim();
  //   final password = passwordController.text.trim();
  //
  //   final user = supabase.auth.currentUser!;
  //
  //   try {
  //     // 1) Bu email profiles tablosunda var mı?
  //     final existing = await supabase
  //         .from('profiles')
  //         .select('id')
  //         .eq('email', email)
  //         .maybeSingle();
  //
  //     if (existing != null) {
  //       // Email zaten kayıtlı
  //       /*ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text("This email is already registered.")),
  //       );*/
  //       AppSnackbar.error(context, ErrorMessages.emailAlreadyExists);
  //       return;
  //     }
  //
  //     if (existing == null) {
  //       await supabase.from('profiles').insert({
  //         'id': user.id,
  //         'email': user.email,
  //       });
  //     }
  //
  //
  //     // 2) Yeni kullanıcı → auth.signUp()
  //     final response = await supabase.auth.signUp(
  //       email: email,
  //       password: password,
  //       emailRedirectTo: 'io.supabase.flutter://email-confirm',
  //
  //     );
  //
  //
  //     /*
  //     * response.session
  //     * Kullanıcı kayıt olur → user oluşturulur
  //       Ama giriş yapılmış bir session verilmez
  //       Çünkü kullanıcı önce e-mailindeki confirm linkine tıklamak zorundadır
  //     *
  //     * */
  //
  //     // 3) Supabase doğrulama gönderdi
  //     if (response.user != null && response.session == null) {
  //       /*ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //           content: Text('Registration successful! Please verify your email.'),
  //         ),
  //       );*/
  //       AppSnackbar.info(
  //           context, ErrorMessages.verifyEmailToContinue);
  //
  //       if (!mounted) return;
  //       router.go('/verify_email_screen');
  //
  //       // context.go('/verify_email_screen');
  //     }
  //   } catch (e) {
  //     /*ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Error: $e")),
  //     );*/
  //     Failure failure = SupabaseErrorHandler.handle(e);
  //     AppSnackbar.error(context, failure.message);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final screenInfo = MediaQuery.of(context);
    final double height = screenInfo.size.height;
    final double width = screenInfo.size.width;

    return Scaffold(
      // backgroundColor: AppColors.background,
      backgroundColor: AppColors.background2,

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.07),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: height * 0.15),

              // Paw icon
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    )
                  ],
                ),
                child: Image.asset(
                  'assets/app_icon/icon_transparent.png',
                  width: 40,
                  height: 40,
                ),
              ),

              SizedBox(height: 28),

              // Title
              const Text(
                "Join the Community",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1C1C1C),
                ),
              ),

              SizedBox(height: 8),

              // Subtitle
              Text(
                "Help bring pets home safely.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),

              SizedBox(height: 40),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Gmail Input
                    CustomTextFormField(
                      hintText: "your.email@gmail.com",
                      controller: emailController,
                      prefixIcon: Image.asset(
                        "assets/login_screen/emailIcon.png",
                        scale: 1.5,
                      ),
                      keyboardType: TextInputType.emailAddress,
                      obscureText: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'E-mail cannot be empty';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(value.trim())) {
                          return 'Enter a valid e-mail';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 22),

                    // Password Input
                    CustomTextFormField(
                      hintText: "Enter your password",
                      controller: passwordController,
                      obscureText: isObscure,
                      prefixIcon: Image.asset(
                        "assets/login_screen/passwordIcon.png",
                        scale: 1.5,
                      ),
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isObscure = !isObscure;
                            });
                          },
                          icon: Icon(
                            isObscure ? Icons.visibility_off : Icons.visibility,
                          )),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password cannot be empty';
                        }
                        if (value.length < 6) {
                          return 'Minimum 6 characters required';
                        }
                        if (!RegExp(r'[A-Z]').hasMatch(value)) {
                          return 'Password must contain at least one uppercase letter';
                        }
                        if (!RegExp(r'[0-9]').hasMatch(value)) {
                          return 'Password must contain at least one number';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 35),

                    /*// Continue Button
                    ButtonComponent(
                      "Continue",
                      Colors.white,
                      AppColors.primary,
                          () async {
                        if (_formKey.currentState!.validate()) {
                          await _signUpUser();
                        }
                      },
                    ),*/

                    GestureDetector(
                      /*Form içindeki tüm validator’ları çalıştırır
                      Eğer hiç hata yoksa true, hata varsa false döner*/
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          final success = await _signUpUser();

                          if (success && mounted) {
                            context.go('/verify_email_screen');
                          }
                        }
                      },

                      /*onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          await _signUpUser();
                        }
                        context.go('/verify_email_screen');

                      },*/
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

                    SizedBox(height: 25),

                    // Log In text
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account?",
                          style: TextStyle(color: Colors.black54),
                        ),
                        GestureDetector(
                          onTap: () => context.go('/login'),
                          child: Text(
                            " Log In",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              color: AppColors.primary,
                              fontSize: width * 0.04,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
