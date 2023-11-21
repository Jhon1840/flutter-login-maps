import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled3/maps/alert/navbar.dart';

class UserData extends StatefulWidget {
  const UserData({Key? key}) : super(key: key);

  @override
  _UserDataState createState() => _UserDataState();
}

class _UserDataState extends State<UserData> {
  final User? loggedInUser = FirebaseAuth.instance.currentUser;
  final TextEditingController _usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    print(
        'Email del usuario logeado: ${loggedInUser?.email}'); // Imprime el email del usuario logeado

    return Scaffold(
      appBar: CustomNavBar(),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: loggedInUser?.email)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Muestra un indicador de progreso mientras se cargan los datos
          }

          if (snapshot.data?.docs != null && snapshot.data!.docs.length > 0) {
            Map<String, dynamic> data =
                snapshot.data!.docs.first.data() as Map<String, dynamic>;
            print(
                'Email en la base de datos: ${data['email']}'); // Imprime el email que se está comparando en la base de datos

            _usernameController.text = data['username'];

            // Muestra los datos en una tarjeta con un diseño atractivo
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(data['imageUrl'] ??
                            'https://www.solvetic.com/uploads/monthly_06_2016/post-821-0-39311200-1467317041.jpg'),
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.person,
                          color: Color.fromARGB(255, 0, 26, 158)),
                      title: Text("Nombre"),
                      subtitle: TextField(
                        controller: _usernameController,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Divider(color: Color.fromARGB(255, 0, 26, 158)),
                    ListTile(
                      leading: Icon(Icons.email,
                          color: Color.fromARGB(255, 0, 26, 158)),
                      title: Text("Email"),
                      subtitle:
                          Text(data['email'], style: TextStyle(fontSize: 20)),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(loggedInUser?.uid)
                            .get()
                            .then((docSnapshot) {
                          if (docSnapshot.exists) {
                            // El documento existe, actualiza los datos
                            docSnapshot.reference.update({
                              'username': _usernameController.text,
                            });
                          } else {
                            // El documento no existe, crea uno nuevo
                            docSnapshot.reference.set({
                              'username': _usernameController.text,
                              'imageUrl': data['imageUrl'] ??
                                  'https://www.solvetic.com/uploads/monthly_06_2016/post-821-0-39311200-1467317041.jpg',
                            });
                          }
                        });
                      },
                      child: Text('Guardar'),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Text("No data found for this user");
          }
        },
      ),
    );
  }
}
