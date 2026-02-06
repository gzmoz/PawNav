import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pawnav/app/theme/colors.dart';
import 'package:pawnav/core/errors/error_messages.dart';
import 'package:pawnav/core/errors/failure.dart';
import 'package:pawnav/core/errors/supabase_exceptions.dart';
import 'package:pawnav/core/services/fcm_token_service.dart';
import 'package:pawnav/core/utils/custom_snack.dart';
import 'package:pawnav/core/widgets/password_text_field_component.dart';
import 'package:pawnav/core/widgets/text_field_component.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase/supabase.dart';
import 'package:flutter/services.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final supabase = Supabase.instance.client;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool _isGoogleSigningIn = false;
  bool _isSigningIn = false;

  // State değişkeni - kedi animasyonu
  Offset catOffset = const Offset(0, 1.0);

  /*x = 0 → sağa/sola hareket yok
    y = 1.0 → kedi şu an bulunduğu yerden 1 ekran yüksekliği aşağıda
    Yani kedi başlangıçta ekranın dışındadır.*/

  Future<void> _playFeedback() async {
    // Her cihazda çalışır
    HapticFeedback.lightImpact();

    //  Destekleyen cihazlarda ekstra click
    SystemSound.play(SystemSoundType.click);
  }


  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        catOffset =
            const Offset(0, 0); //kedi “gerçek pozisyonuna” geri dönmek ister
      });
    });
  }

  Future<void> _nativeGoogleSignIn() async {
    /// TODO: update the Web client ID with your own.
    ///
    /// Web Client ID that you registered with Google Cloud.
    const webClientId =
        '1050477886670-gpv0mroeodtcpu4josbe0douev1lsgve.apps.googleusercontent.com';

    /// TODO: update the iOS client ID with your own.
    ///
    /// iOS Client ID that you registered with Google Cloud.
    const iosClientId =
        '1050477886670-l62is9luvptpfk2ce0ruj911vbbcmjde.apps.googleusercontent.com';
    final scopes = ['email', 'profile'];
    final googleSignIn = GoogleSignIn.instance;
    await googleSignIn.initialize(
      serverClientId: webClientId,
      clientId: iosClientId,
    );
    final googleUser = await googleSignIn.attemptLightweightAuthentication();
    // or await googleSignIn.authenticate(); which will return a GoogleSignInAccount or throw an exception
    if (googleUser == null) {
      throw AuthException('Failed to sign in with Google.');
    }

    /// Authorization is required to obtain the access token with the appropriate scopes for Supabase authentication,
    /// while also granting permission to access user information.
    final authorization =
        await googleUser.authorizationClient.authorizationForScopes(scopes) ??
            await googleUser.authorizationClient.authorizeScopes(scopes);
    final idToken = googleUser.authentication.idToken;
    if (idToken == null) {
      throw AuthException('No ID Token found.');
    }
    await supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: authorization.accessToken,
    );
  }

  Future<void> _loginUser() async {
    try {
      final response = await supabase.auth.signInWithPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      final user = response.user;

      if (user == null) {
        //kullanıcı bulunamadı
        /*ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Login failed. Check your credentials.")),
        );*/
        AppSnackbar.error(context, ErrorMessages.invalidCredentials);

        return;
      }

      //check whether the email is confirmed or not
      if (user.emailConfirmedAt == null) {
        /*ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please verify your email before logging in'),
          ),
        );*/
        AppSnackbar.info(context, ErrorMessages.emailNotVerified);

        return;
      }

      final profile = await supabase
          .from('profiles')
          .select('name,username')
          .eq('id', user.id)
          .maybeSingle();

      await FcmTokenService.init();

      if (profile == null ||
          profile['name'] == null ||
          profile['username'] == null ||
          (profile['name'] as String).isEmpty ||
          (profile['username'] as String).isEmpty) {
        AppSnackbar.info(context, "Welcome to PawNav!");
      } else {
        AppSnackbar.success(context, "Login successful!");

        await FcmTokenService.init();
        //context.go('/home');
      }
    } catch (e) {
      Failure failure = SupabaseErrorHandler.handle(e);
      AppSnackbar.error(context, failure.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenInfo = MediaQuery.of(context);
    final double height = screenInfo.size.height;
    final double width = screenInfo.size.width;

    return Scaffold(
      // backgroundColor: AppColors.background,
      backgroundColor: const Color(0xFFF7F8FB),

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
                    child: AnimatedSlide(
                      //offset değerindeki değişimleri animasyonlu şekilde uygular
                      offset: catOffset,
                      duration: const Duration(milliseconds: 1100), //süre
                      curve: Curves.easeInOutBack, //hareket şekli
                      child: Transform.translate(
                        //widget’ı x ve y eksenlerinde kaydırmak (taşımak) için kullanılan bir widget
                        offset: Offset(0, height * 0.03),
                        child: Image.asset(
                          "assets/login_screen/logcat.png",
                          height: height * 0.18,
                          fit: BoxFit.fitWidth,
                        ),
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
                          "E-mail",
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
                    PasswordTextFieldComponent("", passwordController),
                    const SizedBox(height: 15),
                    Padding(
                      padding: EdgeInsets.only(right: width * 0.12, top: 4),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              context.push('/forgot_password');
                            },
                            splashColor: Colors.blue.withOpacity(0.2),
                            highlightColor: Colors.blue.withOpacity(0.15),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 2),
                              child: Text(
                                "Forgot Password",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FontStyle.italic,
                                  fontSize: width * 0.03,
                                ),
                              ),
                            ),
                          ),
                        ),
                        // child: GestureDetector(
                        //   onTap:(){
                        //     context.push('/forgot_password');
                        //   },
                        //   child: Text(
                        //     "Forgot Password",
                        //     style: TextStyle(
                        //         color: Colors.white,
                        //         fontWeight: FontWeight.w600,
                        //         fontStyle: FontStyle.italic,
                        //         fontSize: width * 0.03,
                        //         //decoration: TextDecoration.underline,
                        //         decorationColor: Colors.white,
                        //         decorationThickness: 1.8
                        //     ),
                        //   ),
                        // ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: width * 0.1,
                          right: width * 0.1,
                          top: height * 0.02,
                          bottom: height * 0.015),
                      child: Container(
                        width: width * 0.9,
                        height: height * 0.05,
                        decoration: BoxDecoration(
                          // color: Colors.white,
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10,
                              offset: Offset(2, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton.icon(
                          onPressed: _isSigningIn
                              ? null
                              : () async {
                            setState(() => _isSigningIn = true);

                            await _loginUser();

                            if (mounted) {
                              setState(() => _isSigningIn = false);
                            }
                          },

                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            disabledBackgroundColor: Colors.white.withOpacity(0.6),
                          ),
                          icon: _isSigningIn
                              ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor:
                              AlwaysStoppedAnimation<Color>(AppColors.primary),
                            ),
                          )
                              : const Icon(Icons.login, color: Colors.black),
                          label: Text(
                            _isSigningIn ? "Signing in..." : "Sign-in",
                            style: TextStyle(
                              fontSize: width * 0.035,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),

                        // child: ElevatedButton.icon(
                        //   onPressed: () async {
                        //     await _loginUser();
                        //   },
                        //
                        //   style: ElevatedButton.styleFrom(
                        //     backgroundColor: Colors.white,
                        //     // backgroundColor: AppColors.background,
                        //   ),
                        //   label: Text(
                        //     "Sign-in",
                        //     style: TextStyle(
                        //       fontSize: width * 0.035,
                        //       color: Colors.black,
                        //     ),
                        //   ),
                        //   icon: const Icon(
                        //     Icons.login,
                        //     color: Colors.black,
                        //   ),
                        // ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    buildOrDivider(),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: width * 0.39,
                      child: Material(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: _isGoogleSigningIn
                              ? null
                              : () async {
                                  setState(() {
                                    _isGoogleSigningIn = true;
                                  });

                                  try {
                                    await _nativeGoogleSignIn();
                                    await _handleGoogleProfile();
                                  } catch (e) {
                                    AppSnackbar.error(
                                      context,
                                      "Google login failed. Please try again.",
                                    );
                                  } finally {
                                    if (mounted) {
                                      setState(() {
                                        _isGoogleSigningIn = false;
                                      });
                                    }
                                  }
                                },
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              AnimatedOpacity(
                                duration: const Duration(milliseconds: 200),
                                opacity: _isGoogleSigningIn ? 0.6 : 1.0,
                                child: Image.asset(
                                  'assets/login_screen/google_button_2x.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                              if (_isGoogleSigningIn)
                                const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.black),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: height * 0.035),
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
            const SizedBox(height: 25),
            Positioned(
              bottom: 25,
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                  children: [
                    const TextSpan(text: 'By continuing, you agree to our '),
                    TextSpan(
                      text: 'Terms of Service',
                      style: const TextStyle(
                          decoration: TextDecoration.underline,
                          color: AppColors.primary),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => context.push('/terms-of-service'),
                    ),
                    const TextSpan(text: ' and '),
                    TextSpan(
                      text: 'Privacy Policy',
                      style: const TextStyle(
                          decoration: TextDecoration.underline,
                          color: AppColors.primary),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => context.push('/privacy-policy'),
                    ),
                    const TextSpan(text: '.'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleGoogleProfile() async {
    final session = supabase.auth.currentSession;

    if (session == null) {
      AppSnackbar.error(context, ErrorMessages.noSession);

      return;
    }

    final user = session.user;

    // ----------------------------
    // 1) Google display name al
    // ----------------------------
    String? googleName = user.userMetadata?['full_name'];

    // Eğer Google adı yoksa email'in '@' öncesini al
    googleName ??= user.email?.split('@')[0] ?? "New User";

    // ----------------------------
    // 2) Unique username üret
    // ----------------------------
    String baseUsername = googleName
        .toLowerCase()
        .replaceAll(" ", "_")
        .replaceAll(RegExp(r'[^a-z0-9_]'),
            ''); //Bu karakterlerin dışında (^) kalan her şeyi bul ve '' ile sil.

    // Username sonuna random sayı ekleyelim
    String generatedUsername =
        "$baseUsername${DateTime.now().millisecondsSinceEpoch % 10000}";

    // Unique olana kadar kontrol et
    bool isUnique = false;

    while (!isUnique) {
      final check = await supabase
          .from("profiles")
          .select("id")
          .eq("username", generatedUsername)
          .maybeSingle();

      if (check == null) {
        isUnique = true;
      } else {
        generatedUsername =
            "$baseUsername${(DateTime.now().millisecondsSinceEpoch ~/ 2) % 10000}";
      }
    }

    // ----------------------------
    // 3) Bu kullanıcı zaten kayıtlı mı?
    // ----------------------------
    final existingProfile = await supabase
        .from('profiles')
        .select()
        .eq('id', user.id)
        .maybeSingle();

    // ----------------------------
    // 4) Profil yoksa otomatik oluştur
    // ----------------------------
    if (existingProfile == null) {
      await supabase.from('profiles').insert({
        'id': user.id,
        'email': user.email,
        'name': googleName,
        'username': generatedUsername,
        'photo_url': user.userMetadata?['avatar_url'],
        'created_at': DateTime.now().toIso8601String(),
      });
    }

    // ----------------------------
    // 5) Artık direkt Home ekranına git
    // ----------------------------
    await FcmTokenService.init();
    if (!mounted) return;
    AppSnackbar.success(context, "Login successful!");
    //context.go('/home');
  }

  Widget buildOrDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              color: Colors.white.withOpacity(0.6),
              thickness: 1,
              endIndent: 10,
            ),
          ),
          const Text(
            " or ",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Divider(
              color: Colors.white.withOpacity(0.6),
              thickness: 1,
              indent: 10,
            ),
          ),
        ],
      ),
    );
  }
}
