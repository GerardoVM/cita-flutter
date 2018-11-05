import 'package:flutter/material.dart';
import 'package:pigment/pigment.dart';

class UploadingVideo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      constraints: new BoxConstraints.expand(),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Image.asset(
            "assets/images/loading.gif",
            scale: 1.5,
          ),
          new Text(
            "SUBIENDO VIDEO",
            style: new TextStyle(
              fontFamily: "StagSans",
              color: Pigment.fromString("#162A40"),
              fontSize: 26.0,
            ),
          ),
          new Text(
            "Esto puede tardar unos minutos",
            style: new TextStyle(
              fontFamily: "Muli",
              color: Pigment.fromString("#162A40"),
              fontSize: 12.0,
              letterSpacing: 0.78,
            ),
          ),
        ],
      ),
    );
  }
}
