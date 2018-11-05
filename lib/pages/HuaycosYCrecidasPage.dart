import 'package:flutter/material.dart';
import 'package:pigment/pigment.dart';
import 'dart:async';

import '../atoms/NoInternetConnection.dart';
import '../logic/classes.dart';
import '../logic/client.dart';

import '../organisms/VideosList.dart';

import 'package:image_picker/image_picker.dart';

import 'package:url_launcher/url_launcher.dart';

import '../logic/state.dart' as s;

class HaycosYCrecidasPage extends StatefulWidget {
  @override
  _HaycosYCrecidasPageState createState() => new _HaycosYCrecidasPageState();
}

class _HaycosYCrecidasPageState extends State<HaycosYCrecidasPage> {
  List<CITAVideo> videos;
  bool connectionOk = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    client.getAllVideos().then((videos) {
      print(videos);
      setState(() {
        this.videos = videos;
      });
    }).catchError((e) {
      setState(() {
        connectionOk = false;
      });
    });
    Future.delayed(Duration.zero, () {
      if (s.state.firstIn) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return new SimpleDialog(
              title: new Text(
                "Lineamientos para la toma de videos",
                style: new TextStyle(
                  fontFamily: 'Muli',
                ),
              ),
              contentPadding: new EdgeInsets.all(20.0),
              children: <Widget>[
                // new Text(
                //   ':\n',
                //   style: new TextStyle(
                //     fontSize: 16.0,
                //     fontFamily: 'Muli',
                //   ),
                // ),

                new Text(
                  '1. Ubicar y pararse en un punto fijo para realizar la grabación.\n\n' +
                      '2. Evita el movimiento excesivo del celular al momento de grabar.\n\n' +
                      '3. El video debe permitir la visualización de todo el ancho de la sección del río.\n',
                  style: new TextStyle(
                    fontFamily: 'Muli',
                  ),
                ),
                new Text(
                  'Aviso importante\n',
                  style: new TextStyle(
                    fontSize: 16.0,
                    fontFamily: 'Muli',
                    fontStyle: FontStyle.italic,
                  ),
                ),
                new Text(
                  'En caso el usuario suba videos que no cumplan con los lineamientos antes descritos, la cuenta del usuario pasará a desactivarse sin previo aviso.\n',
                  style: new TextStyle(
                    fontFamily: 'Muli',
                  ),
                ),
              ],
            );
          },
        ).then((onValue) {
          s.state.firstIn = false;
        }).whenComplete(() {
          s.state.firstIn = false;
        });
      }
    });
  }

  Future getVideoFromGallery() async {
    var video = await ImagePicker.pickVideo(source: ImageSource.gallery);
    if (video != null) {
      s.state.lastVideoRecorded['exist'] = true;
      s.state.lastVideoRecorded['lastVideoRecorded'] = DateTime.now();
      s.state.lastVideoRecorded['path'] = video.uri.toString();
      s.state.lastVideoRecorded['isUploaded'] = true;
      Navigator.pushNamed(context, "preview");
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        iconTheme: new IconThemeData(
          color: Pigment.fromString("#162A40"),
        ),
        centerTitle: true,
        backgroundColor: Pigment.fromString("#FFFFFF"), // Colors.white,
        // elevation: 0.0,
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "camera");
        },
        tooltip: 'Rec a new video',
        backgroundColor: Pigment.fromString('#5ACDBC'),
        child: new Icon(Icons.video_call),
      ),
      bottomNavigationBar: new BottomAppBar(
        color: Pigment.fromString('#FFFFFF'),
        shape: new CircularNotchedRectangle(),
        notchMargin: 6.0,
        // hasNotch: true,
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            // new IconButton(
            //   icon: new Icon(
            //     Icons.menu,
            //     color: Pigment.fromString('#162A40'),
            //   ),
            //   onPressed: () {
            //     showModalBottomSheet<void>(context: context, builder: getPrincipalBottomSheet);
            //   },
            // ),
            new IconButton(
              icon: new Icon(
                Icons.info,
                color: Pigment.fromString('#162A40'),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return new SimpleDialog(
                      title: new Text(
                        "¿Qué es Cazadores de Huaycos?",
                        style: new TextStyle(
                          fontFamily: 'Muli',
                        ),
                      ),
                      contentPadding: new EdgeInsets.all(20.0),
                      children: <Widget>[
                        new Text(
                          'Cazadores de crecidas y huaycos es una iniciativa perteneciente al CITA que busca incentivar la participación de miembros de la comunidad en la toma de datos de campo que ayuden a completar bases de datos sobre caudales en eventos extremos mediante uso de metodologías de medición no intrusivas.',
                          style: new TextStyle(
                            fontFamily: 'Muli',
                          ),
                        ),
                        new Text(
                          'Si quieres conocer más sobre la aplicación y saber cómo funciona, haz clic abajo.',
                          style: new TextStyle(
                            fontFamily: 'Muli',
                          ),
                        ),
                        new FlatButton(
                          onPressed: () async {
                            print('Conoce más');
                            const url = 'https://geoportalcita.wixsite.com/huaycos';
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              throw 'Could not launch $url';
                            }
                          },
                          child: new Text("CONOCE MÁS"),
                        )
                      ],
                    );
                  },
                );
              },
            ),
            new IconButton(
              icon: new Icon(Icons.file_upload),
              onPressed: () async {
                await getVideoFromGallery();
              },
              color: Pigment.fromString('#162A40'),
            ),
          ],
        ),
      ),
      body: this.connectionOk
          ? new VideosList(
              videos: this.videos,
            )
          : new NoInternetConnection(),
    );
  }
}
