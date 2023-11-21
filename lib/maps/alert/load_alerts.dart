import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image/image.dart' as img;

Future<Set<Marker>> loadAlerts() async {
  QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('alertas').get();
  Set<Marker> markers = {};

  for (var doc in querySnapshot.docs) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    GeoPoint position = data['position'];
    String type = data['type'];
    BitmapDescriptor icon = BitmapDescriptor.defaultMarker;

    if (type == 'Incendio') {
      icon = BitmapDescriptor.fromBytes(
          await _getProcessedAsset('assets/incendioo.png'));
    } else if (type == 'Bloqueo') {
      icon = BitmapDescriptor.fromBytes(
          await _getProcessedAsset('assets/bloqueo.png'));
    } else if (type == 'Choque') {
      icon = BitmapDescriptor.fromBytes(
          await _getProcessedAsset('assets/choque.png'));
    }

    if (position != null && type != null) {
      Marker marker = Marker(
        markerId: MarkerId(doc.id),
        position: LatLng(position.latitude, position.longitude),
        icon: icon,
      );

      markers.add(marker);
    }
  }

  return markers;
}

Future<Uint8List> _getProcessedAsset(String path) async {
  ByteData data = await rootBundle.load(path);
  Uint8List list = data.buffer.asUint8List();

  // Compress the image
  list = await FlutterImageCompress.compressWithList(
    list,
    minWidth: 100,
    minHeight: 100,
    quality: 75,
  );

  // Make the image circular
  img.Image? image = img.decodeImage(list);
  if (image != null) {
    int radius = image.width ~/ 2;
    img.Image circularImage = img.Image(radius * 2, radius * 2);

    img.fill(circularImage, img.getColor(0, 0, 0, 0));

    img.drawCircle(
      circularImage,
      radius,
      radius,
      radius,
      img.getColor(255, 255, 255),
    );

    img.copyInto(
      circularImage,
      image,
      dstX: radius - image.width ~/ 2,
      dstY: radius - image.height ~/ 2,
    );

    list = Uint8List.fromList(img.encodePng(circularImage));
  }

  return list;
}
