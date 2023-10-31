import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:untitled3/maps/const.dart';
import 'package:location/location.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  List<String> listitems = ["Choque", "Incendio", "Bloqueo"];
  String selectval = "Choque";

  Location _locationController = new Location();

  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();

  static const LatLng _pGooglePlex = LatLng(37.4223, -122.0848);
  static const LatLng _pApplePark = LatLng(37.3346, -122.0090);
  LatLng? _currentP = null;

  Map<PolylineId, Polyline> polylines = {};

  @override
  void initState() {
    super.initState();
    getLocationUpdates().then(
      (_) => {
        getPolylinePoints().then((coordinates) => {
              generatePolyLineFromPoints(coordinates),
            }),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    DropdownButton(
      value: selectval,
      onChanged: (value) {
        setState(() {
          selectval = value.toString();
        });
      },
      items: listitems.map((itemone) {
        return DropdownMenuItem(value: itemone, child: Text(itemone));
      }).toList(),
    );

    return Scaffold(
      body: _currentP == null
          ? const Center(
              child: Text("Loading..."),
            )
          : Stack(
              children: <Widget>[
                GoogleMap(
                  onMapCreated: ((GoogleMapController controller) =>
                      _mapController.complete(controller)),
                  initialCameraPosition: CameraPosition(
                    target: _pGooglePlex,
                    zoom: 13,
                  ),
                  markers: {
                    Marker(
                      markerId: MarkerId("_currentLocation"),
                      icon: BitmapDescriptor.defaultMarker,
                      position: _currentP!,
                    ),
                    Marker(
                        markerId: MarkerId("_sourceLocation"),
                        icon: BitmapDescriptor.defaultMarker,
                        position: _pGooglePlex),
                    Marker(
                        markerId: MarkerId("_destionationLocation"),
                        icon: BitmapDescriptor.defaultMarker,
                        position: _pApplePark)
                  },
                  polylines: Set<Polyline>.of(polylines.values),
                ),
                const SizedBox(
                  height: 60,
                ),
                Positioned(
                  top:
                      50, // Ajusta este valor para mover el DropdownButton hacia arriba o hacia abajo
                  right:
                      10, // Ajusta este valor para mover el DropdownButton hacia la izquierda o la derecha
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: Offset(0, 1), // changes position of shadow
                        ),
                      ],
                    ),
                    child: DropdownButton<String>(
                      value: selectval,
                      iconSize: 30,
                      iconEnabledColor: Colors.blueAccent,
                      style: TextStyle(color: Colors.blueAccent),
                      underline: SizedBox(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectval = newValue!;
                        });
                      },
                      items: <String>['Choque', 'Incendio', 'Bloqueo']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Future<void> _cameraToPosition(LatLng pos) async {
    final GoogleMapController controller = await _mapController.future;
    CameraPosition _newCameraPosition = CameraPosition(
      target: pos,
      zoom: 13,
    );
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(_newCameraPosition),
    );
  }

  Future<void> getLocationUpdates() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await _locationController.serviceEnabled();
    if (_serviceEnabled) {
      _serviceEnabled = await _locationController.requestService();
    } else {
      return;
    }

    _permissionGranted = await _locationController.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _locationController.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationController.onLocationChanged
        .listen((LocationData currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setState(() {
          _currentP =
              LatLng(currentLocation.latitude!, currentLocation.longitude!);
          _cameraToPosition(_currentP!);
        });
      }
    });
  }

  Future<List<LatLng>> getPolylinePoints() async {
    List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      GOOGLE_MAPS_API_KEY,
      PointLatLng(_pGooglePlex.latitude, _pGooglePlex.longitude),
      PointLatLng(_pApplePark.latitude, _pApplePark.longitude),
      travelMode: TravelMode.driving,
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }
    return polylineCoordinates;
  }

  void generatePolyLineFromPoints(List<LatLng> polylineCoordinates) async {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id,
        color: Colors.black,
        points: polylineCoordinates,
        width: 8);
    setState(() {
      polylines[id] = polyline;
    });
  }
}
