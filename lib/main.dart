import 'package:flutter/material.dart';
import 'sign_in.dart';
import 'Home.dart';

void main() => runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MyHomePage(),
      ),
    );

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/signin',
      routes: <String, WidgetBuilder>{
        '/signin': (context) => MyHomePage(),
        '/Home': (context) => HomeState(),
      },
    );
  }
}
