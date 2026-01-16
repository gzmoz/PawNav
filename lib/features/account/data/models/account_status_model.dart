class AccountStats {
  final int listings;
  final int saved;
  final int successes;

  AccountStats({
    required this.listings,
    required this.saved,
    required this.successes,
  });

  factory AccountStats.fromMap(Map<String, dynamic> map) {
    return AccountStats(
      listings: map['listings_count'],
      saved: map['saved_count'],
      successes: map['success_count'],
    );
  }
}
