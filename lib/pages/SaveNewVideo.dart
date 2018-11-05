import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'dart:async';

import 'package:pigment/pigment.dart';

import '../atoms/Snackbar.dart';
import '../atoms/StaticMap.dart';
import '../atoms/UploadingVideo.dart';
import '../atoms/NoGPS.dart';

import '../logic/client.dart';
import '../logic/state.dart' as state;

class SaveNewVideoPage extends StatefulWidget {
  @override
  _SaveNewVideoPageState createState() => new _SaveNewVideoPageState();
}

class _SaveNewVideoPageState extends State<SaveNewVideoPage> {
  double latitude, longitude;
  bool uploading = false;
  bool isFromFile = false;
  String place = "Escriba una ubicación";
  bool gpsActivated = false;
  Timer timerWatchDog;
  TextEditingController titleController = new TextEditingController();
  TextEditingController locationController = new TextEditingController();

  onSaveVideo(BuildContext context) async {
    String title = titleController.text.trim();
    print("title: $title");
    if (title == "") {
      showBasicSnackBar(context, "Por favor coloca un título al video");
      return;
    } else if (title.length < 5) {
      showBasicSnackBar(context, "El título del video debe tener al menos 5 caracteres");
      return;
    }

    print(title);

    if (state.state.lastVideoRecorded['exist']) {
      String filepath = state.state.lastVideoRecorded['path'];
      setState(() {
        this.uploading = true;
      });
      state.state.title = titleController.text;
      state.state.savedCoordinates['latitude'] = this.latitude;
      state.state.savedCoordinates['longitude'] = this.longitude;
      Map place = await client.getPlaceByGeoLocation(this.latitude, this.longitude);
      state.state.finalPlace = place['place_name'];

      // s.State.title = place['title'];
      bool isAlive = await client.ping();
      if (!isAlive) {
        // Put video to Queque
      }
      try {
        client.uploadVideo(filepath).then((_) {
          setState(() {
            this.uploading = false;
            state.state.lastVideoRecorded['exist'] = false;
            goToDashboard();
          });
        });
      } catch (e) {}
    } else {
      // Mega error
    }
  }

  goToDashboard() {
    try {
      Navigator.of(context).pushNamedAndRemoveUntil("category", (r) => false);
      Navigator.of(context).pushNamed("haycos");
      return;
    } catch (e) {
      Navigator.of(context).pushNamed("haycos");
      return;
    }
  }

