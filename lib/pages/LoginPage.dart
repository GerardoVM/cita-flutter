import 'package:flutter/material.dart';
import 'package:pigment/pigment.dart';

import '../atoms/BasicLoading.dart';
import '../atoms/Snackbar.dart';
import '../atoms/CTextField.dart';
import '../logic/client.dart';
import '../logic/state.dart' as s;
import '../logic/store.dart';
import '../logic/validators.dart';
import '../molecules/LoginCard.dart';
import '../templates/LoginRegScreen.dart';

import '../atoms/CButton.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController dniController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  bool loading = false;
  bool showingLoader = false;

  @override
  void initState() {
    super.initState();
    print("init state");
    print(s.state.justRegistered);
    print(s.state.dniOfNewRegistered);

    if (s.state.justRegistered) {
      dniController.text = s.state.dniOfNewRegistered;
      s.state.justRegistered = false;
      s.state.dniOfNewRegistered = "";
    }
  }

  updateLoader() {
    if (loading) {
      showDialog(
          context: context,
          builder: (c) {
            return BasicLoading();
          });
      showingLoader = true;
    } else {
      if (showingLoader) {
        Navigator.of(context).pop();
        showingLoader = false;
      }
    }
  }

  onLogin(BuildContext context) {
    setState(() {
      loading = true;
      updateLoader();
    });

    print("dni: ${dniController.text}\npassword: ${passwordController.text}");

    ValidatorResponse validDni = validateDni(dniController.text);
    ValidatorResponse validPass = validatePassword(passwordController.text);

    if (validDni.valid && validPass.valid) {
      client.login(dniController.text.trim(), passwordController.text.trim()).then((r) {
        switch (r) {
          case LoginResponse.Successful:
            print(localStorage.getFromStore("user", "auth_token"));
            setState(() {
              loading = false;
              updateLoader();
            });
            goToCategoryPage();
            break;
          case LoginResponse.IncorrectCredentials:
            // dniController.text = "";
            passwordController.text = "";
            showBasicSnackBar(
              context,
              "Dni o Contraseña invalidos, revisalos por favor",
            );
            setState(() {
              loading = false;
              updateLoader();
            });
            break;
          case LoginResponse.HttpProblem:
            showBasicSnackBar(
              context,
              "Ups, parece que tenemos problemas con nuestros servidores",
            );
            print("problems with servers");
            setState(() {
              loading = false;
              updateLoader();
            });
            break;
          case LoginResponse.Timeout:
            showBasicSnackBar(
              context,
              "Verifica que tengas conexion a internet",
            );
            print("timeout");
            setState(() {
              loading = false;
              updateLoader();
            });
            break;
          default:
            print(";_;");
            setState(() {
              loading = false;
              updateLoader();
            });
        }
      });
    } else {
      dniController.text = "";
      passwordController.text = "";
      showBasicSnackBar(
        context,
        "${validDni.message}, ${validPass.message}",
      );
      setState(() {
        loading = false;
        updateLoader();
      });
      // TODO: Implement errors
    }
  }

  onRegister() {
    Navigator.of(context).pushNamed("register");
  }

  onForget(context) {
    BuildContext superContext = context;
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController controller = new TextEditingController();
        // String miniMessage = "Dni inválido, por favor ingrese uno nuevo";

        return new SimpleDialog(
          title: new Text(
            "Recupera tu contraseña",
            style: new TextStyle(
              color: Pigment.fromString("#162A40"),
              fontFamily: "Muli",
            ),
          ),
          children: <Widget>[
            new Padding(
              child: new Text(
                "Ingrese su numero de DNI y pronto le llegará su contraseña al correo asociado.",
                style: new TextStyle(
                  color: Pigment.fromString("#162A40"),
                  fontFamily: "Muli",
                ),
              ),
              padding: new EdgeInsets.all(20.0),
            ),
            new Padding(
              child: new CTextField(
                controller: controller,
                chars: 8,
                label: "DNI",
                isPassword: false,
              ),
              padding: new EdgeInsets.symmetric(horizontal: 20.0),
            ),
            // new Text(miniMessage),
            new Padding(
              padding: new EdgeInsets.only(
                top: 20.0,
              ),
              child: new Padding(
                padding: new EdgeInsets.symmetric(horizontal: 20.0),
                child: new CButton(
                  onTap: () async {
                    print("Enviando... ${controller.text}");
                    showDialog(
                      context: context,
                      builder: (context) {
                        return new BasicLoading();
                      },
                      barrierDismissible: false,
                    );
                    String resp = await client.launchRecoveryPassword(controller.text);

                    if (resp.contains("ok")) {
                      print("okkkkkkk");
                      Navigator.pop(context);
                      Navigator.pop(context);
                      return;
                    }
                    showBasicSnackBar(superContext, "Dni inválido, por favor ingrese uno nuevo");
                    Navigator.pop(context);
                  },
                  text: "ENVIAR",
                  type: ButtonType.primary,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  goToCategoryPage() {
    print("goooo");
    Navigator.of(context).pushNamed("category");
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      // appBar: new AppBar(),
      resizeToAvoidBottomPadding: false,
      body: new Builder(
        builder: (context) {
          return new Hero(
            tag: "background",
            child: new LoginRegisterBase(
              type: LRBaseType.login,
              callback: (CallbackType e) =>
                  (e == CallbackType.second ? onLogin(context) : onRegister()),
              child: new Hero(
                tag: "card",
                child: new LoginCard(
                  dniController: dniController,
                  passwordController: passwordController,
                  onForgetPassword: () => onForget(context),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
