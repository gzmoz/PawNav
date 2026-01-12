//ham veriyi Dart nesnesine dönüştüren yapı
class ProfileModel {
  final String id;
  final String? name;
  final String? username;
  final String? photoUrl;

  ProfileModel({
    required this.id,
    this.name,
    this.username,
    this.photoUrl,
  });

  //Bir Map’ten (JSON / Supabase response) ProfileModel üretmek
  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      id: map['id'] as String,
      name: map['name'] as String?,
      username: map['username'] as String?,
      photoUrl: map['photo_url'] as String?,
    );
  }

  //getter:
  // Dışarıdan değişken gibi görünen ama aslında bir fonksiyon olan yapı
  String get displayName => (name?.trim().isNotEmpty ?? false)
      ? name!.trim()
      : (username?.trim().isNotEmpty ?? false)
      ? username!.trim()
      : 'Unknown';
}
