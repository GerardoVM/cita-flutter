import 'package:flutter/material.dart';
import 'package:pigment/pigment.dart';

class NoInternetConnection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      constraints: new BoxConstraints.expand(),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Image.asset(
            "assets/images/noconnection.png",
            scale: 2.1,
          ),
          new Padding(
            padding: new EdgeInsets.only(top: 25.0),
            child: new Text(
              "NO TIENES INTERNET",
              style: new TextStyle(
                fontFamily: "StagSans",
                color: Pigment.fromString("#162A40"),
                fontSize: 26.0,
              ),
            ),
          ),
          new Text(
            "Todo volvera a la normalidad cuando cuentes con conexion",
            textAlign: TextAlign.center,
            style: new TextStyle(
              fontFamily: "Muli",
              color: Pigment.fromString("#162A40"),
              fontSize: 10.0,
              // letterSpacing: 0.78,
            ),
          ),
        ],
      ),
    );
  }
}
