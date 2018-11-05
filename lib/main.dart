import 'package:flutter/material.dart';
import 'package:pigment/pigment.dart';

import './logic/state.dart';
import './logic/store.dart';
import './pages/CameraPage.dart';
import './pages/CategoryPage.dart';
import './pages/HuaycosYCrecidasPage.dart';
import './pages/LoginPage.dart';
import './pages/PrevisualizationVideo.dart';
import './pages/RegisterPage.dart';
import './pages/SaveNewVideo.dart';

bool isAuth;

void main() async {
  localStorage.initStorage().then((_) {
    if (!localStorage.existsStore("user")) {
      localStorage.createNewStore(
        "user",
        userInitState: {
          "dni": "",
          "auth_token": "",
          "auth": false,
        },
      );
      state.storeInit = true;
      isAuth = false;
    } else {
      isAuth = localStorage.getFromStore("user", "auth");
    }
    runApp(new Citapp());
  });
}

class Citapp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'CITA',
      theme: new ThemeData(
        primaryColor: Pigment.fromString('#1867C0'),
      ),
      home: !isAuth ? new LoginPage() : new CategoryPage(),
      routes: {
        "login": (c) => new LoginPage(),
        "register": (c) => new RegisterPage(),
        "category": (c) => new CategoryPage(),
        "haycos": (c) => new HaycosYCrecidasPage(),
        "camera": (c) => new CameraPage(),
        "savevideo": (c) => new SaveNewVideoPage(),
        "preview": (c) => new PreviewVideo(),
      },
    );
  }
}
