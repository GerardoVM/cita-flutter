import 'package:flutter/material.dart';
import 'package:pigment/pigment.dart';

enum ButtonType {
  primary,
  secondary,
}

class CButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final ButtonType type;

  CButton({@required this.onTap, @required this.text, @required this.type});

  @override
  Widget build(BuildContext context) {
    LinearGradient gradient = new LinearGradient(
      begin: AlignmentDirectional.bottomEnd,
      end: AlignmentDirectional(-1.0, 1.5),
      colors: <Color>[
        Pigment.fromString('#1867C0'),
        Pigment.fromString('#37DDE8'),
      ],
    );

    List<BoxShadow> shadow = <BoxShadow>[
      new BoxShadow(
        color: Pigment.fromString('#3FC1C9').withAlpha(120),
        blurRadius: 20.0,
        offset: Offset(0.0, 10.0),
        spreadRadius: -5.0,
      ),
    ];

    EdgeInsets basicPadding = new EdgeInsets.symmetric(horizontal: 31.04, vertical: 15.09);
    EdgeInsets wBasicPadding = new EdgeInsets.symmetric(horizontal: 12.04, vertical: 16.85);

    return new GestureDetector(
      onTap: this.onTap,
      child: new Container(
        decoration: new BoxDecoration(
          borderRadius: BorderRadius.circular(7.0),
          gradient: this.type == ButtonType.primary ? gradient : null,
          color: this.type == ButtonType.primary ? null : Pigment.fromString("#374F6D14"),
          boxShadow: this.type == ButtonType.primary ? shadow : null,
        ),
        padding: this.type == ButtonType.primary ? basicPadding : wBasicPadding,
        child: new Material(
          type: MaterialType.transparency,
          child: new Text(
            this.text,
            textAlign: TextAlign.center,
            style: new TextStyle(
              decoration: null,
              decorationStyle: null,
              color: this.type == ButtonType.primary ? Colors.white : Pigment.fromString("#162A40"),
              fontFamily: "Muli",
              fontWeight: FontWeight.w700,
              fontSize: this.type == ButtonType.primary ? 14.0 : 12.0,
            ),
          ),
        ),
      ),
    );
  }
}
