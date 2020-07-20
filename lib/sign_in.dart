import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'Home.dart';

// final authorizationEndpoint =
//     Uri.parse("http://example.com/oauth2/authorization");
// final tokenEndpoint = Uri.parse("http://example.com/oauth2/token");
// final identifier = "my client identifier";
// final secret = "my client secret";
// final redirectUrl = Uri.parse("http://my-site.com/oauth2-redirect");
// final credentialsFile = new File("~/.myapp/credentials.json");

// Future<oauth2.Client> getClient() async {
//   var exists = await credentialsFile.exists();
//   if (exists) {
//     var credentials =
//         new oauth2.Credentials.fromJson(await credentialsFile.readAsString());
//     return new oauth2.Client(credentials,
//         identifier: identifier, secret: secret);
//   }

//   var grant = new oauth2.AuthorizationCodeGrant(
//       identifier, authorizationEndpoint, tokenEndpoint,
//       secret: secret);

//   var authorizationUrl = grant.getAuthorizationUrl(redirectUrl);
//   await redirect(authorizationUrl);
//   var responseUrl = await listen(redirectUrl);
//   return await grant.handleAuthorizationResponse(responseUrl.queryParameters);
// }

// main() async {
//   var client = await getClient();

//   var result = client.read("http://example.com/protected-resources.txt");

//   await credentialsFile.writeAsString(client.credentials.toJson());

//   print(result);
// }

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class Strings {
  static const String clientId =
      "445931920297-a0nldcfbu1hbqne9dlov3ga9ih0b238u.apps.googleusercontent.com";
}

class _LoginPageState extends State<LoginPage> {
  GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/userinfo.profile',
      ],
      clientId:
          "445931920297-1nmg9s1u4u7koblf7si78ub82mu4pruf.apps.googleusercontent.com");
//===============================================================================================
// Future<void> doLogin() async {
//   var hlp = OAuth2Helper(GoogleOAuth2Client(
//       redirectUri: 'com.example.sampleProject2:/oauth2redirect',
//       customUriScheme: 'com.example.sampleProject2'));

//   // GoogleOAuth2Client(
//   //   redirectUri: 'com.example.sampleProject2:/oauth2redirect',
//   //   customUriScheme: 'com.example.sampleProject2',
//   // );

//   hlp.setAuthorizationParams(
//       grantType: OAuth2Helper.AUTHORIZATION_CODE,
//       clientId:
//           '445931920297-1nmg9s1u4u7koblf7si78ub82mu4pruf.apps.googleusercontent.com',
//       scopes: ['https://www.googleapis.com/auth/gmail.readonly']);

//   var resp = await hlp.get('https://www.googleapis.com/token');

//   print(resp.body);
// }
//==========================================================
// GoogleSignIn _googleSignIn = GoogleSignIn(
//   scopes: [
//     'email',
//     'https://www.googleapis.com/auth/contacts.readonly',
//   ],
// );

// void doLogin() {
//   _googleSignIn.signIn().then((result) {
//     print(result);
//     print('terpanggil');
//     result.authentication.then((googleKey) {
//       print('accessToken:');
//       print(googleKey.accessToken);
//       print('idToken:');
//       print(googleKey.idToken);
//       print(_googleSignIn.currentUser.displayName);
//     }).catchError((err) {
//       print('inner error');
//     });
//     print('terpanggil');
//   }).catchError((err) {
//     print(err);
//   });
// }

//============================================================

// Future<void> _handleSignIn() async {
//   try {
//     await _googleSignIn.signIn();
//   } catch (error) {
//     print(error);
//   }
// }
//   var id = new ClientId("....apps.googleusercontent.com", null);
// var scopes = [
//   email:""
// ];

// // Initialize the browser oauth2 flow functionality.
// createImplicitBrowserFlow(id, scopes).then((BrowserOAuth2Flow flow) {
//   flow.obtainAccessCredentialsViaUserConsent()
//       .then((AccessCredentials credentials) {
//     // Credentials are available in [credentials].
//     ...
//     flow.close();
//   });
// });

