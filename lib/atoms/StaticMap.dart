import 'package:flutter/material.dart';

import '../logic/endpoints.dart';

class StaticMap extends StatelessWidget {
  final double zoomLevel;
  final double pitch;
  final double latitude, longitude;

  StaticMap({
    @required this.latitude,
    @required this.longitude,
    this.zoomLevel = 14.0,
    this.pitch = 60.0,
  });

  @override
  Widget build(BuildContext context) {
    String map = mapBoxStaticMap(this.latitude, this.longitude, this.zoomLevel, this.pitch);
    bool isIncorrect = this.latitude == null || this.longitude == null;

    double w = MediaQuery.of(context).size.width;
    return new Container(
      // height: 300.0,
      width: w,
      child: isIncorrect
          ? new Center(
              child: new Text("Loading map..."),
            )
          : new Image.network(
              map,
              fit: BoxFit.fitWidth,
            ),
    );
  }
}