  @override
  void initState() {
    super.initState();
    this.isFromFile = state.state.lastVideoRecorded['isUploaded'];
    locationController.addListener(() {
      print(locationController.text);
      client.getLocationWithName(locationController.text).then((location) {
        this.setState(() {
          this.place = location.place;
          this.longitude = location.longitude;
          this.latitude = location.latitude;
        });
      });
    });

    timerWatchDog = Timer.periodic(Duration(seconds: 2), (timer) async {
      print("--------> In the timer");
      if (!this.gpsActivated) {
        print("--------> In the gps checking");
        Position p = await Geolocator()
            .getCurrentPosition(LocationAccuracy.high)
            .timeout(Duration(milliseconds: 1500), onTimeout: () {
          return null;
        });

        print("Position checking $p");
        if (p != null) {
          setState(() {
            this.latitude = p.latitude;
            this.longitude = p.longitude;
            this.gpsActivated = true;
          });
          timer.cancel();
        }
      } else {
        timer.cancel();
      }
    });

    Geolocator().checkGeolocationPermissionStatus().then((status) {
      print("============> GPS STATUS: $status");

      switch (status) {
        case GeolocationStatus.granted:
          print("============> Getting position");
          Geolocator().getCurrentPosition(LocationAccuracy.high).then((position) {
            print("============> Position Allowed");
            print(position);
            if (position != null) {
              print(position.toString());

              state.state.savedCoordinates['latitude'] = position.latitude;
              state.state.savedCoordinates['longitude'] = position.longitude;
              state.state.savedCoordinates['altitude'] = position.altitude;

              setState(() {
                this.latitude = position.latitude;
                this.longitude = position.longitude;
                this.gpsActivated = true;
              });
            }
          }).catchError((e) {
            print("============> Error");
            setState(() {
              this.gpsActivated = false;
            });
            print("Error at try to get gps service: $e");
          });
          break;
        case GeolocationStatus.disabled:
          setState(() {
            this.gpsActivated = false;
          });

          break;
        default:
          print("errors");
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if (this.timerWatchDog != null) {
      timerWatchDog.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    bool keyboardHidden = MediaQuery.of(context).viewInsets.bottom == 0.0;
    print(this.isFromFile);
    print("Gps status--> ${this.gpsActivated}");
    return new Scaffold(
//        resizeToAvoidBottomPadding: false,
      appBar: new AppBar(
        iconTheme: new IconThemeData(
          color: Pigment.fromString("#162A40"),
        ),
        centerTitle: true,
        backgroundColor: Pigment.fromString("#FFFFFF"), // Colors.white,
//          elevation: 0.0,
        title: new Text(
          "Huaycos y crecidas",
          style: new TextStyle(
            color: Pigment.fromString("#162A40"),
            fontFamily: "StagSans",
            fontSize: 20.0,
            letterSpacing: 0.3,
          ),
        ),
      ),
      floatingActionButton: this.uploading
          ? null
          : new Builder(
              builder: (context) {
                return this.gpsActivated
                    ? new FloatingActionButton(
                        onPressed: () => onSaveVideo(context),
                        backgroundColor: Pigment.fromString("#FF5E7A"),
                        child: new Icon(Icons.save),
                        elevation: 3.0,
                      )
                    : new FloatingActionButton(
                        onPressed: () {},
                        backgroundColor: Pigment.fromString("#374F6D"),
                        child: new Icon(Icons.save),
                        elevation: 3.0,
                      );
              },
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: this.gpsActivated
          ? this.uploading
              ? new UploadingVideo()
              : Container(
                  child: new Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      new Padding(
                        padding: new EdgeInsets.only(top: 15.0, bottom: 15.0),
                        child: new Text(
                          "NUEVO VIDEO",
                          style: new TextStyle(
                            fontFamily: "StagSans",
                            color: Pigment.fromString("#162A40"),
                            fontSize: 22.0,
                          ),
                        ),
                      ),
                      keyboardHidden
                          ? new StaticMap(
                              latitude: this.latitude,
                              longitude: this.longitude,
                              pitch: 0.0,
                              zoomLevel: 14.5,
                            )
                          : new Container(),
                      new Padding(
                        padding: new EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Text(
                              "LATITUD: ${this.latitude}",
                              style: new TextStyle(
                                color: Pigment.fromString("#657E9A"),
                                fontFamily: "Muli",
                                fontSize: 12.0,
                              ),
                            ),
                            new Text(
                              "LONGITUD: ${this.longitude}",
                              style: new TextStyle(
                                color: Pigment.fromString("#657E9A"),
                                fontFamily: "Muli",
                                fontSize: 12.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                      new Padding(
                        padding: new EdgeInsets.symmetric(horizontal: 20.0),
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            this.isFromFile
                                ? new Padding(
                                    padding: new EdgeInsets.only(top: 10.0),
                                    child: new Text(
                                        "Lugar seleccionado: ${this.place == null ? "Escriba una ubicación diferente" : this.place}"),
                                  )
                                : new Container(),
                            this.isFromFile
                                ? new Padding(
                                    padding: new EdgeInsets.only(top: 15.0, bottom: 15.0),
                                    child: new TextField(
                                      controller: locationController,
                                      style: new TextStyle(
                                        fontFamily: "Muli",
                                        color: Pigment.fromString("#162A40"),
                                      ),
                                      decoration: new InputDecoration(
                                        labelText: "Ubicación",
                                        border: new OutlineInputBorder(),
                                      ),
                                    ),
                                  )
                                : new Container(),
                            new Padding(
                              padding: new EdgeInsets.only(top: 15.0, bottom: 15.0),
                              child: new Text(
                                "Colocale un título a tu video",
                                style: new TextStyle(
                                  fontFamily: "Muli",
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                  color: Pigment.fromString("#162A40"),
                                ),
                              ),
                            ),
                            new TextField(
                              controller: titleController,
                              style: new TextStyle(
                                fontFamily: "Muli",
                                color: Pigment.fromString("#162A40"),
                              ),
                              decoration: new InputDecoration(
                                labelText: "Título",
                                border: new OutlineInputBorder(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
          : new Container(
              child: new NoGPS(),
            ),
    );
  }
}
