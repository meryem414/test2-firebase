import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

class PageSignIn extends StatefulWidget {
  const PageSignIn({super.key});

  @override
  State<PageSignIn> createState() => _PageSignInState();
}

class _PageSignInState extends State<PageSignIn> {
  var RouteSignUp = '/SignUp';
  var RoutePagehome = '/Pagehome';
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  GlobalKey<FormState> formState = GlobalKey<FormState>();
  final emailU = TextEditingController();
  final passwordU = TextEditingController();
  SignIn() async {
    FormState? formdata = formState.currentState;
    if (formdata!.validate()) {
      try {
        final credential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailU.text.toString(),
          password: passwordU.text.toString(),
        );

        return credential;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.warning,
            title: 'Warning',
            desc: 'No user found for that email...',
            btnCancelOnPress: () {},
            btnOkOnPress: () {
              emailU.text = '';
              passwordU.text = '';
            },
          )..show();
        } else if (e.code == 'wrong-password') {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.warning,
            title: 'Warning',
            desc: 'Wrong password provided for that user..',
            btnCancelOnPress: () {},
            btnOkOnPress: () {},
          )..show();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Sign In '),
        ),
        body: Form(
          key: formState,
          child: ListView(
            children: [
              SizedBox(
                height: 200,
              ),
              SizedboxI(),
              TextFildItem(
                  'E-Mail', 'Enter your Email', Icons.email, 'Eamil', emailU),
              SizedboxI(),
              TextFildItem('Password', 'Enter your Password', Icons.password,
                  'Password', passwordU),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 90, vertical: 20),
                child: Row(
                  children: [
                    Text(
                      'If you havent account',
                      style: TextStyle(fontSize: 15),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    InkWell(
                      onTap: (() => Navigator.of(context)
                          .pushReplacementNamed(RouteSignUp)),
                      child: Text(
                        'Click Here',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Center(
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        side: BorderSide(color: Colors.black, width: 1),
                        elevation: 20,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 20)),
                    onPressed: () async {
                      var reponse = await SignIn();
                      // print(reponse);
                      Navigator.of(context).pushReplacementNamed(RoutePagehome);
                    },
                    child: Text(
                      'Sign In',
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    )),
              ),
              SizedBox(
                height: 40,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                CircleAvatarItem(FontAwesomeIcons.google),
                SizedBox(
                  width: 18,
                ),
                CircleAvatarItem(FontAwesomeIcons.facebook),
                SizedBox(
                  width: 18,
                ),
                CircleAvatarItem(FontAwesomeIcons.instagram),
                SizedBox(
                  width: 18,
                ),
                CircleAvatarItem(FontAwesomeIcons.telegram),
              ]),
            ],
          ),
        ));
  }

  CircleAvatar CircleAvatarItem(iconi) {
    return CircleAvatar(
      backgroundColor: Color.fromARGB(255, 159, 248, 142),
      radius: 35,
      child: Center(
          child: IconButton(
              // Use the FaIcon Widget + FontAwesomeIcons class for the IconData
              icon: FaIcon(
                iconi,
                size: 33,
              ),
              onPressed: () async {
                var reponse = await signInWithGoogle();
                Navigator.of(context).pushReplacementNamed(RoutePagehome);
              })),
    );
  }

  SizedBox SizedboxI() {
    return SizedBox(
      height: 20,
    );
  }

  Container TextFildItem(
      labelText, hintText, icon, StringText, contentTextFild) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50),
      child: Theme(
        data: ThemeData(
          primaryColor: Colors.orangeAccent,
          primaryColorDark: Colors.orange,
        ),
        child: TextFormField(
          controller: contentTextFild,
          validator: (value) {
            if (value!.length < 2) {
              return " $StringText cant be less than 2 letters";
            }
            if (value.length > 100) {
              return "$StringText cant be larger than 2 letters";
            }
            return null;
          },
          decoration: InputDecoration(
              // border: OutlineInputBorder(),
              icon: Icon(icon),
              labelText: labelText,
              labelStyle: TextStyle(fontSize: 20),
              hintText: hintText,
              hintStyle: TextStyle(
                fontSize: 18,
              )),
        ),
      ),
    );
  }
}
