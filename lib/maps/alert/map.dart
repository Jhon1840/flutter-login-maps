import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image/image.dart' as img;
import 'package:untitled3/maps/alert/adminalert.dart';
import 'package:untitled3/maps/alert/alert_dialog.dart';
import 'package:untitled3/maps/alert/user/admin.dart';
import 'navbar.dart'; // Asegúrate de usar la ruta correcta a tu archivo navbar.dart
import 'load_alerts.dart'; // Asegúrate de usar la ruta correcta a tu archivo load_alerts.dart

class MapCreate extends StatefulWidget {
  const MapCreate({Key? key}) : super(key: key);

  @override
  _MapCreateState createState() => _MapCreateState();
}

class _MapCreateState extends State<MapCreate> {
  late GoogleMapController mapController;
  Location location = Location();
  Set<Marker> _markers = {};
  bool _alertMode = false;
  Future<void>? _addMarkerFuture;

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;

    LocationData currentLocation = await location.getLocation();
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
            target:
                LatLng(currentLocation.latitude!, currentLocation.longitude!),
            zoom: 15),
      ),
    );
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId('myLocation'),
          position:
              LatLng(currentLocation.latitude!, currentLocation.longitude!),
        ),
      );
    });
    Set<Marker> alertMarkers = await loadAlerts();
    debugPrint(
        'Alert Markers: $alertMarkers'); // Agregar esta línea para imprimir los marcadores
    setState(() {
      _markers.addAll(alertMarkers);
    });
  }

  void _onMapTapped(LatLng position) async {
    if (_alertMode) {
      final type = await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialogScreen(position: position);
        },
      );
      BitmapDescriptor icon;
      switch (type) {
        case 'Incendio':
          icon = BitmapDescriptor.fromBytes(
              await _getProcessedAsset('assets/incendioo.png'));
          break;
        case 'Bloqueo':
          icon = BitmapDescriptor.fromBytes(
              await _getProcessedAsset('assets/bloqueo.png'));
          break;
        case 'Choque':
          icon = BitmapDescriptor.fromBytes(
              await _getProcessedAsset('assets/choque.png'));
          break;
        default:
          icon = BitmapDescriptor.defaultMarker;
      }
      _addMarkerFuture = _addMarker(position, icon);
      _alertMode = false;
    }
  }

  Future<void> _addMarker(LatLng position, BitmapDescriptor icon) async {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId(position.toString()),
          position: position,
          icon: icon,
        ),
      );
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomNavBar(),
      body: Stack(
        children: [
          FutureBuilder(
            future: _addMarkerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else {
                return GoogleMap(
                  onMapCreated: _onMapCreated,
                  markers: _markers,
                  initialCameraPosition: CameraPosition(
                    target: const LatLng(0, 0),
                    zoom: 3,
                  ),
                  onTap: _onMapTapped,
                );
              }
            },
          ),
          FutureBuilder<bool>(
            future: isAdmin(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(); // No muestra nada mientras espera
              } else if (snapshot.hasData && snapshot.data!) {
                return Positioned(
                  bottom: 16.0,
                  left: 16.0,
                  child: FloatingActionButton(
                    child: Text('Edit'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EditAlert()),
                      );
                    },
                  ),
                );
              } else {
                return Container(); // No muestra nada si el usuario no es admin
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(_alertMode ? Icons.dangerous : Icons.dangerous_outlined),
        onPressed: () {
          setState(() {
            _alertMode = !_alertMode;
          });
        },
      ),
    );
  }
}
