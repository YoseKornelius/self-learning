import 'package:flutter/material.dart';
import 'package:sampleProject2/splash.dart';
import 'sign_in.dart';
import 'Home.dart';

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: LoginPage(),
//       initialRoute: '/login',
//       routes: <String, WidgetBuilder>{
//         '/splash': (context) => Splash(),
//         '/login': (context) => LoginPage(),
//         '/Home': (context) => HomeState(),
//       },
//     );
//   }
// }

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SRM',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        '/': (_) => Splash(),
        '/login': (_) => LoginPage(),
        '/home': (_) => HomeState(),
      },
    );
  }
}
