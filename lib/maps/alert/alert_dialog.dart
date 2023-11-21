import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class AlertDialogScreen extends StatelessWidget {
  final LatLng position;

  AlertDialogScreen({required this.position});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Elige una opción'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: const Text('Incendio'),
            onTap: () {
              FirebaseFirestore.instance.collection('alertas').add({
                'type': 'Incendio',
                'position': GeoPoint(position.latitude, position.longitude),
              });
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            title: const Text('Bloqueo'),
            onTap: () {
              FirebaseFirestore.instance.collection('alertas').add({
                'type': 'Bloqueo',
                'position': GeoPoint(position.latitude, position.longitude),
              });
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            title: const Text('Choque'),
            onTap: () {
              FirebaseFirestore.instance.collection('alertas').add({
                'type': 'Choque',
                'position': GeoPoint(position.latitude, position.longitude),
              });
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
