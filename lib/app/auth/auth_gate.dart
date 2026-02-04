import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatefulWidget {
  final Widget child;
  const AuthGate({super.key, required this.child});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  late final StreamSubscription<AuthState> _authSub;
  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();

    _authSub = supabase.auth.onAuthStateChange.listen(
          (data) async {
        final session = data.session;
        if (session == null) return;

        await _ensureProfileGenerated(session.user);
      },
    );
  }

  @override
  void dispose() {
    _authSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
Future<void> _ensureProfileGenerated(User user) async {
  final supabase = Supabase.instance.client;

  // 1) Profil var mı?
  final existing = await supabase
      .from('profiles')
      .select('id')
      .eq('id', user.id)
      .maybeSingle();

  if (existing != null) return;

  // 2) Name üret
  String name =
      user.userMetadata?['full_name'] ??
          user.email?.split('@')[0] ??
          'New User';

  name = name.trim();

  // 3) Username base
  String baseUsername = name
      .toLowerCase()
      .replaceAll(' ', '_')
      .replaceAll(RegExp(r'[^a-z0-9_]'), '');

  if (baseUsername.isEmpty) {
    baseUsername = 'user';
  }

  // 4) Unique username üret
  String username =
      '$baseUsername${DateTime.now().millisecondsSinceEpoch % 10000}';

  bool isUnique = false;

  while (!isUnique) {
    final check = await supabase
        .from('profiles')
        .select('id')
        .eq('username', username)
        .maybeSingle();

    if (check == null) {
      isUnique = true;
    } else {
      username =
      '$baseUsername${(DateTime.now().millisecondsSinceEpoch ~/ 2) % 10000}';
    }
  }

  // 5) Profiles insert
  await supabase.from('profiles').insert({
    'id': user.id,
    'email': user.email,
    'name': name,
    'username': username,
    'photo_url': user.userMetadata?['avatar_url'],
    'created_at': DateTime.now().toIso8601String(),
  });
}

