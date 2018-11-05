import 'package:flutter/material.dart';
import 'package:pigment/pigment.dart';

class ForgetPasswordButton extends StatelessWidget {
  final VoidCallback callback;

  ForgetPasswordButton({this.callback});

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: this.callback,
      child: new Text(
        "¿Olvidaste tu contraseña?",
        textAlign: TextAlign.end,
        style: new TextStyle(
          color: Pigment.fromString("#1867C0"),
          fontSize: 12.0,
          fontFamily: "Muli",
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
