import 'package:flutter/material.dart';
import 'package:pigment/pigment.dart';

class PlainButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback callback;
  final double width;

  PlainButton({@required this.text, this.icon, this.callback, this.width});

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: this.callback,
      child: new Container(
        constraints: new BoxConstraints(maxWidth: 200.0),
        width: this.width,
        padding: EdgeInsets.only(top: 9.0, bottom: 9.0, left: 12.12, right: 9.12),
        decoration: new BoxDecoration(
          color: Colors.white,
          borderRadius: new BorderRadius.circular(20.0),
          boxShadow: <BoxShadow>[
            new BoxShadow(
              color: Pigment.fromString("#162A40").withAlpha(20),
              offset: Offset(0.0, 4.0),
              blurRadius: 12.0,
            )
          ],
        ),
        child: new Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new Text(
              this.text,
              style: new TextStyle(
                fontFamily: "Muli",
                color: Pigment.fromString("#162A40"),
                fontWeight: FontWeight.w800,
                fontSize: 12.0,
              ),
            ),
            this.icon != null
                ? new Icon(
                    this.icon,
                    size: 18.0,
                    color: Pigment.fromString("#162A40"),
                  )
                : new Container(),
          ],
        ),
      ),
    );
  }
}
