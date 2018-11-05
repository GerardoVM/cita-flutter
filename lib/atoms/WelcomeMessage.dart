import 'package:flutter/material.dart';
import 'package:pigment/pigment.dart';

class WelcomeMessage extends StatelessWidget {
  final String name;

  WelcomeMessage({@required this.name});

  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: new EdgeInsets.symmetric(horizontal: 70.0, vertical: 20.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Column(
            children: <Widget>[
              new Text(
                "Hola de nuevo,",
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: new TextStyle(
                  fontFamily: "Muli",
                  color: Pigment.fromString("#162A40"),
                  fontWeight: FontWeight.w400,
                  fontSize: 14.0,
                ),
              ),
              new Text(
                "${this.name.split(" ").length > 1 ? this.name.split(" ").sublist(0, 2).join(" ") : this.name}",
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: new TextStyle(
                  fontFamily: "Muli",
                  color: Pigment.fromString("#162A40"),
                  fontWeight: FontWeight.w600,
                  fontSize: 18.0,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
