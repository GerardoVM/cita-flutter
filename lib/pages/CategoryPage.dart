import 'package:flutter/material.dart';
import 'package:pigment/pigment.dart';

import '../atoms/WelcomeMessage.dart';
import '../logic/classes.dart';
import '../logic/client.dart';
import '../logic/store.dart';
import '../molecules/SectionCard.dart';

import '../logic/state.dart' as s;

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  UserInfo userInfo;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    client.getUserInfo().then((info) {
      print(info.name);
      setState(() {
        userInfo = info;
      });
    });
  }

  onLogout() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (c) {
        return new SimpleDialog(
          title: new Text("¿Estás seguro que deseas cerrar sesión?"),
          children: <Widget>[
            new SimpleDialogOption(
              child: new Text("SI"),
              onPressed: () {
                print("yes");
                if (localStorage.existsStore("user")) {
                  localStorage.saveToStore("user", "auth", false);
                  localStorage.saveToStore("user", "auth_token", "");
                  Navigator.of(context).pushReplacementNamed("login");
                } else {}
              },
            ),
            new SimpleDialogOption(
              child: new Text("NO"),
              onPressed: () {
                print("no");
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        backgroundColor: Pigment.fromString("#FFFFFF"), // Colors.white,
        // elevation: 0.0,
        title: new Text(
          "cita",
          style: new TextStyle(
            color: Pigment.fromString("#162A40"),
            fontFamily: "StagSans",
            fontSize: 30.0,
            letterSpacing: 0.3,
          ),
        ),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(
              Icons.exit_to_app,
              color: Pigment.fromString("#162A40"),
            ),
            onPressed: onLogout,
          )
        ],
      ),
      body: new Container(
        child: new Column(
          children: <Widget>[
            new WelcomeMessage(name: userInfo != null ? userInfo.name : "Cargando..."),
            new Expanded(
              child: new ListView(
                physics: ClampingScrollPhysics(),
                children: <Widget>[
                  new SectionCard(
                    title: "Cazadores de Huaycos y Crecidas",
                    description:
                        "Ayúdanos a hacer un seguimiento de los huaycos y crecidas, con tu aporte lograremos cosas grandiosas.",
                    extraInfo: "En colaboración con el CETA, Universidad de Córdoba, Argentina.",
                    photo: new DecorationImage(
                      image: AssetImage("assets/images/background1.png"),
                      fit: BoxFit.cover,
                    ),
                    callback: () {
                      s.state.firstIn = true;
                      Navigator.of(context).pushNamed("haycos");
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
