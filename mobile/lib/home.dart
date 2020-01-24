import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_parking_app/about.dart';
import 'package:my_flutter_parking_app/bloc/splash_screen_event.dart';
import 'dart:convert';
import 'dart:ui';
import 'bloc/splash_screen_bloc.dart';
import 'bloc/splash_screen_state.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) =>
            SplashScreenBloc()..add(LaunchingApplication()),
        child: Builder(builder: (BuildContext context) {
          return BlocBuilder(
              bloc: BlocProvider.of<SplashScreenBloc>(context),
              builder: (BuildContext context, SplashScreenState state) {
                if (state is InitialSplashScreenState) {
                  return Image.asset('lib/assets/loadingscreen.jpg');
                } else {
                  return FutureBuilder<String>(
                      future: fetchPlaces(),
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        Widget child;
                        if (snapshot.hasData) {
                          var places =
                              jsonDecode(snapshot.data)["hydra:member"];
                          final String isPlace1Available = places[0]
                                  ["available"]
                              ? "disponible"
                              : "indisponible";
                          final String isPlace2Available = places[1]
                                  ["available"]
                              ? "disponible"
                              : "indisponible";
                          final String isPlace3Available = places[2]
                                  ["available"]
                              ? "disponible"
                              : "indisponible";
                          child = Container(
                            child: Column(
                              children: <Widget>[
                                Text(
                                  "Parking ITESCIA :",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                      fontSize: 30),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 115),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Text('Place 1 :       '),
                                            Text(isPlace1Available,
                                                style: TextStyle(
                                                    color: isPlace1Available ==
                                                            'disponible'
                                                        ? Colors.green
                                                        : Colors.red))
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Text('Place 2 :       '),
                                            Text(isPlace2Available,
                                                style: TextStyle(
                                                    color: isPlace2Available ==
                                                            'disponible'
                                                        ? Colors.green
                                                        : Colors.red))
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Text('Place 3 :       '),
                                            Text(isPlace3Available,
                                                style: TextStyle(
                                                    color: isPlace3Available ==
                                                            'disponible'
                                                        ? Colors.green
                                                        : Colors.red))
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                new Align(
                                  alignment: Alignment.bottomRight,
                                  child: SafeArea(
                                      child: FloatingActionButton(
                                          child: Text(
                                            "?",
                                            style: TextStyle(
                                              fontSize: 25,
                                            ),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pushNamed(About.routeName);
                                          })),
                                )
                              ],
                            ),
                          );
                        } else if (snapshot.hasError) {
                          String error;
                          if (snapshot.error
                              .toString()
                              .contains("SocketException")) {
                            error =
                                "Erreur réseau. Veuillez rallumer les données mobiles ou le Wi-Fi pour obtenir les données.";
                          } else {
                            error =
                                "Une erreur est survenue. Veuillez réessayer plus tard ou contactez l'assistance.";
                          }
                          child = Container(
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.error_outline,
                                    color: Colors.red,
                                    size: 60,
                                  ),
                                  Center(child: Text('Erreur: $error')),
                                  new Align(
                                    alignment: Alignment.bottomRight,
                                    child: SafeArea(
                                        child: FloatingActionButton(
                                            child: Text(
                                              "?",
                                              style: TextStyle(
                                                fontSize: 25,
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pushNamed(About.routeName);
                                            })),
                                  )
                                ],
                              ),
                            ),
                          );
                        } else {
                          child = Container(
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    child: CircularProgressIndicator(),
                                    width: 60,
                                    height: 60,
                                  ),
                                  const Padding(
                                      padding: EdgeInsets.only(top: 16),
                                      child:
                                          Text("En attente d'une réponse...")),
                                  new Align(
                                    alignment: Alignment.bottomRight,
                                    child: SafeArea(
                                        child: FloatingActionButton(
                                            child: Text(
                                              "?",
                                              style: TextStyle(
                                                fontSize: 25,
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pushNamed(About.routeName);
                                            })),
                                  )
                                ],
                              ),
                            ),
                          );
                        }
                        return Scaffold(
                            appBar: AppBar(title: Text("Park-King")),
                            body: child);
                      });
                }
              });
        }));
  }

  Future<String> fetchPlaces() async {
    var httpClient = new HttpClient()
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
    var client = new IOClient(httpClient);
    http.Response response = await client.get("https://10.0.2.2:8443/places");
    String reply = response.body;
    return reply;
  }
}
