import 'package:go_router/go_router.dart';
import 'package:pawnav/app/router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuthListener {
  static void initialize() {
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final event = data.event;
      final session = data.session;

      // Sadece log basılıyor, navigation yok.
      print("Auth event: $event");
      print("Session: $session");
    });
  }
}


