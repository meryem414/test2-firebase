import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class PageSignUp extends StatefulWidget {
  @override
  State<PageSignUp> createState() => _PageSignUpState();
}

class _PageSignUpState extends State<PageSignUp> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  var RouteSignIn = '/SignIn';
  var RoutePagehome = '/Pagehome';
  UserCredential? credential;

  final usernameU = TextEditingController();
  final emailU = TextEditingController();
  final passwordU = TextEditingController();
  @override
  void dispose() {
    usernameU.dispose();
    emailU.dispose();
    passwordU.dispose();

    super.dispose();
  }

  // Future<UserCredential?>
  SignUp() async {
    FormState? formdata = formState.currentState;
    if (formdata!.validate()) {
      // print(usernameU.text.toString());

      try {
        credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailU.text.toString(),
          password: passwordU.text.toString(),
        );

        return credential;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          //Change It
          AwesomeDialog(
            context: context,
            dialogType: DialogType.warning,
            title: 'Warning',
            desc: 'The password id to Weak..',
            btnCancelOnPress: () {},
            btnOkOnPress: () {
              usernameU.text = '';
              emailU.text = '';
              passwordU.text = '';
            },
          )..show();
        } else if (e.code == 'email-already-in-use') {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.warning,
            title: 'Warning',
            desc: 'The account already exists for that email...',
            btnCancelOnPress: () {},
            btnOkOnPress: () {
              usernameU.text = '';
              emailU.text = '';
              passwordU.text = '';
            },
          )..show();
        }
        // return null;
      } catch (e) {
        print(e);
      }
    } else {
      print('Not valide');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Sign Up'),
        ),
        body: Form(
          key: formState,
          child: ListView(
            children: [
              SizedBox(
                height: 200,
              ),
              TextFildItem('UserName', 'Enter your UserName', Icons.person,
                  usernameU, 'UserName'),
              SizedboxI(),
              TextFildItem(
                  'E-Mail', 'Enter your Email', Icons.email, emailU, 'Email'),
              SizedboxI(),
              TextFildItem('Password', 'Enter your Password', Icons.password,
                  passwordU, 'Password'),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 90, vertical: 20),
                child: Row(
                  children: [
                    Text(
                      'If you have account',
                      style: TextStyle(fontSize: 15),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    InkWell(
                      onTap: (() => Navigator.of(context)
                          .pushReplacementNamed(RouteSignIn)),
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
                      var response = await SignUp();
                      if (response != null) {
                        // print(response);
                        Navigator.of(context).pushNamed(RoutePagehome);
                      } else {
                        print('Faild');
                      }
                    },
                    child: Text(
                      'Sign In',
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    )),
              ),
            ],
          ),
        ));
  }

  SizedBox SizedboxI() {
    return SizedBox(
      height: 20,
    );
  }

  Container TextFildItem(
      labelText, hintText, icon, contentTextFild, StringText) {
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
          // onSaved: (text) {
          //   contentTextFild = text;
          //   print(contentTextFild);
          // },
          decoration: InputDecoration(
            // border: OutlineInputBorder(),
            icon: Icon(icon),
            labelText: labelText,
            labelStyle: TextStyle(fontSize: 20),
            hintText: hintText,
            hintStyle: TextStyle(
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}
