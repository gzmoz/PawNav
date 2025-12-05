import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pawnav/app/theme/colors.dart';
import 'package:pawnav/core/services/location_service.dart';
import 'package:pawnav/core/services/permission_service.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final TextEditingController _searchController = TextEditingController();
  final apiKey = dotenv.env['GOOGLE_MAPS_API_KEY']!;
  Set<Marker> markers = {};

  final PermissionService permissionService = PermissionService();


  GoogleMapController? _mapController;

  final LatLng _initialCenter = const LatLng(39.9208, 32.8541);
  LatLng? _cameraTarget; // kamera ortası
  LatLng? selectedPoint; // seçilen nokta
  String? selectedTitle;
  String? selectedAddress;

  List<dynamic> placeResults = [];

  @override
  Widget build(BuildContext context) {
    final screenInfo = MediaQuery.of(context);
    final double height = screenInfo.size.height;
    final double width = screenInfo.size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Map"),
        centerTitle: true,
        backgroundColor: Colors.white,
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
                  // showBottomCard = true;
                });

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
              myLocationButtonEnabled: false,
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
          Positioned(
            top: 20,
            left: 16,
            right: 16,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) async {
                      final results = await LocationService.placeAutoComplete(value);
                      setState(() => placeResults = results);
                    },
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: "Search by address or city",
                      hintStyle: const TextStyle(color: Colors.grey),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Colors.grey,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),


                //filter button
                GestureDetector(
                  // onTap: () {},
                  onTap: () => _showFilters(context),
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.tune_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
              ],
            ),
          ),

          if (placeResults.isNotEmpty)
            Positioned(
              top: 80,
              left: 20,
              right: 20,
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.35,
                ),
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
                  itemCount: placeResults.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final item = placeResults[index];

                    return ListTile(
                      leading: const Icon(Icons.location_on, color: Colors.grey),
                      title: Text(item["description"]),
                      onTap: () async {
                        // KLAVYEYİ KAPAT
                        FocusScope.of(context).unfocus();

                        final coords = await LocationService
                            .placeDetailsToLatLng(item["place_id"]);

                        if (coords == null) return;

                        // HARİTAYA GİT
                        _mapController?.animateCamera(
                          CameraUpdate.newLatLngZoom(coords, 15),
                        );

                        // MARKER KOY
                        setState(() {
                          markers.clear();
                          markers.add(Marker(
                            markerId: MarkerId("selectedPlace"),
                            position: coords,
                          ));

                          selectedPoint = coords;
                          selectedAddress = item["description"];
                          selectedTitle =
                              item["structured_formatting"]?["main_text"] ?? "";
                          _searchController.text = selectedAddress!;

                          placeResults = []; // listeyi kapat
                        });
                      },
                    );
                  },
                ),
              ),
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
        ],
      ),
    );
  }


  void _showFilters(BuildContext context) {
    final screenInfo = MediaQuery.of(context);
    final double height = screenInfo.size.height;
    final double width = screenInfo.size.width;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      builder: (BuildContext context) {
        String selectedPostType = "Lost";
        double radiusValue = 10;
        String selectedAnimal = "Dog";
        String selectedBreed = "Any";
        final TextEditingController locationController =
            TextEditingController();

        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 50,
            top: 10,
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      //drag indicator
                      Center(
                        child: Container(
                          width: width * 0.2,
                          height: 2,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade400,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Filters",
                            style: TextStyle(
                              fontSize: width * 0.05,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              context.pop();
                            },
                            icon: const Icon(Icons.close),
                          ),
                        ],
                      ),

                      Divider(
                        color: Colors.grey.shade300,
                        height: 1,
                      ),

                      const SizedBox(height: 15),

                      Text(
                        "Post Type",
                        style: TextStyle(
                          fontSize: width * 0.042,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        "Select one or more post types.",
                        style: TextStyle(
                            color: Colors.grey, fontSize: width * 0.033),
                      ),

                      const SizedBox(height: 12),

                      Center(
                        child: Wrap(
                          spacing: 10,
                          children: ["Lost", "Found", "Adoption"].map((type) {
                            final isSelected = selectedPostType == type;

                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedPostType = type;
                                });
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 22, vertical: 10),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.blueAccent
                                      : const Color(0xFFF3F4F6),
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: isSelected
                                      ? [
                                          BoxShadow(
                                            color: Colors.blue.withOpacity(0.25),
                                            blurRadius: 6,
                                            offset: const Offset(0, 2),
                                          )
                                        ]
                                      : [],
                                ),
                                child: Text(
                                  type,
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black87,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),

                      const SizedBox(height: 20),

                      Text(
                        "Location Filter",
                        style: TextStyle(
                          fontSize: width * 0.042,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 8),

                      TextField(
                        controller: locationController,
                        decoration: InputDecoration(
                          hintText: "Enter city or postcode",
                          prefixIcon: const Icon(Icons.search),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 23),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Radius: ',
                              style: TextStyle(
                                fontSize: width * 0.042,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: '${radiusValue.toStringAsFixed(0)} km',
                              style: TextStyle(
                                  fontSize: width * 0.042,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blueAccent),
                            ),
                          ],
                        ),
                      ),
                      Slider(
                        value: radiusValue,
                        min: 1,
                        max: 100,
                        activeColor: Colors.blueAccent,
                        onChanged: (val) {
                          setState(() {
                            radiusValue = val;
                          });
                        },
                      ),

                      const SizedBox(height: 10),

                      Text(
                        "Animal Details",
                        style: TextStyle(
                          fontSize: width * 0.042,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 8),

                      //animal type
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 14),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(12)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.pets, color: Colors.grey),
                                const SizedBox(width: 12),
                                Text(
                                  "Animal Type",
                                  style: TextStyle(fontSize: width * 0.035),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: Row(
                                children: [
                                  Text(
                                    selectedAnimal,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  const Icon(Icons.chevron_right,
                                      color: Colors.grey),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 8),

                      //BREED
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 14),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(12)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.science, color: Colors.grey),
                                const SizedBox(width: 12),
                                Text(
                                  "Breed",
                                  style: TextStyle(fontSize: width * 0.035),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: Row(
                                children: [
                                  Text(
                                    selectedBreed,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  const Icon(Icons.chevron_right,
                                      color: Colors.grey),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 25),

                      Divider(color: Colors.grey.shade300, height: 1),
                      const SizedBox(height: 10),

                      //bottom buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          OutlinedButton(
                            onPressed: () {
                              setState(() {
                                selectedPostType = "";
                                selectedAnimal = "";
                                selectedBreed = "";
                                locationController.clear();
                                radiusValue = 10;
                              });
                            },
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              side: const BorderSide(color: AppColors.primary),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                            ),
                            child: const Text(
                              "Reset Filters",
                              style: TextStyle(color: AppColors.primary),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              context.pop({
                                "postType": selectedPostType,
                                "location": locationController.text,
                                "radius": radiusValue,
                                "animal": selectedAnimal,
                                "breed": selectedBreed,
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                            ),
                            child: const Text(
                              "Apply Filters",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
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
  }


}