//   final _credentials = new ServiceAccountCredentials.fromJson(r'''
// {
//   "private_key_id": ...,
//   "private_key": ...,
//   "client_email": ...,
//   "client_id": ...,
//   "type": "service_account"
// }
// ''');

//   static const _SCOPES = const [StorageApi.DevstorageReadOnlyScope];

//   void main() {
//     clientViaServiceAccount(_credentials, _SCOPES).then((httpClient) {
//       var storage = new StorageApi(httpClient);
//       storage.buckets.list('dart-on-cloud').then((buckets) {
//         print("Received ${buckets.items.length} bucket names:");
//         for (var file in buckets.items) {
//           print(file.name);
//         }
//       });
//     });
//   }
//=================================================================
// useGoogleApi() async {
//   final _googleSignIn = new GoogleSignIn(
//     scopes: [
//       'email',
//       'https://www.googleapis.com/auth/contacts.readonly',
//     ],
//   );

//   await _googleSignIn.signIn();

//   final authHeaders = _googleSignIn.currentUser.authHeaders;
//   final httpClient = new GoogleHttpClient(authHeaders);

//   data = await new PeopleApi(httpClient).people.connections.list(
//         'people/me',
//         personFields: 'names,addresses',
//         pageToken: nextPageToken,
//         pageSize: 100,
//       );
// }
// void login() async {
//   GoogleSignIn _googleSignIn = GoogleSignIn(
//     scopes: [
//       'email',
//       // you can add extras if you require
//     ],
//   );

//===========================================================

//   _googleSignIn.signIn().then((GoogleSignInAccount acc) async {
//     GoogleSignInAuthentication auth = await acc.authentication;
//     print(acc.id);
//     print(acc.email);
//     print(acc.displayName);
//     print(acc.photoUrl);

//     acc.authentication.then((GoogleSignInAuthentication auth) async {
//       print(auth.idToken);
//       print(auth.accessToken);
//     });
//   });
// }

//=======================================================================================

// final GoogleSignIn googleSignIn = GoogleSignIn();
// String info = "";
// Auth auth;

// void doLogin() {
//   signInWithGoogle().then((FirebaseUser user) {
//     setState(() {
//       info = "${user.displayName} (${user.email})";
//     });
//   }).catchError((e) => print(e.toString()));
// }

// Future<FirebaseUser> signInWithGoogle() async {
//   GoogleSignInAccount gsia = await GoogleSignIn().signIn();
//   GoogleSignInAuthentication gsiauth = await gsia.authentication;

//   AuthCredential credential = GoogleAuthProvider.getCredential(
//       idToken: gsiauth.idToken, accessToken: gsiauth.accessToken);

//   FirebaseUser user =
//       (await FirebaseAuth.instance.signInWithCredential(credential)).user;
// print("ID Token: ${gsiauth.idToken}");
// print("Access Token: ${gsiauth.accessToken}");
// auth = Auth(gsiauth.idToken, user.email);
// print(auth.toJson());
// return user;
// }
//============================================================================

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
                        startSignIn();
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

  void startSignIn() async {
    await googleSignIn.signOut(); //optional
    GoogleSignInAccount user = await googleSignIn.signIn();
    if (user == null) {
      print('Sign In Failed ');
    } else {
      Navigator.pushReplacementNamed(context, '/home');
    }
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

//     AuthCredential firebaseAuth = GoogleAuthProvider.getCredential(
//         idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
//     FirebaseUser user =
//         (await FirebaseAuth.instance.signInWithCredential(firebaseAuth)).user;
//     print("ID Token: ${googleAuth.idToken}");
//     print("Access Token: ${googleAuth.accessToken}");
//     auth = Auth(googleAuth.idToken, user.email);
//     print(auth.toJson());
//     return user;
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
