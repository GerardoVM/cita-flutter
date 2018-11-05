import 'package:flutter/material.dart';

void showBasicSnackBar(BuildContext context, String message) {
  SnackBar snackBar = SnackBar(
    content: Text(
      message,
      style: new TextStyle(
        fontFamily: "Muli",
      ),
    ),
    duration: new Duration(seconds: 3),
  );

  Scaffold.of(context).showSnackBar(snackBar);
}
