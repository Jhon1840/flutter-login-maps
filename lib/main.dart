import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:untitled3/loginScreen.dart';
import 'package:untitled3/maps/maps.dart';
import 'firebase_options.dart';
import 'package:untitled3/maps/map.dart';

import 'WelcomeScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: ('inter'),
        useMaterial3: true,
      ),
      home: const loginScreen(),
    );
  }
}
