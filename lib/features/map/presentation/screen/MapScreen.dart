import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pawnav/app/theme/colors.dart';
import 'package:pawnav/core/services/animal_breeds_loader.dart';
import 'package:pawnav/core/services/location_service.dart';
import 'package:pawnav/core/services/permission_service.dart';
import 'package:pawnav/features/badges/presentation/widget/badge_unlocked_modal.dart';
import 'package:pawnav/features/map/domain/entities/map_filter.dart';
import 'package:pawnav/features/map/presentation/widgets/create_marker_icon.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:pawnav/features/map/presentation/cubit/map_cubit.dart';
import 'package:pawnav/features/map/presentation/cubit/map_state.dart';
import 'package:pawnav/features/map/domain/entities/map_post.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final TextEditingController _searchController = TextEditingController();
  final apiKey = dotenv.env['GOOGLE_MAPS_API_KEY']!;

  final PermissionService permissionService = PermissionService();

  GoogleMapController? _mapController;

  final LatLng _initialCenter = const LatLng(39.9208, 32.8541);
  LatLng? _cameraTarget; // kamera ortası

  // --- mevcut seçimler (UI için) ---
  LatLng? selectedPoint; // seçilen nokta (arama veya tıklama)
  String? selectedTitle;
  String? selectedAddress;

  static const List<String> animalTypes = [
    "Any",
    "Dog",
    "Cat",
    "Bird",
    "Rabbit",
    "Rodent",
    "Reptile",
    "Other",
  ];


  // Haritadaki post marker'ları Cubit'ten gelecek.
  // "selected" marker'ını ise bu sayfada tutup Cubit marker'ları ile birleştir.
  Marker? _selectedMarker;

  List<dynamic> placeResults = [];

  String _selectedPostType = "Any";
  double _radiusKm = 10;
  String _selectedAnimal = "Any";
  String _selectedBreed = "Any";

  BitmapDescriptor? _petMarkerIcon;

  Future<String?> _showBreedPicker(
      BuildContext context, {
        required String selectedAnimal,
        required String selectedBreed,
      }) async {
    // Any seçiliyse breed seçtirmiyoruz
    if (selectedAnimal == "Any") return "Any";

    final breedsMap = await AnimalBreedsLoader.load();
    final breeds = breedsMap[selectedAnimal] ?? [];

    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            child: Column(
              children: [
                // drag indicator
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                const Text(
                  "Select Breed",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 16),

                Expanded(
                  child: ListView(
                    children: [
                      // Any seçeneği
                      _BreedTile(
                        label: "Any",
                        isSelected: selectedBreed == "Any",
                        onTap: () => Navigator.pop(context, "Any"),
                      ),

                      ...breeds.map((breed) {
                        return _BreedTile(
                          label: breed,
                          isSelected: selectedBreed == breed,
                          onTap: () => Navigator.pop(context, breed),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  Future<String?> _showAnimalPicker(
      BuildContext context,
      String selectedAnimal,
      ) {
    return showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // drag indicator
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              const Text(
                "Select Animal Type",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 16),

              Expanded(
                child: ListView(
                  children: animalTypes.map((animal) {
                    return _AnimalTile(
                      label: animal,
                      isSelected: selectedAnimal == animal,
                      onTap: () => Navigator.pop(context, animal),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }


  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await handleExplorerBadge(context);

      context.read<MapCubit>().loadNearby(
        lat: _initialCenter.latitude,
        lon: _initialCenter.longitude,
        radiusKm: _radiusKm,
        // TODO: MapCubit'in loadNearby'sine filter parametresi eklediysen burada gönder.
        // postType: _selectedPostType,
        // animal: _selectedAnimal,
        // breed: _selectedBreed == "Any" ? null : _selectedBreed,
      );
    });

    _initMarker();

  }

  Future<void> _initMarker() async {
    _petMarkerIcon = await createPetMarkerIcon(
      bgColor: Colors.red,
      iconColor: Colors.white,
      size: 110,
    );
    setState(() {});
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  LatLng? _lastFetchCenter;

  void _reloadPostsFromCenter() {
    final center = _cameraTarget ?? selectedPoint ?? _initialCenter;

    if (_lastFetchCenter != null) {
      final distance = Geolocator.distanceBetween(
        _lastFetchCenter!.latitude,
        _lastFetchCenter!.longitude,
        center.latitude,
        center.longitude,
      );

      // 300 metreden az hareket → reload yok
      if (distance < 300) return;
    }

    _lastFetchCenter = center;

    context.read<MapCubit>().loadNearby(
      lat: center.latitude,
      lon: center.longitude,
      radiusKm: _radiusKm,
      filter: MapFilter(
        postType: _selectedPostType == "Any" ? null : _selectedPostType,
        animal: _selectedAnimal == "Any" ? null : _selectedAnimal,
        breed: _selectedBreed == "Any" ? null : _selectedBreed,
      ),
    );
  }


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
          BlocBuilder<MapCubit, MapState>(
            builder: (context, state) {
              // 1) Cubit'ten gelen post marker set'i
              final Set<Marker> cubitMarkers = {};

              if (state is MapLoaded) {
                for (final post in state.posts) {
                  cubitMarkers.add(
                    Marker(
                      markerId: MarkerId(post.id),
                      position: LatLng(post.lat, post.lon),
                      icon: _petMarkerIcon ?? BitmapDescriptor.defaultMarker,
                      onTap: () {
                        context.read<MapCubit>().selectPost(post);
                      },
                    ),

                  );
                }
              }

              // 2) UI'da seçilen nokta marker'ı (arama/tap)
              if (_selectedMarker != null) {
                cubitMarkers.add(_selectedMarker!);
              }

              return SizedBox.expand(
                child: GoogleMap(
                  markers: cubitMarkers,
                  padding:
                  const EdgeInsets.only(bottom: 150, right: 10, left: 10),
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
                    //_reloadPostsFromCenter();
                  },
                ),
              );
            },
          ),

          Positioned(
            top: 20,
            left: 16,
            right: 16,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) async {
                      final results =
                      await LocationService.placeAutoComplete(value);
                      setState(() => placeResults = results);
                    },
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: "Search by address or city",
                      hintStyle: const TextStyle(color: Colors.grey),
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
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

                // filter button
                GestureDetector(
                  onTap: () => _showFilters(context),
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      color: Color(0xFF3C59C7),
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
                      leading:
                      const Icon(Icons.location_on, color: Colors.grey),
                      title: Text(item["description"]),
                      onTap: () async {
                        FocusScope.of(context).unfocus();

                        final coords =
                        await LocationService.placeDetailsToLatLng(
                          item["place_id"],
                        );
                        if (coords == null) return;

                        _mapController?.animateCamera(
                          CameraUpdate.newLatLngZoom(coords, 15),
                        );

                        setState(() {
                          _selectedMarker = Marker(
                            markerId: const MarkerId("selectedPlace"),
                            position: coords,
                          );

                          selectedPoint = coords;
                          selectedAddress = item["description"];
                          selectedTitle =
                              item["structured_formatting"]?["main_text"] ?? "";
                          _searchController.text = selectedAddress!;
                          placeResults = [];
                        });

                        _cameraTarget = coords;
                        _reloadPostsFromCenter();
                      },
                    );
                  },
                ),
              ),
            ),

          Positioned(
            bottom: 250,
            right: 15,
            child: FloatingActionButton(
              backgroundColor: const Color(0xFF3C59C7),
              mini: true,
              onPressed: () async {
                await _requestInitialLocationPermission();

                _reloadPostsFromCenter();
              },
              child: const Icon(Icons.my_location, color: Colors.white),
            ),
          ),

          BlocBuilder<MapCubit, MapState>(
            builder: (context, state) {
              if (state is! MapLoaded) return const SizedBox.shrink();
              final selected = state.selectedPost;
              if (selected == null) return const SizedBox.shrink();

              return Positioned(
                left: 0,
                right: 0,
                bottom: 16,
                child: _PostPreviewBottomSheet(
                  post: selected,
                  onClose: () => context.read<MapCubit>().clearSelection(),
                  onViewDetails: () {
                    context.push('/post-detail/${selected.id}');
                  },
                ),
              );
            },
          ),

          BlocBuilder<MapCubit, MapState>(
            builder: (context, state) {
              if (state is MapLoading) {
                return const Positioned(
                  top: 90,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: SizedBox(
                      height: 28,
                      width: 28,
                      child: CircularProgressIndicator(strokeWidth: 2.5),
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),

          BlocBuilder<MapCubit, MapState>(
            builder: (context, state) {
              if (state is MapError) {
                return Positioned(
                  top: 90,
                  left: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red.withOpacity(0.25)),
                    ),
                    child: Text(
                      state.message,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  void _showFilters(BuildContext context) {
    final screenInfo = MediaQuery.of(context);
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
      builder: (BuildContext sheetContext) {
        String selectedPostType = _selectedPostType;
        double radiusValue = _radiusKm;
        String selectedAnimal = _selectedAnimal;
        String selectedBreed = _selectedBreed;

        final TextEditingController locationController = TextEditingController(
          text: selectedAddress ?? "",
        );

        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 50,
            top: 10,
          ),
          child: StatefulBuilder(
            builder: (context, setModalState) {
              return Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
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
                            onPressed: () => sheetContext.pop(),
                            icon: const Icon(Icons.close),
                          ),
                        ],
                      ),

                      Divider(color: Colors.grey.shade300, height: 1),
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
                        "Select one post type.",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: width * 0.033,
                        ),
                      ),
                      const SizedBox(height: 12),

                      Center(
                        child: Wrap(
                          spacing: 10,
                          children: ["Lost", "Found", "Adoption"].map((type) {
                            final isSelected = selectedPostType == type;

                            return GestureDetector(
                              onTap: () {
                                setModalState(() {
                                  selectedPostType = type;
                                });
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 22,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.blueAccent
                                      : const Color(0xFFF3F4F6),
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: isSelected
                                      ? [
                                    BoxShadow(
                                      color:
                                      Colors.blue.withOpacity(0.25),
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

                      const SizedBox(height: 30),

                      Text(
                        "Animal Details (optional)",
                        style: TextStyle(
                          fontSize: width * 0.042,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // ⚠️ Şu an animal/breed seçim UI'da duruyor.
                      // Eğer Supabase RPC tarafında filtreleyeceksen MapCubit->Repo->RPC'ye parametre ekle.
                      _SimpleRowField(
                        icon: Icons.pets,
                        label: "Animal Type",
                        value: selectedAnimal,
                        onTap: () async {
                          final picked = await _showAnimalPicker(
                            sheetContext,
                            selectedAnimal,
                          );

                          if (picked != null) {
                            setModalState(() {
                              selectedAnimal = picked;
                              selectedBreed = "Any";
                              selectedBreed = "Any";
                            });
                          }
                        },
                      ),

                      const SizedBox(height: 8),
                      _SimpleRowField(
                        icon: Icons.science,
                        label: "Breed",
                        value: selectedBreed,
                        onTap: () async {
                          final picked = await _showBreedPicker(
                            sheetContext,
                            selectedAnimal: selectedAnimal,
                            selectedBreed: selectedBreed,
                          );

                          if (picked != null) {
                            setModalState(() {
                              selectedBreed = picked;
                            });
                          }
                        },
                      ),


                      const SizedBox(height: 25),
                      Divider(color: Colors.grey.shade300, height: 1),
                      const SizedBox(height: 10),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          OutlinedButton(
                            onPressed: () {
                              setModalState(() {
                                selectedPostType = "Any";
                                selectedAnimal = "Any";
                                selectedBreed = "Any";
                                radiusValue = 10;

                              });
                            },
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              side: const BorderSide(color: AppColors.primary),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                            ),
                            child: const Text(
                              "Reset Filters",
                              style: TextStyle(color: AppColors.primary),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _selectedPostType = selectedPostType;
                                _radiusKm = radiusValue;
                                _selectedAnimal = selectedAnimal;
                                _selectedBreed = selectedBreed;

                                _lastFetchCenter = null;
                              });

                              sheetContext.pop();
                              _reloadPostsFromCenter();
                            },

                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
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
    if (!allowed) return;

    final pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    final LatLng current = LatLng(pos.latitude, pos.longitude);

    _cameraTarget = current;

    if (_mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(current, 15),
      );
    }
  }

  Future<void> handleExplorerBadge(BuildContext context) async {
    final supabase = Supabase.instance.client;
    final uid = supabase.auth.currentUser!.id;

    await supabase.rpc('inc_map_open');

    final stats = await supabase
        .from('user_stats')
        .select('map_open_count')
        .eq('user_id', uid)
        .maybeSingle();

    final mapCount = (stats?['map_open_count'] as int?) ?? 0;

    if (mapCount != 1) return;

    final badgeRow = await supabase
        .from('badges')
        .select('name, description, icon_url')
        .eq('key', 'explorer')
        .maybeSingle();

    if (badgeRow == null || !context.mounted) return;

    await showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.55),
      builder: (_) => BadgeUnlockedModal(
        title: badgeRow['name'] as String? ?? 'Badge Unlocked',
        message: badgeRow['description'] as String? ?? '',
        iconUrl: badgeRow['icon_url'] as String? ?? '',
        onContinue: () => Navigator.pop(context),
        onViewBadges: () {
          Navigator.pop(context);
          context.push('/badges');
        },
        earned: true,
      ),
    );
  }
}

// altta çıkan post preview card
class _PostPreviewBottomSheet extends StatelessWidget {
  final MapPost post;
  final VoidCallback onClose;
  final VoidCallback onViewDetails;

  const _PostPreviewBottomSheet({
    required this.post,
    required this.onClose,
    required this.onViewDetails,
  });

  String _labelFromType(String type) {
    final t = type.toLowerCase();
    if (t == "lost") return "LOST";
    if (t == "found") return "FOUND";
    if (t == "adoption") return "ADOPTION";
    return type.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = post.images.isNotEmpty ? post.images.first : null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sol içerik
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFE7E7),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                _labelFromType(post.postType),
                                style: const TextStyle(
                                  color: Color(0xFFE53935),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: onClose,
                              icon: const Icon(Icons.close),
                              visualDensity: VisualDensity.compact,
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          post.name ?? "Unknown",
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.location_on,
                                size: 18, color: Colors.grey),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                post.location,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: onViewDetails,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF3C59C7),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: const Text(
                              "View Details  ›",
                              style: TextStyle(
                                  color: Colors.white, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Sağ resim
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Container(
                          width: 110,
                          height: 150,
                          color: const Color(0xFFF2F2F6),
                          child: imageUrl == null
                              ? const Icon(Icons.pets, size: 34, color: Colors.grey)
                              : Image.network(imageUrl, fit: BoxFit.cover),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//  (animal/breed için)
class _SimpleRowField extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  const _SimpleRowField({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.grey),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              Text(
                value,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(width: 6),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnimalTile extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _AnimalTile({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Material(
        color: isSelected ? Colors.blueAccent.withOpacity(0.12) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        child: ListTile(
          title: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.blueAccent : Colors.black87,
            ),
          ),
          trailing: isSelected
              ? const Icon(Icons.check, color: Colors.blueAccent)
              : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}

class _BreedTile extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _BreedTile({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Material(
        color: isSelected ? Colors.blueAccent.withOpacity(0.12) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        child: ListTile(
          title: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.blueAccent : Colors.black87,
            ),
          ),
          trailing: isSelected
              ? const Icon(Icons.check, color: Colors.blueAccent)
              : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}

