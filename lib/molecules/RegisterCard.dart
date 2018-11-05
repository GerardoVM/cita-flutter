import 'package:flutter/material.dart';
import 'package:pigment/pigment.dart';

import '../atoms/CTextField.dart';
import '../atoms/Snackbar.dart';

class RegisterCard extends StatelessWidget {
  final TextEditingController dniController;
  final TextEditingController emailController;

  // TextEditingController password1Controller;
  // TextEditingController password2Controller;
  final TextEditingController nameController;
  final TextEditingController passwordController;
  final BuildContext scaffoldContext;

  RegisterCard({
    @required this.scaffoldContext,
    @required this.dniController,
    @required this.emailController,
    @required this.nameController,
    @required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return new Container(
      height: h * 0.5,
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
                    "Regístrate",
                    style: new TextStyle(
                      color: Pigment.fromString("#162A40"),
                      fontFamily: "Muli",
                      fontWeight: FontWeight.w700,
                      fontSize: 22.0,
                    ),
                  ),
                ),
                new Padding(
                  padding: new EdgeInsets.only(bottom: 9.0),
                  child: new CTextField(
                    controller: this.nameController,
                    isPassword: false,
                    label: "Nombre Completo",
                    chars: -1,
                  ),
                ),
                new Padding(
                  padding: new EdgeInsets.only(bottom: 9.0),
                  child: new CTextField(
                    controller: this.emailController,
                    isPassword: false,
                    label: "Email",
                    chars: -1,
                  ),
                ),
                new GestureDetector(
                  child: new CTextField(
                    controller: this.dniController,
                    isPassword: false,
                    label: "Número de DNI",
                    chars: 8,
                  ),
                  onTap: () {
                    showBasicSnackBar(this.scaffoldContext,
                        "Requerimos tu DNI debido a que es un documento que te identifica como usuario único.");
                  },
                ),
                new CTextField(
                  controller: this.passwordController,
                  isPassword: true,
                  label: "Contraseña (de 4 digitos)",
                  chars: 4,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
