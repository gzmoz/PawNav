import 'package:go_router/go_router.dart';
import 'package:pawnav/app/router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuthListener {
  static void initialize() {
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final event = data.event;
      final session = data.session;

      if (event == AuthChangeEvent.signedIn && session != null) {
        // Login başarılı → Home ekranına gönder
        router.go('/home');
      }

      if (event == AuthChangeEvent.signedOut) {
        // Logout → Login ekranına dön
        router.go('/login');
      }
    });
  }
}
