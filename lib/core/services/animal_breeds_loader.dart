import 'dart:convert';
import 'package:flutter/services.dart';

class AnimalBreedsLoader {
  static Map<String, List<String>>? _cache;

  static Future<Map<String, List<String>>> load() async {
    if (_cache != null) return _cache!;

    final jsonStr =
    await rootBundle.loadString('assets/data/animal_breeds.json');
    final Map<String, dynamic> decoded = json.decode(jsonStr);

    _cache = decoded.map(
          (key, value) => MapEntry(key, List<String>.from(value)),
    );

    return _cache!;
  }
}
