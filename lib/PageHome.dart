import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PageHome extends StatefulWidget {
  @override
  State<PageHome> createState() => _PageHomeState();
}

class _PageHomeState extends State<PageHome> {
  var emailU;
  var RouteSignIn = '/SignIn';
  singOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacementNamed(RouteSignIn);
  }

  getUser() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      emailU = user.email;
      print(emailU);
    }
  }

  @override
  initState() {
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PageHome'),
        actions: [
          InkWell(
            onTap: () async {
              singOut();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Icon(
                Icons.logout,
                size: 35,
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Text(emailU.toString()),
      ),
    );
  }
}
