import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MiniGoogleMap extends StatelessWidget {
  final LatLng latLng;
  final double zoom;

  const MiniGoogleMap({
    super.key,
    required this.latLng,
    this.zoom = 15,
  });

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: latLng,
        zoom: zoom,
      ),
      markers: {
        Marker(
          markerId: const MarkerId("location"),
          position: latLng,
        ),
      },
      zoomControlsEnabled: false,
      myLocationButtonEnabled: false,
      myLocationEnabled: false,
      compassEnabled: false,
      mapToolbarEnabled: false,
      rotateGesturesEnabled: false,
      scrollGesturesEnabled: false,
      zoomGesturesEnabled: false,
      tiltGesturesEnabled: false,
      onMapCreated: (_) {},
    );
  }
}
