import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:untitled3/maps/alert/map.dart';

class EditAlert extends StatefulWidget {
  const EditAlert({super.key});

  @override
  State<EditAlert> createState() => _EditAlertState();
}

class _EditAlertState extends State<EditAlert> {
  final Stream<QuerySnapshot> _alertStream =
      FirebaseFirestore.instance.collection('alertas').snapshots();

  Future<void> _deleteAlert(DocumentSnapshot doc) async {
    await FirebaseFirestore.instance.collection('alertas').doc(doc.id).delete();
  }

  Future<void> _confirmDelete(DocumentSnapshot doc) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // El usuario debe tocar el botón
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar eliminación'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('¿Estás seguro de que quieres eliminar esta alerta?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Sí'),
              onPressed: () {
                _deleteAlert(doc);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alertas'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MapCreate()),
            );
          },
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _alertStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Algo salió mal');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              GeoPoint position = data['position'];
              return Card(
                color: Colors.white,
                margin: EdgeInsets.all(8.0),
                child: ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  title: Text(
                    'Posición: Latitud ${position.latitude}, Longitud ${position.longitude}',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    'Tipo: ${data['type']}',
                    style: TextStyle(color: Colors.black),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red, size: 30.0),
                    onPressed: () => _confirmDelete(document),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
