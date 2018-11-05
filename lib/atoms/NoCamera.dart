import 'package:flutter/material.dart';
import 'package:pigment/pigment.dart';

class NoCamera extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Image.asset(
            "assets/images/nocamera.png",
            scale: 3.15,
          ),
          new Padding(
            padding: new EdgeInsets.only(left: 60.0, right: 60.0, top: 15.0),
            child: new Text(
              "Ups, parece que tu dispositivo no tiene una camara",
              textAlign: TextAlign.center,
              style: new TextStyle(
                color: Pigment.fromString("#162A40"),
                fontFamily: "Muli",
                fontWeight: FontWeight.w600,
                fontSize: 16.0,
              ),
            ),
          )
        ],
      ),
    );
  }
}


