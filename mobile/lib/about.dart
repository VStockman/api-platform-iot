import 'package:flutter/material.dart';

class About extends StatelessWidget {
  static const routeName = '/about';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            'Les données affichées sont soumises aux droits d\'auteur. Toute exploitation ou reproduction est interdite. Application faite par ElMehdi BELHADRI, Alexandre LORIER, Rémi MASSENYA, et Valentin STOCKMAN.',
            textAlign: TextAlign.center,
          ),
          RaisedButton(
            child: Text("Retour"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ]),
      ),
    );
  }
}
