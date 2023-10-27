//import 'dart:js_interop';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled3/WelcomeScreen.dart';

class bienvenido extends StatefulWidget {
  const bienvenido({super.key});

  @override
  State<bienvenido> createState() => _bienvenidoState();
}

class _bienvenidoState extends State<bienvenido> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    String? _email = _auth.currentUser!.email;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bienvenido"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Bienvenido: $_email "),
              const SizedBox(
                height: 50,
              ),
              ElevatedButton(
                onPressed: () {
                  _auth.signOut();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WelcomeScreen(),
                      ));
                },
                child: const Text("SALIR"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
