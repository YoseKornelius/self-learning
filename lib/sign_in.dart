import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'Home.dart';
import 'Auth.dart';

void main() => runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MyHomePage(),
      ),
    );

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  String info = "";
  Auth auth;

  void doLogin() {
    signInWithGoogle().then((FirebaseUser user) {
      setState(() {
        info = "${user.displayName} (${user.email})";
      });
    }).catchError((e) => print(e.toString()));
  }

  Future<FirebaseUser> signInWithGoogle() async {
    GoogleSignInAccount gsia = await GoogleSignIn().signIn();
    GoogleSignInAuthentication gsiauth = await gsia.authentication;

    AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: gsiauth.idToken, accessToken: gsiauth.accessToken);

    FirebaseUser user =
        (await FirebaseAuth.instance.signInWithCredential(credential)).user;
    print("ID Token: ${gsiauth.idToken}");
    print("Access Token: ${gsiauth.accessToken}");
    auth = Auth(gsiauth.idToken, user.email);
    print(auth.toJson());
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blue,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 60),
              child: Text(
                'Sign In',
                style: TextStyle(
                    color: Colors.white, fontFamily: 'Raleway', fontSize: 40),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 20, right: 60, left: 60, bottom: 0),
              child: Text(
                'Username:',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Raleway',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 60, left: 60),
              child: Container(
                child: TextFormField(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 20, right: 60, left: 60, bottom: 0),
              child: Text(
                'Password:',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Raleway',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 60, left: 60),
              child: Container(
                child: TextFormField(),
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 14, bottom: 2),
                  child: ButtonTheme(
                    minWidth: 200.0,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.white)),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomeState()),
                        );
                      },
                      color: Colors.blue,
                      textColor: Colors.white,
                      child: Text("Submit".toUpperCase(),
                          style: TextStyle(fontSize: 14)),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 0, right: 80, left: 80),
                  child: ButtonTheme(
                    minWidth: 200.0,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22.0),
                          side: BorderSide(color: Colors.white)),
                      onPressed: () {
                        signInWithGoogle().whenComplete(() {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return HomeState();
                              },
                            ),
                          );
                        });
                      },
                      child: ListTile(
                        leading:
                            Image.asset("assets/Image/google.png", width: 30),
                        title: Text(
                          "Sign in with google".toUpperCase(),
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      color: Colors.white,
                      textColor: Colors.black,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
