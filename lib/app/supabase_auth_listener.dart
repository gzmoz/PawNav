import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:pawnav/app/router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


// AuthListener yalnızca event loglasın
class SupabaseAuthListener {
  static void initialize() {
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final event = data.event;
      final session = data.session;

      // Sadece log basılıyor, navigation yok.
      print("Auth event: $event");
      print("Session: $session");

      // RESET PASSWORD
      if (event == AuthChangeEvent.passwordRecovery) {
        // Kullanıcı app'e geri geldi
        // Şifre reset ekranına yönlendir
        router.go('/reset_password');
      }

      // SIGNUP CONFIRMATION
      if (event == AuthChangeEvent.signedIn) {
        // Signup confirm link'e tıklandı → App açıldı
        router.go('/login');
      }


    });
  }
}


