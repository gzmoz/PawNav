import 'package:supabase_flutter/supabase_flutter.dart';

class BadgeAwardService {
  final SupabaseClient _client = Supabase.instance.client;

  //checkAndAward = “kontrol et ve gerekirse ver”
  Future<void> checkAndAward({
    required String badgeId, //Hangi badge’i vermeye çalıştığım
  }) async {
    final userId = _client.auth.currentUser!.id;

    // “var mı yok mu” kontrolü
    final existing = await _client
    .from('user_badges')
    .select('id')
    .eq('user_id', userId)
    .eq('badge_id', badgeId);

    //aynı badge tekrar tekrar eklenmez
    if(existing.isNotEmpty){
      return;
    }

    //yoksa badge’i ekle
    await _client.from('user_badges').insert({
      'user_id': userId,
      'badge_id': badgeId,
      'earned_at': DateTime.now().toIso8601String(),
    });


  }
}
