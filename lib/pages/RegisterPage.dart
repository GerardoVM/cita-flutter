import 'package:flutter/material.dart';

import '../atoms/BasicLoading.dart';
import '../atoms/Snackbar.dart';
import '../logic/client.dart';
import '../logic/state.dart' as s;
import '../logic/validators.dart';
import '../molecules/RegisterCard.dart';
import '../templates/LoginRegScreen.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => new _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController dniController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  // TextEditingController password2Controller = new TextEditingController();
  TextEditingController nameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();

  bool loading = false;

  onLogin() {
    Navigator.of(context).popAndPushNamed("login");
  }

  updateLoader() {
    if (this.loading) {
      showDialog(
          context: context,
          builder: (c) {
            return BasicLoading();
          });
//		  loading = true;
    } else {
      if (!this.loading) {
        Navigator.of(context).pop();
//			  loading = false;
      }
    }
  }

  onRegister(BuildContext context) {
    String dni = dniController.text;
    String email = emailController.text;
    String pass = passwordController.text;
    String name = nameController.text;

    ValidatorResponse validDNI = validateDni(dni);
    ValidatorResponse validEmail = validateEmail(email);
    ValidatorResponse validPass = validatePassword(pass);
    ValidatorResponse validName = validateName(name);

    if (!validDNI.valid) {
      showBasicSnackBar(context, "DNI inválido");
      return;
    } else if (!validEmail.valid) {
      showBasicSnackBar(context, "Email inválido");
      return;
    } else if (!validPass.valid) {
      showBasicSnackBar(context, "Contraseña inválida");
      return;
    } else if (!validName.valid) {
      showBasicSnackBar(context, "Nombre inválido");
      return;
    }

    Map payload = {
      'dni': dni,
      'email': email,
      'password': pass,
      'name': name,
    };

    setState(() {
      this.loading = true;
      updateLoader();
    });

    client.signUp(payload).then((r) {
      print("r.ok = ${r.ok}");
      if (r.ok) {
        s.state.justRegistered = true;
        print(r.dni);
        s.state.dniOfNewRegistered = r.dni;
        setState(() {
          this.loading = false;
          updateLoader();
        });
        setState(() {
          this.loading = false;
          updateLoader();
        });
        goToLogin();
        return;
      }

      setState(() {
        this.loading = false;
        updateLoader();
      });

      showBasicSnackBar(context, r.message);
    });
//    print(payload);
  }

  goToLogin() {
    print("go to login");
    Navigator.of(context).popAndPushNamed("login");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      body: new Builder(
        builder: (context) {
          return new Hero(
            tag: "background",
            child: new LoginRegisterBase(
              type: LRBaseType.register,
              callback: (CallbackType e) =>
                  (e == CallbackType.first ? onLogin() : onRegister(context)),
              child: new Hero(
                tag: "card",
                child: new RegisterCard(
                  scaffoldContext: context,
                  dniController: this.dniController,
                  passwordController: this.passwordController,
                  nameController: this.nameController,
                  emailController: this.emailController,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
