import 'package:flutter/material.dart';
import 'package:pigment/pigment.dart';

import '../atoms/CTextField.dart';
import '../atoms/PasswordForget.dart';

class LoginCard extends StatelessWidget {
  final TextEditingController dniController;
  final TextEditingController passwordController;

  final VoidCallback onForgetPassword;

  LoginCard(
      {@required this.dniController, @required this.passwordController, this.onForgetPassword});

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return new Container(
      height: h * 0.41,
      width: w * 0.86,
      decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: new BorderRadius.circular(7.0),
        boxShadow: <BoxShadow>[
          new BoxShadow(
            color: Pigment.fromString("#00000027"),
            blurRadius: 20.0,
            offset: new Offset(0.0, 8.0),
          )
        ],
      ),
      child: new Padding(
        padding: EdgeInsets.only(left: 15.0, right: 15.0, bottom: 10.0),
        child: new Material(
          type: MaterialType.transparency,
          child: new NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (overscroll) {
              overscroll.disallowGlow();
            },
            child: new ListView(
              children: <Widget>[
                new Padding(
                  padding: new EdgeInsets.only(bottom: 15.0),
                  child: new Text(
                    "Login",
                    style: new TextStyle(
                      color: Pigment.fromString("#162A40"),
                      fontFamily: "Muli",
                      fontWeight: FontWeight.w700,
                      fontSize: 24.0,
                    ),
                  ),
                ),
                new CTextField(
                  controller: dniController,
                  isPassword: false,
                  label: "Número de DNI",
                  chars: 8,
                ),
                new CTextField(
                  controller: passwordController,
                  isPassword: true,
                  label: "Contraseña",
                  chars: 4,
                ),
                new Padding(
                  padding: new EdgeInsets.only(top: 40.0, right: 15.0),
                  child: new ForgetPasswordButton(
                    callback: this.onForgetPassword,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
