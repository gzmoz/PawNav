import 'dart:convert';
import 'package:flutter/services.dart';

class JsonService {
  static Future<Map<String, List<String>>> load(String path) async {
    final jsonString = await rootBundle.loadString(path);
    final Map<String, dynamic> decoded = json.decode(jsonString);

    final Map<String, List<String>> result = {};

    decoded.forEach((key, value) {
      /*key   = "Dog"
      value = ["Akita", "Beagle"]*/
      final list = value as List;
      result[key] = list.map((e) => e.toString()).toList();
      /*Listeyi tek tek dolaşır
      Her elemanı String’e çevirir
      Yeni bir List<String> oluşturur*/
    });

    return result;
  }
}
