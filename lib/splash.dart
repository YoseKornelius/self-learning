import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:sampleProject2/sign_in.dart';

class Splash extends StatefulWidget {
  Splash({Key key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  GoogleSignIn googleSignIn = GoogleSignIn(
      clientId:
          "445931920297-t1hifgbsiigk1co86cv6mogieblikrdr.apps.googleusercontent.com");

  @override
  void initState() {
    checkSignInStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "SRM",
            style: TextStyle(
              fontSize: 30,
              color: Colors.blue,
            ),
          ),
          CircularProgressIndicator(),
        ],
      ),
    );
  }

  void checkSignInStatus() async {
    await Future.delayed(Duration(seconds: 3));
    bool isSignedIn = await googleSignIn.isSignedIn();
    if (isSignedIn) {
      print("User Sign In");
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }
}
