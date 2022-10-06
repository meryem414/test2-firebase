import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pratique1/PageHome.dart';
import 'package:pratique1/PageSignIn.dart';
import 'package:pratique1/PageSignUp.dart';

import 'firebase_options.dart';

late bool islogin;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  var user = FirebaseAuth.instance.currentUser; // null or not
  user == null ? islogin = false : islogin = true;

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: islogin == true ? PageHome() : PageSignIn(),
      routes: {
        '/SignUp': (context) => PageSignUp(),
        '/SignIn': (context) => PageSignIn(),
        '/Pagehome': (context) => PageHome()
      },
    );
  }
}
