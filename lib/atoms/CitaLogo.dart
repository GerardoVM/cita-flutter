import 'package:flutter/material.dart';

class CitaLogo extends StatelessWidget {
  final double height;

  CitaLogo({@required this.height});

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Image.asset(
        "assets/images/citalogo.png",
        height: this.height,
        // scale: this.scale,
        // fit: BoxFit.fitHeight,
      ),
    );
  }
}
