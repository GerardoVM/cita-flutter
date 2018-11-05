import 'package:flutter/material.dart';
import 'package:pigment/pigment.dart';

import '../atoms/PlainButton.dart';

class SectionCard extends StatelessWidget {
  final String title;
  final String description;
  final String extraInfo;
  final DecorationImage photo;

  final VoidCallback callback;

  SectionCard({
    @required this.title,
    @required this.description,
    @required this.photo,
    this.extraInfo,
    this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: this.callback,
      child: new Container(
        height: 220.0,
        // constraints: BoxConstraints.expand(),
        decoration: new BoxDecoration(
          // gradient: new LinearGradient(
          //   colors: this.colors,
          //   begin: Alignment.topLeft,
          //   end: Alignment.bottomRight,
          // ),
          image: this.photo,
        ),
        padding: new EdgeInsets.only(top: 18.0, left: 18.0, right: 18.0, bottom: 15.0),
        child: new Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              width: 300.0,
              child: new Text(
                this.title.toUpperCase(),
                maxLines: 2,
                textAlign: TextAlign.start,
                style: new TextStyle(
                  fontFamily: "Muli",
                  fontWeight: FontWeight.w900,
                  color: Pigment.fromString("#FFF"),
                  fontSize: 24.0,
                ),
              ),
            ),
            new Padding(
              padding: new EdgeInsets.only(top: 6.0),
              child: new Text(
                this.description,
                style: new TextStyle(
                  fontFamily: "Muli",
                  fontWeight: FontWeight.w400,
                  color: Pigment.fromString("#FFF"),
                  fontSize: 13.0,
                ),
              ),
            ),
            new Container(
              margin: new EdgeInsets.only(top: 20.0),
              alignment: Alignment.bottomCenter,
              child: new Flex(
                direction: Axis.horizontal,
                verticalDirection: VerticalDirection.down,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  new Expanded(
                    flex: 3,
                    child: new Text(
                      this.extraInfo,
                      style: new TextStyle(
                        color: Pigment.fromString("#FFF"),
                        fontFamily: "Muli",
                        fontSize: 11.0,
                      ),
                    ),
                  ),
                  new Padding(
                    padding: new EdgeInsets.only(left: 15.0),
                    child: new PlainButton(
                      text: "ENTRAR",
                      icon: Icons.arrow_forward,
                      callback: this.callback,
                      width: 98.0,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
