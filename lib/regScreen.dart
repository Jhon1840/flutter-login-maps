import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:untitled3/loginScreen.dart';

class RegScreen extends StatefulWidget {
  const RegScreen({super.key});

  @override
  State<RegScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<RegScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  String _email = "";
  String _password = "";

  void _handleSignUp() async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _email,
        password: _password,
      );
      print("Usuario registrado ${userCredential.user!.email}");
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => loginScreen(),
          ));
    } catch (e) {
      print("Error al registrarse: $e ");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      //thanks for watching
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
              'Crea tu\nCuenta',
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
                          'Nombre Completo',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 226, 90, 16),
                          ),
                        )),
                  ),
                  TextFormField(
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
                    onChanged: (value) {
                      setState(() {
                        _password = value;
                      });
                    },
                  ),
                  const TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        label: Text(
                          'Confirmar Contraseña',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 226, 90, 16),
                          ),
                        )),
                  ),
                  const SizedBox(
                    height: 10,
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
                          _handleSignUp();
                        },
                        child: const Text(
                          'REGISTRARSE',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white),
                        ),
                      ),
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
