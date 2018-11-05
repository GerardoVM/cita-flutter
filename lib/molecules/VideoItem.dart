import 'package:flutter/material.dart';
import 'package:pigment/pigment.dart';

import '../logic/classes.dart';

class VideoItem extends StatelessWidget {
  final CITAVideo video;

  VideoItem({@required this.video});

  String dateTime2Readable(DateTime date) {
    Map months = {
      1: 'Enero',
      2: 'Febrero',
      3: 'Marzo',
      4: 'Abril',
      5: 'Mayo',
      6: 'Junio',
      7: 'Julio',
      8: 'Agosto',
      9: 'Setiembre',
      10: 'Octubre',
      11: 'Noviembre',
      12: 'Diciembre',
    };
    return '${date.day} de ${months[date.month]} del ${date.year} a las ${date.hour}:${date.minute}';
  }

  @override
  Widget build(BuildContext context) {
    double height = 88.0;

    return new Container(
      height: height,
      decoration: new BoxDecoration(
        borderRadius: new BorderRadius.circular(4.0),
        color: Colors.white,
        boxShadow: <BoxShadow>[
          new BoxShadow(
            color: Pigment.fromString("#374F6D").withAlpha(75),
            blurRadius: 5.0,
            offset: new Offset(0.0, 2.0),
            // spreadRadius: -10.0,
          )
        ],
      ),
      child: new ClipRRect(
        borderRadius: new BorderRadius.circular(4.0),
        child: new Row(
          children: <Widget>[
            new Container(
              height: height * 10.5,
              width: 102.0,
              decoration: new BoxDecoration(
                borderRadius: new BorderRadius.only(
                  topRight: new Radius.circular(60.0),
                  bottomRight: new Radius.circular(60.0),
                ),
                image: new DecorationImage(
                  image: new MemoryImage(this.video.remoteThumb),
                  fit: BoxFit.fill,
                  alignment: Alignment.center,
                ),
              ),
              child: new Container(
                height: height * 10.5,
                decoration: new BoxDecoration(
                  color: Pigment.fromString("#162A40").withAlpha(120),
                  borderRadius: new BorderRadius.only(
                    topRight: new Radius.circular(50.0),
                    bottomRight: new Radius.circular(50.0),
                  ),
                ),
                // child: new Icon(
                //   Icons.play_circle_outline,
                //   size: 40.0,
                //   color: Colors.white,
                // ),
              ),
            ),
            new Expanded(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  new Padding(
                    padding: new EdgeInsets.only(top: 9.0, left: 20.0, right: 25.0),
                    child: new Text(
                      this.video.title.toUpperCase(),
                      textAlign: TextAlign.end,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      softWrap: true,
                      style: new TextStyle(
                        fontFamily: "Muli",
                        color: Pigment.fromString("#162A40"),
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  new Padding(
                    padding: new EdgeInsets.only(top: 3.0, left: 20.0, right: 25.0),
                    child: new Text(
                      this.video.location,
                      textAlign: TextAlign.end,
                      maxLines: 2,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: new TextStyle(
                        fontFamily: "Muli",
                        color: Pigment.fromString("#162A40"),
                        fontSize: 11.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  new Padding(
                    padding: new EdgeInsets.only(top: 6.0, right: 25.0, left: 20.0, bottom: 8.0),
                    child: new Text(
                      dateTime2Readable(this.video.date),
                      textAlign: TextAlign.end,
                      maxLines: 1,
                      softWrap: true,
                      style: new TextStyle(
                        fontFamily: "Muli",
                        color: Pigment.fromString("#374F6D"),
                        fontSize: 10.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
