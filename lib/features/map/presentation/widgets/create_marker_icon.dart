import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<BitmapDescriptor> createPetMarkerIcon({
  Color bgColor = Colors.red,
  Color iconColor = Colors.white,
  double size = 120,
}) async {
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);

  final paint = Paint()..color = bgColor;

  // Daire arka plan
  canvas.drawCircle(
    Offset(size / 2, size / 2),
    size / 2,
    paint,
  );

  // Paw icon
  final textPainter = TextPainter(
    textDirection: TextDirection.ltr,
  );

  textPainter.text = TextSpan(
    text: String.fromCharCode(Icons.pets.codePoint),
    style: TextStyle(
      fontSize: size * 0.55,
      fontFamily: Icons.pets.fontFamily,
      color: iconColor,
    ),
  );

  textPainter.layout();
  textPainter.paint(
    canvas,
    Offset(
      (size - textPainter.width) / 2,
      (size - textPainter.height) / 2,
    ),
  );

  final image = await recorder
      .endRecording()
      .toImage(size.toInt(), size.toInt());

  final byteData =
  await image.toByteData(format: ui.ImageByteFormat.png);

  return BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List());
}
