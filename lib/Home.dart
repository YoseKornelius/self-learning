import 'package:flutter/material.dart';
import 'sign_in.dart';

void main() => runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MyHomePage(),
      ),
    );

class HomeState extends StatefulWidget {
  HomeState({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Home createState() => Home();
}

class Home extends State<HomeState> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Navigator.of(context).pop(
              MaterialPageRoute(
                builder: (context) {
                  return MyHomePage();
                },
              ),
            );
          },
          child: Text('Sign Out'),
        ),
      ),
    );
  }
}
