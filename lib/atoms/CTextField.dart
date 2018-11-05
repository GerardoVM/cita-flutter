import 'package:flutter/material.dart';
import 'package:pigment/pigment.dart';

class CTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool isPassword;
  final int chars;

  CTextField({@required this.controller, this.label, this.isPassword, this.chars});

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: new EdgeInsets.symmetric(horizontal: 15.0),
      child: new TextField(
        controller: this.controller,
        obscureText: this.isPassword,
        maxLength: this.chars == -1 ? null : this.chars,
        keyboardType: this.chars == -1
            ? TextInputType.emailAddress
            : this.chars == -2 ? TextInputType.text : TextInputType.number,
        style: new TextStyle(
          fontFamily: "Muli",
          fontSize: 12.0,
          color: Pigment.fromString("#162A40"),
        ),
        decoration: new InputDecoration(
          labelText: this.label,
          counterStyle: new TextStyle(fontSize: 0.0),

          // contentPadding: new EdgeInsets.only(top: 5.0, bottom: 10.0),
        ),
      ),
    );
  }
}
