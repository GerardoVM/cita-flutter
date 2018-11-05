import 'package:flutter/material.dart';

import '../atoms/CButton.dart';
import '../atoms/CitaLogo.dart';
import '../atoms/SquareBack.dart';

enum LRBaseType {
  login,
  register,
}

enum CallbackType {
  first,
  second,
}

typedef LRCallback(CallbackType action);

class LoginRegisterBase extends StatelessWidget {
  final Widget child;
  final LRBaseType type;
  final LRCallback callback;

  LoginRegisterBase({@required this.type, @required this.child, @required this.callback});

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    // double h = MediaQuery.of(context).size.height;
    return new Container(
      color: Colors.white,
      child: new Stack(
        children: <Widget>[
          new Positioned(
            top: -190.0, // -0.2 * h,
            right: -60.0,
            child: new SquareBack(),
          ),
          new Positioned(
            top: 120.0,
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new Padding(
                  padding: new EdgeInsets.all(25.0),
                  child: new CitaLogo(
                    height: 60.0,
                  ),
                ),
              ],
            ),
          ),
          new Positioned(
            width: w,
            bottom: 30.0,
            child: new Container(
              margin: new EdgeInsets.only(top: 130.0),
              color: Colors.transparent,
              child: new Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  this.child,
                  new Padding(
                    padding: new EdgeInsets.only(
                      left: w * 0.07,
                      right: w * 0.07,
                      top: this.type == LRBaseType.register ? 20.0 : 35.0,
                    ),
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        this.type == LRBaseType.login
                            ? new CButton(
                                type: ButtonType.secondary,
                                onTap: () => this.callback(CallbackType.first),
                                text: "CREA TU CUENTA",
                              )
                            : new CButton(
                                type: ButtonType.secondary,
                                onTap: () => this.callback(CallbackType.first),
                                text: "INGRESAR",
                              ),
                        new CButton(
                          type: ButtonType.primary,
                          onTap: () => this.callback(CallbackType.second),
                          text: this.type == LRBaseType.login ? "INGRESAR" : "REGISTRARSE",
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
