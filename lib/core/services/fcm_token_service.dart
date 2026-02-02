import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FcmTokenService {
  static final _messaging = FirebaseMessaging.instance;
  static final _supabase = Supabase.instance.client;

  static Future<void> init() async {
    await _messaging.requestPermission();

    final token = await _messaging.getToken();
    if (token != null) {
      await save(token);
    }

    FirebaseMessaging.instance.onTokenRefresh.listen((token) async {
      await save(token);
    });
  }

  static Future<void> save(String token) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return;

      await _supabase
          .from('profiles')
          .update({
        'fcm_token': token,
      })
          .eq('id', user.id);


      debugPrint("✅ FCM token saved");
    } catch (e) {
      debugPrint("❌ FCM SAVE ERROR: $e");
    }
  }
}
