import 'package:flutter/material.dart';
import 'package:pigment/pigment.dart';

// void showDialog(BuildContext context, String message) {
//   showDialog(context, message)
// }

class BasicLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Dialog(
      child: new Container(
        height: 80.0,
        child: new Padding(
          padding: new EdgeInsets.symmetric(horizontal: 30.0),
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              new CircularProgressIndicator(
                backgroundColor: Colors.redAccent,
                strokeWidth: 4.0,
                valueColor: new AlwaysStoppedAnimation<Color>(
                  Pigment.fromString("#50E8D7"),
                ),
              ),
              new Expanded(
                  child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Text(
                    "Cargando",
                    style: new TextStyle(
                      fontFamily: "Muli",
                      fontSize: 20.0,
                      color: Pigment.fromString("#162A40"),
                    ),
                  ),
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
