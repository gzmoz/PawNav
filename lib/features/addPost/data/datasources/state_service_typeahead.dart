import 'dart:convert';
import 'package:http/http.dart' as http;

class LocationService {
  Future<List<String>> search(String query) async {
    if (query.isEmpty || query.length < 3) return []; //Eğer kullanıcı 3 harften az yazdıysa API çağrısı yapılmaz

    final url = "https://photon.komoot.io/api/?q=$query&lang=en";

    final response = await http.get(Uri.parse(url)); //api'ye istek atılır, json doner.

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body); //jsonu Dart map'e cevirir
      final List features = body["features"];

      // Clean + remove duplicates
      final results = features.map((item) {
        final props = item["properties"];

        final parts = [
          props["name"],
          props["district"] ?? props["city"] ?? props["county"],
          props["state"],
          props["country"],
        ];

        final clean = parts
            .where((e) => e != null && e.toString().trim().isNotEmpty) //null veya boş değerler atılır.
            .join(", "); //Tek bir satırda birleştir

        return clean;
      }).toSet().toList(); // all duplicates removed

      return results;
    }

    return [];
  }
}



