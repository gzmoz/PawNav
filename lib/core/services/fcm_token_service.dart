import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FcmTokenService {
  static final _messaging = FirebaseMessaging.instance;
  static final _supabase = Supabase.instance.client;

  static Future<void> init() async {
    debugPrint(" FCM INIT START");

    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    debugPrint(" FCM PERMISSION: ${settings.authorizationStatus}");

    await Future.delayed(const Duration(seconds: 1));

    final token = await _messaging.getToken();
    debugPrint(" FCM TOKEN: $token");

    if (token != null) {
      await save(token);
    } else {
      debugPrint(" TOKEN IS NULL");
    }

    _messaging.onTokenRefresh.listen((token) async {
      debugPrint("TOKEN REFRESH: $token");
      await save(token);
    });
  }

  static Future<void> save(String token) async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      debugPrint(" NO USER FOR TOKEN SAVE");
      return;
    }

    await _supabase
        .from('profiles')
        .update({'fcm_token': token})
        .eq('id', user.id);

    debugPrint(" FCM TOKEN SAVED TO SUPABASE");
  }
}

/*class FcmTokenService {
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
}*/
