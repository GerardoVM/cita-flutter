import 'package:flutter/material.dart';
import 'package:pigment/pigment.dart';

class NoGPS extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      constraints: new BoxConstraints.expand(),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Image.asset(
            "assets/images/gpserror.png",
            scale: 2.0,
          ),
          new Padding(
            padding: new EdgeInsets.only(top: 25.0),
            child: new Text(
              "NO SE PUEDE OBTENER TU UBICACIÓN",
              textAlign: TextAlign.center,
              style: new TextStyle(
                fontFamily: "StagSans",
                color: Pigment.fromString("#162A40"),
                fontSize: 24.0,
              ),
            ),
          ),
          new Padding(
            child: new Text(
              "Por favor activa tu gps o verifica que este pueda funcionar de manera correcta",
              textAlign: TextAlign.center,
              style: new TextStyle(
                fontFamily: "Muli",
                color: Pigment.fromString("#162A40"),
                fontSize: 10.0,
                // letterSpacing: 0.78,
              ),
            ),
            padding: new EdgeInsets.only(left: 20.0, right: 20.0),
          )
        ],
      ),
    );
  }
}
