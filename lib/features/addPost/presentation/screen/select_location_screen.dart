import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:pawnav/core/services/location_service.dart';
import 'package:pawnav/core/services/permission_service.dart';
import 'package:pawnav/features/addPost/presentation/widget/location_bottom_card.dart';

class SelectLocationScreen extends StatefulWidget {
  const SelectLocationScreen({super.key});

  @override
  State<SelectLocationScreen> createState() => _SelectLocationScreenState();
}

class _SelectLocationScreenState extends State<SelectLocationScreen> {
  final apiKey = dotenv.env['GOOGLE_MAPS_API_KEY']!;

  final PermissionService permissionService = PermissionService();
  GoogleMapController? _mapController;

  final LatLng _initialCenter = const LatLng(39.9208, 32.8541);
  LatLng? _cameraTarget; // kamera ortası
  LatLng? selectedPoint; // seçilen nokta
  String? selectedTitle;
  String? selectedAddress;

  bool showBottomCard = false;

  final TextEditingController searchCtrl = TextEditingController();
  Set<Marker> markers = {};
  List<dynamic> placeResults = [];

  @override
  Widget build(BuildContext context) {
    final screenInfo = MediaQuery.of(context);
    final double height = screenInfo.size.height;
    final double width = screenInfo.size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false, //klavye ekranı itmesin

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        title: Text(
          'Select Location',
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: width * 0.05),
        ),
      ),
      body: Stack(
        children: [
          SizedBox.expand(
            child: GoogleMap(
              markers: markers,
              onTap: (latLng) async {
                setState(() {
                  selectedPoint = latLng;

                  markers.clear(); // tek marker
                  markers.add(
                    Marker(
                      markerId: const MarkerId('selected'),
                      position: latLng,
                    ),
                  );
                  showBottomCard = true;
                });

              /*  final address = await _getAddressFromLatLng(
                    latLng.latitude, latLng.longitude);*/

                final address = await LocationService.getAddressFromLatLng(
                    latLng.latitude, latLng.longitude);

                setState(() {
                  selectedAddress = address;
                  selectedTitle = "Selected Location";
                });
              },
              padding: const EdgeInsets.only(bottom: 100, right: 10, left: 10),
              initialCameraPosition: CameraPosition(
                target: _initialCenter,
                zoom: 12,
              ),
              onMapCreated: (controller) {
                _mapController = controller;
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              onCameraMove: (position) {
                _cameraTarget = position.target;
              },
              onCameraIdle: () {
                // Kullanıcı haritayı oynatmayı bıraktığında tetiklenir
                selectedPoint = _cameraTarget;
                // Burada otomatik bottom card açmıyoruz, sen öyle istemiyorsun.
              },
            ),
          ),

          /*FlutterMap(
            options: const MapOptions(
              initialCenter: LatLng(39.9208, 32.8541),
              initialZoom: 12,
            ),
            children: [
              TileLayer(
                //haritanın görsel karo (tile) katmanı
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName:
                    'com.ozgzm.pawnav.pawnav', //  OSM için kibar olmak adına uygulama bilgisini iletiyoruz.
              ),
            ],
          ),*/

          /*----------SEARCH BAR-------------*/
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15, right: 15, left: 15),
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(30),
                  child: TextField(
                    controller: searchCtrl,
                    decoration: InputDecoration(
                      hintText: "Search for a place, address, or area...",
                      hintStyle: TextStyle(color: Colors.grey.shade600),
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (value) {
                      placeAutoComplete(value);
                    },
                  ),
                ),
              ),
              if (placeResults.isNotEmpty)
                Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.35,
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: placeResults.length,
                    itemBuilder: (context, index) {
                      final item = placeResults[index];

                      return ListTile(
                        leading: const Icon(Icons.location_on),
                        title: Text(item["description"]),
                        onTap: () async {
                          FocusScope.of(context).unfocus(); // ← KLAVYEYİ KAPAT
                          final placeId = item["place_id"];
                          final LatLng? coords = await getPlaceLatLng(placeId);

                          if (coords == null) return;

                          _mapController?.animateCamera(
                            CameraUpdate.newLatLngZoom(coords, 16),
                          );

                          setState(() {
                            selectedPoint = coords;
                            markers.clear();
                            markers.add(Marker(
                              markerId: MarkerId("autocomplete"),
                              position: coords,
                            ));

                            selectedTitle =
                                item["structured_formatting"]["main_text"];
                            selectedAddress = item["description"];
                            searchCtrl.text =
                                selectedAddress!; // search bar’a yaz
                            showBottomCard = true;

                            placeResults = []; // listeyi kapat
                          });
                        },
                      );
                    },
                  ),
                ),
            ],
          ),

          /*----------CURRENT LOCATION BUTTON-------------*/
          Positioned(
            bottom: 200,
            right: 15,
            child: FloatingActionButton(
              backgroundColor: Colors.white,
              mini: true,
              onPressed: () {
                _requestInitialLocationPermission();
              },
              child: const Icon(Icons.my_location, color: Colors.black),
            ),
          ),

          /*----------BOTTOM CARD-------------*/
          if (showBottomCard)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: BottomLocationCard(
                title: selectedTitle ?? "",
                address: selectedAddress ?? "",
                onConfirm: () {
                  /*Kullanıcı onay butonuna bastığında:
                        Mevcut sayfayı kapatır
                        Önceki ekrana aşağıdaki verileri döner*/
                  Navigator.pop(context, {
                    "address": selectedAddress,
                    "lat": selectedPoint!.latitude,
                    "lon": selectedPoint!.longitude,
                  });
                },
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _requestInitialLocationPermission() async {
    final allowed = await permissionService.requestLocationPermission();

    if (!allowed) {
      return;
    }

    // Location çek
    final pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    final LatLng current = LatLng(pos.latitude, pos.longitude);

    // Kamerayı hareket ettir
    if (_mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(current, 15),
      );
    }

    // Marker + bottom card aç
    setState(() async {
      selectedPoint = current;

      final address =
          await LocationService.getAddressFromLatLng(current.latitude, current.longitude);

      markers.clear();
      markers.add(
        Marker(
          markerId: const MarkerId('selected'),
          position: current,
        ),
      );
      showBottomCard = true;
      setState(() {
        selectedAddress = address;
        selectedTitle = "Current Location";
      });
    });
  }

  /*Future<String> _getAddressFromLatLng(double lat, double lng) async {
    try {
      final placemarks = await placemarkFromCoordinates(lat, lng);
      *//*[
        Placemark(
            street: "Atatürk Cd",
            subLocality: "Kadıköy",
            locality: "İstanbul",
            administrativeArea: "İstanbul"
        )
      ]*//*

      if (placemarks.isEmpty) {
        return "$lat, $lng";
      }

      //Listeden ilk adresi alıyorsun
      final p = placemarks.first;

      return "${p.thoroughfare}, ${p.subLocality}, ${p.locality}, ${p.administrativeArea}";
    } catch (e) {
      print("Geocoding error: $e");
      return "$lat, $lng";
    }
  }*/

  //kullanıcı her searchbara yazdıgında bu fonksiyon calısacak
  Future<void> placeAutoComplete(String query) async {
    if (query.isEmpty) {
      //Kullanıcı input’u silerse → öneri listesini temizle.
      setState(() {
        placeResults = [];
      });
    }

    final url = Uri.https(
      "maps.googleapis.com",
      "maps/api/place/autocomplete/json",
      {
        "input": query, //kullanıcınnın yazdıgı
        "key": apiKey,
      },
    );

    //http get request
    final response = await http.get(url);

    //Google’ın gönderdiği JSON cevabını Dart nesnesine çeviriyoruz.
    final data = jsonDecode(response.body);

    setState(() {
      placeResults = data["predictions"];
    });
  }

  //Autocomplete sonucundan gelen place_id ile koordinat almak için.
  Future<LatLng?> getPlaceLatLng(String placeId) async {
    final url = Uri.https(
      "maps.googleapis.com",
      "maps/api/place/details/json",
      {
        "place_id": placeId,
        "key": apiKey,
        "fields": "geometry",
      },
    );

    final resp = await http.get(url);
    final json = jsonDecode(resp.body);

    //Latitude ve longitude değerlerini JSON’dan çekiyoruz.
    final location = json["result"]["geometry"]["location"];
    final lat = location["lat"];
    final lng = location["lng"];

    return LatLng(lat, lng);
  }
}
