import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'Home.dart';
import 'Auth.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['profile', 'email']);

void main() => runApp(MaterialApp(
      title: 'Google Sign in',
      home: SignIn(),
    ));

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  GoogleSignInAccount _currentUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
      });
    });
    _googleSignIn.signInSilently();
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text('Google Sign in Demo'),
  //     ),
  //     body: Center(child: _buildBody()),
  //   );
  // }

  // Widget _buildBody() {
  //   if (_currentUser != null) {
  //     return Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       mainAxisSize: MainAxisSize.max,
  //       children: <Widget>[
  //         ListTile(
  //           leading: GoogleUserCircleAvatar(
  //             identity: _currentUser,
  //           ),
  //           title: Text(_currentUser.displayName ?? ''),
  //           subtitle: Text(_currentUser.email ?? ''),
  //         ),
  //         RaisedButton(
  //           onPressed: _handleSignOut,
  //           child: Text('SIGN OUT'),
  //         )
  //       ],
  //     );
  //   } else {
  //     return Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       mainAxisSize: MainAxisSize.max,
  //       children: <Widget>[
  //         Text('You are not signed in..'),
  //         RaisedButton(
  //           onPressed: _handleSignIn,
  //           child: Text('SIGN IN'),
  //         )
  //       ],
  //     );
  //   }
  // }

// ===================================================================================================
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
                      onPressed: _handleSignIn,
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

  String info = "";
  Auth auth;

  Future<String> _handleSignIn() async {
    try {
      GoogleSignInAccount gsia = await _googleSignIn.signIn();
      GoogleSignInAuthentication gsiauth = await gsia.authentication;
      print("ID Token: ${gsiauth.idToken}");
      print("Access Token: ${gsiauth.accessToken}");
      auth = Auth(gsiauth.idToken, _currentUser.email);
      print(auth.toJson());
    } catch (error) {
      print(error);
    }
  }

  Future<void> _handleSignOut() async {
    _googleSignIn.disconnect();
  }
}

// class Auth {
//   Auth({
//     @required this.googleSignIn,
//     @required this.firebaseAuth,
//   });

//   final GoogleSignIn googleSignIn;
//   final FirebaseAuth firebaseAuth;

//   Future<FirebaseUser> signInWithGoogle() async {
//     final GoogleSignInAccount googleAccount = await googleSignIn.signIn();
//     final GoogleSignInAuthentication googleAuth =
//         await googleAccount.authentication;

// AuthCredential firebaseAuth = GoogleAuthProvider.getCredential(
//     idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
// FirebaseUser user =
//     (await FirebaseAuth.instance.signInWithCredential(firebaseAuth)).user;
// print("ID Token: ${googleAuth.idToken}");
// print("Access Token: ${googleAuth.accessToken}");
// auth = Auth(googleAuth.idToken, user.email);
// print(auth.toJson());
// return user;
//   }
// }

// class GoogleHttpClient extends _LoginPageState {
//   Map<String, String> _headers;

//   GoogleHttpClient(this._headers) : super();

//   @override
//   Future<StreamedResponse> send(BaseRequest request) =>
//       super.send(request..headers.addAll(_headers));

//   @override
//   Future<Response> head(Object url, {Map<String, String> headers}) =>
//       super.head(url, headers: headers..addAll(_headers));
// }
