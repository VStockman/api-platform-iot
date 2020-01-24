import 'package:flutter/material.dart';
import 'package:my_flutter_parking_app/about.dart';
import 'package:my_flutter_parking_app/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        title: 'My Parking App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Home(),
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case About.routeName:
              return MaterialPageRoute(
                  builder: (BuildContext context) => About());
            default:
              return MaterialPageRoute(
                  builder: (BuildContext context) => Home());
          }
        });
  }
}

