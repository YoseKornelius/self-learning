import 'package:flutter/material.dart';
import 'sign_in.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/signin',
      routes: <String, WidgetBuilder>{
        '/signin': (context) => MyHomePage(),
      },
    );
  }
}
