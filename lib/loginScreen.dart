import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:untitled3/bienvenido.dart';
import 'package:untitled3/maps/map.dart';
import 'package:untitled3/maps/maps.dart';

// ignore: camel_case_types
class loginScreen extends StatefulWidget {
  const loginScreen({super.key});

  @override
  State<loginScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<loginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  String _email = "";
  String _password = "";

  void _handleLogin() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _email,
        password: _password,
      );
      print("Usuario loggeado ${userCredential.user!.email}");
      // ignore: use_build_context_synchronously
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MapScreen(),
          ));
    } catch (e) {
      print("Error al logearse: $e ");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
              Color.fromARGB(255, 226, 90, 16),
              Color.fromARGB(255, 200, 251, 18),
            ]),
          ),
          child: const Padding(
            padding: EdgeInsets.only(top: 60.0, left: 22),
            child: Text(
              'Hola\nInicia Sesion!',
              style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 200.0),
          child: Container(
            key: _formkey,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40), topRight: Radius.circular(40)),
              color: Colors.white,
            ),
            height: double.infinity,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                        suffixIcon: Icon(
                          Icons.check,
                          color: Colors.grey,
                        ),
                        label: Text(
                          'Correo Electronico',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 226, 90, 16),
                          ),
                        )),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Por Favor Introduce Tu Email";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        _email = value;
                      });
                    },
                  ),
                  TextFormField(
                    controller: _passController,
                    obscureText: true,
                    decoration: const InputDecoration(
                        suffixIcon: Icon(
                          Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        label: Text(
                          'Contraseña',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 226, 90, 16),
                          ),
                        )),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Por Favor Introduce Tu Contraseña";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        _password = value;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Olvidaste la contraseña?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: Color(0xff281537),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 70,
                  ),
                  Container(
                    height: 55,
                    width: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: const LinearGradient(colors: [
                        Color.fromARGB(255, 226, 90, 16),
                        Color.fromARGB(255, 200, 251, 18),
                      ]),
                    ),
                    child: Center(
                      child: TextButton(
                        onPressed: () {
                          _handleLogin();
                        },
                        child: const Text(
                          'INICIAR SESION',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 150,
                  ),
                  const Align(
                    alignment: Alignment.bottomRight,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "No tienes una cuenta?",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.grey),
                        ),
                        Text(
                          "Registrate",
                          style: TextStyle(

                              ///done login page
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              color: Colors.black),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    ));
  }
}
