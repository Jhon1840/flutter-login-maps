import 'package:firebase_auth/firebase_auth.dart';

Future<bool> isAdmin() async {
  User? user = FirebaseAuth.instance.currentUser;
  return user != null && user.email == 'admin@gmail.com';
}
