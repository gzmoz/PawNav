import 'package:supabase_flutter/supabase_flutter.dart';

class ChatRemoteDataSource {
  final SupabaseClient supabase;

  ChatRemoteDataSource(this.supabase);

  Future<List<Map<String, dynamic>>> getChats() async {
    final res = await supabase.rpc('get_user_chats');
    return List<Map<String, dynamic>>.from(res);
  }
}
