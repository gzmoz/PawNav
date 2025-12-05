import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class LocationService {
  static final String apiKey = dotenv.env['GOOGLE_MAPS_API_KEY']!;

  /// ---------------------- 1) ADRES → KOORDİNAT ----------------------
  static Future<String> getAddressFromLatLng(double lat, double lng) async {
    try {
      final placemarks = await placemarkFromCoordinates(lat, lng);

      if (placemarks.isEmpty) {
        return "$lat, $lng";
      }

      final p = placemarks.first;

      return "${p.thoroughfare}, ${p.subLocality}, ${p.locality}, ${p.administrativeArea}";
    } catch (e) {
      print("Geocoding error: $e");
      return "$lat, $lng";
    }
  }

  /// ---------------------- 2) AUTOCOMPLETE ----------------------
  static Future<List<dynamic>> placeAutoComplete(String query) async {
    if (query.isEmpty) return [];

    final url = Uri.https(
      "maps.googleapis.com",
      "/maps/api/place/autocomplete/json",
      {
        "input": query,
        "key": apiKey,
        "components": "country:tr",
      },
    );

    try {
      final response = await http.get(url);
      final json = jsonDecode(response.body);

      return json["predictions"] ?? [];
    } catch (e) {
      print("Autocomplete error: $e");
      return [];
    }
  }

  /// ---------------------- 3) PLACE DETAILS → KOORDİNAT ----------------------
  static Future<LatLng?> placeDetailsToLatLng(String placeId) async {
    final url = Uri.https(
      "maps.googleapis.com",
      "/maps/api/place/details/json",
      {
        "place_id": placeId,
        "key": apiKey,
        "fields": "geometry",
      },
    );

    try {
      final resp = await http.get(url);
      final json = jsonDecode(resp.body);

      final location = json["result"]["geometry"]["location"];
      final lat = location["lat"];
      final lng = location["lng"];

      return LatLng(lat, lng);
    } catch (e) {
      print("Place details error: $e");
      return null;
    }
  }

  /// ---------------------- 4) KULLANICI MEVCUT KONUM ----------------------
  static Future<Position?> getCurrentLocation() async {
    try {
      final permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        await Geolocator.requestPermission();
      }

      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      print("Location error: $e");
      return null;
    }
  }
}
