import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:pigment/pigment.dart';

class SquareBack extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Transform.rotate(
      angle: -75 * (2 * math.pi / 180),
      child: new Container(
        width: 340.0,
        height: 340.0,
        decoration: new BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          boxShadow: <BoxShadow>[
            new BoxShadow(
              color: Pigment.fromString('#3FC1C9').withAlpha(54),
              blurRadius: 13.0,
              offset: Offset(0.0, -10.0),
            ),
          ],
          gradient: new LinearGradient(
            begin: AlignmentDirectional.bottomEnd,
            end: AlignmentDirectional(-1.0, 1.5),
            colors: <Color>[
              Pigment.fromString('#1867C0'),
              Pigment.fromString('#37DDE8'),
            ],
          ),
        ),
      ),
    );
  }
}
