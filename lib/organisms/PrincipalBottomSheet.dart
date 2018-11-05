import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Widget getPrincipalBottomSheet(BuildContext context) {
  return new Material(
      type: MaterialType.transparency,
      child: new ClipRRect(
        borderRadius: new BorderRadius.circular(20.0),
        child: new Container(
          decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.only(
                topLeft: new Radius.circular(20.0),
                topRight: new Radius.circular(20.0),
              )),
          child: new Container(
            height: 200.0,
            child: new Padding(
              padding: const EdgeInsets.all(10.0),
              child: new ListView(
                children: <Widget>[
                  new ListTile(
                    onTap: () async {
                      const url = 'https://youtu.be/GX-YPXreCM8';
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                    leading: new Icon(Icons.import_contacts),
                    title: new Text('Mira como funciona nuestra app'),
                  ),
                  new ListTile(
                    onTap: () async {
                      const url = 'https://geoportalcita.wixsite.com/huaycos';
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                    leading: new Icon(Icons.info),
                    title: new Text('¿Qué es Cazadores de Huaycos?'),
                  ),
                  new ListTile(
                    onTap: () {
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
                                'Los videos enviados deberán de seguir los siguientes lineamientos:\nLa resolución mínima del video debe ser de 640 x 480 píxeles.\nUbicar y pararse en un punto fijo para realizar la grabación.\nEvitar el movimiento excesivo del celular al momento de grabar.\nEl video debe permitir la visualización de todo el ancho de la sección del río.\nEl video debe permitir identificar puntos fijos y permanentes que estén cerca de la elevación de la superficie del agua, mínimo cuatro (4) puntos.\n\n',
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
                      );
                    },
                    leading: new Icon(Icons.chat_bubble_outline),
                    title: new Text('Lineamientos para la toma de videos'),
                  )
                ],
              ),
            ),
          ),
        ),
      ));
}
