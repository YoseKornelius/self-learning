import 'package:flutter/material.dart';
import 'Home.dart';
// import "package:googleapis_auth/auth_browser.dart";
// import 'package:googleapis/storage/v1.dart';
// import 'package:googleapis_auth/auth_io.dart';
// import 'package:google_sign_in/google_sign_in.dart';
import 'dart:io' show Platform;
import 'package:http/http.dart' as http;
import 'package:flutter_appauth/flutter_appauth.dart';

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

class _LoginPageState extends State<LoginPage> {
  bool _isBusy = false;
  final FlutterAppAuth _appAuth = FlutterAppAuth();
  String _codeVerifier;
  String _authorizationCode;
  String _refreshToken;
  String _accessToken;
  final TextEditingController _authorizationCodeTextController =
      TextEditingController();
  final TextEditingController _accessTokenTextController =
      TextEditingController();
  final TextEditingController _accessTokenExpirationTextController =
      TextEditingController();

  final TextEditingController _idTokenTextController = TextEditingController();
  final TextEditingController _refreshTokenTextController =
      TextEditingController();
  String _userInfo = '';

  // For a list of client IDs, go to https://demo.identityserver.io
  final String _clientId = '';
  final String _redirectUrl = '';
  final String _issuer = '';
  final String _discoveryUrl = '';
  final List<String> _scopes = <String>[
    'openid',
    'profile',
    'email',
    'offline_access',
    'api'
  ];

  final AuthorizationServiceConfiguration _serviceConfiguration =
      AuthorizationServiceConfiguration(
          'https://demo.identityserver.io/connect/authorize',
          'https://demo.identityserver.io/connect/token');

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Visibility(
                visible: _isBusy,
                child: const LinearProgressIndicator(),
              ),
              RaisedButton(
                child: const Text('Sign in with no code exchange'),
                onPressed: _signInWithNoCodeExchange,
              ),
              RaisedButton(
                child: const Text('Exchange code'),
                onPressed: _authorizationCode != null ? _exchangeCode : null,
              ),
              RaisedButton(
                child: const Text('Sign in with auto code exchange'),
                onPressed: () => _signInWithAutoCodeExchange(),
              ),
              if (Platform.isIOS)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    child: const Text(
                      'Sign in with auto code exchange using ephemeral session (iOS only)',
                      textAlign: TextAlign.center,
                    ),
                    onPressed: () => _signInWithAutoCodeExchange(
                        preferEphemeralSession: true),
                  ),
                ),
              RaisedButton(
                child: const Text('Refresh token'),
                onPressed: _refreshToken != null ? _refresh : null,
              ),
              const Text('authorization code'),
              TextField(
                controller: _authorizationCodeTextController,
              ),
              const Text('access token'),
              TextField(
                controller: _accessTokenTextController,
              ),
              const Text('access token expiration'),
              TextField(
                controller: _accessTokenExpirationTextController,
              ),
              const Text('id token'),
              TextField(
                controller: _idTokenTextController,
              ),
              const Text('refresh token'),
              TextField(
                controller: _refreshTokenTextController,
              ),
              const Text('test api results'),
              Text(_userInfo),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _refresh() async {
    try {
      _setBusyState();
      final TokenResponse result = await _appAuth.token(TokenRequest(
          _clientId, _redirectUrl,
          refreshToken: _refreshToken,
          discoveryUrl: _discoveryUrl,
          scopes: _scopes));
      _processTokenResponse(result);
      await _testApi(result);
    } catch (_) {
      _clearBusyState();
    }
  }

  Future<void> _exchangeCode() async {
    try {
      _setBusyState();
      final TokenResponse result = await _appAuth.token(TokenRequest(
          _clientId, _redirectUrl,
          authorizationCode: _authorizationCode,
          discoveryUrl: _discoveryUrl,
          codeVerifier: _codeVerifier,
          scopes: _scopes));
      _processTokenResponse(result);
      await _testApi(result);
    } catch (_) {
      _clearBusyState();
    }
  }

  Future<void> _signInWithNoCodeExchange() async {
    try {
      _setBusyState();
      // use the discovery endpoint to find the configuration
      final AuthorizationResponse result = await _appAuth.authorize(
        AuthorizationRequest(_clientId, _redirectUrl,
            discoveryUrl: _discoveryUrl, scopes: _scopes, loginHint: 'bob'),
      );

      // or just use the issuer
      // var result = await _appAuth.authorize(
      //   AuthorizationRequest(
      //     _clientId,
      //     _redirectUrl,
      //     issuer: _issuer,
      //     scopes: _scopes,
      //   ),
      // );
      if (result != null) {
        _processAuthResponse(result);
      }
    } catch (_) {
      _clearBusyState();
    }
  }

  Future<void> _signInWithAutoCodeExchange(
      {bool preferEphemeralSession = false}) async {
    try {
      _setBusyState();

      // show that we can also explicitly specify the endpoints rather than getting from the details from the discovery document
      final AuthorizationTokenResponse result =
          await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          _clientId,
          _redirectUrl,
          serviceConfiguration: _serviceConfiguration,
          scopes: _scopes,
          preferEphemeralSession: preferEphemeralSession,
        ),
      );

      // this code block demonstrates passing in values for the prompt parameter. in this case it prompts the user login even if they have already signed in. the list of supported values depends on the identity provider
      // final AuthorizationTokenResponse result = await _appAuth.authorizeAndExchangeCode(
      //   AuthorizationTokenRequest(_clientId, _redirectUrl,
      //       serviceConfiguration: _serviceConfiguration,
      //       scopes: _scopes,
      //       promptValues: ['login']),
      // );

      if (result != null) {
        _processAuthTokenResponse(result);
        await _testApi(result);
      }
    } catch (_) {
      _clearBusyState();
    }
  }

  void _clearBusyState() {
    setState(() {
      _isBusy = false;
    });
  }

  void _setBusyState() {
    setState(() {
      _isBusy = true;
    });
  }

  void _processAuthTokenResponse(AuthorizationTokenResponse response) {
    setState(() {
      _accessToken = _accessTokenTextController.text = response.accessToken;
      _idTokenTextController.text = response.idToken;
      _refreshToken = _refreshTokenTextController.text = response.refreshToken;
      _accessTokenExpirationTextController.text =
          response.accessTokenExpirationDateTime?.toIso8601String();
    });
  }

  void _processAuthResponse(AuthorizationResponse response) {
    setState(() {
      // save the code verifier as it must be used when exchanging the token
      _codeVerifier = response.codeVerifier;
      _authorizationCode =
          _authorizationCodeTextController.text = response.authorizationCode;
      _isBusy = false;
    });
  }

  void _processTokenResponse(TokenResponse response) {
    setState(() {
      _accessToken = _accessTokenTextController.text = response.accessToken;
      _idTokenTextController.text = response.idToken;
      _refreshToken = _refreshTokenTextController.text = response.refreshToken;
      _accessTokenExpirationTextController.text =
          response.accessTokenExpirationDateTime?.toIso8601String();
    });
  }

  Future<void> _testApi(TokenResponse response) async {
    final http.Response httpResponse = await http.get(
        'https://demo.identityserver.io/api/test',
        headers: <String, String>{'Authorization': 'Bearer $_accessToken'});
    setState(() {
      _userInfo = httpResponse.statusCode == 200 ? httpResponse.body : '';
      _isBusy = false;
    });
  }
}
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

// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     body: Container(
//       color: Colors.blue,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(left: 60),
//             child: Text(
//               'Sign In',
//               style: TextStyle(
//                   color: Colors.white, fontFamily: 'Raleway', fontSize: 40),
//             ),
//           ),
//           Padding(
//             padding:
//                 const EdgeInsets.only(top: 20, right: 60, left: 60, bottom: 0),
//             child: Text(
//               'Username:',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontFamily: 'Raleway',
//               ),
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.only(right: 60, left: 60),
//             child: Container(
//               child: TextFormField(),
//             ),
//           ),
//           Padding(
//             padding:
//                 const EdgeInsets.only(top: 20, right: 60, left: 60, bottom: 0),
//             child: Text(
//               'Password:',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontFamily: 'Raleway',
//               ),
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.only(right: 60, left: 60),
//             child: Container(
//               child: TextFormField(),
//             ),
//           ),
//           Column(
//             children: [
//               Padding(
//                 padding: EdgeInsets.only(top: 14, bottom: 2),
//                 child: ButtonTheme(
//                   minWidth: 200.0,
//                   child: RaisedButton(
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(18.0),
//                         side: BorderSide(color: Colors.white)),
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => HomeState()),
//                       );
//                     },
//                     color: Colors.blue,
//                     textColor: Colors.white,
//                     child: Text("Submit".toUpperCase(),
//                         style: TextStyle(fontSize: 14)),
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.only(top: 0, right: 80, left: 80),
//                 child: ButtonTheme(
//                   minWidth: 200.0,
//                   child: RaisedButton(
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(22.0),
//                         side: BorderSide(color: Colors.white)),
//                     onPressed: () {},
//                     child: ListTile(
//                       leading:
//                           Image.asset("assets/Image/google.png", width: 30),
//                       title: Text(
//                         "Sign in with google".toUpperCase(),
//                         style: TextStyle(fontSize: 12),
//                       ),
//                     ),
//                     color: Colors.white,
//                     textColor: Colors.black,
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ],
//       ),
//     ),
//   );
// }

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
