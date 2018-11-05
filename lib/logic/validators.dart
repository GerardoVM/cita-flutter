class ValidatorResponse {
  String message;
  bool valid;

  ValidatorResponse({this.message, this.valid = false});
}

ValidatorResponse validateDni(String dni) {
  dni = dni.trim();
  if (dni.length != 8) {
    return new ValidatorResponse(message: "invalid length");
  }

  try {
    int.parse(dni);
  } catch (e) {
    return new ValidatorResponse(message: "invalid dni number");
  }

  return ValidatorResponse(message: "all ok", valid: true);
}

ValidatorResponse validatePassword(String pass) {
  pass = pass.trim();

  if (pass.length != 4) {
    return new ValidatorResponse(message: "invalid length");
  }

  try {
    int.parse(pass);
  } catch (e) {
    return new ValidatorResponse(message: "invalid dni number");
  }

  return ValidatorResponse(message: "all ok", valid: true);
}

ValidatorResponse validateEmail(String email) {
  String p =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  RegExp emailRegExp = new RegExp(p);
  bool isValid = emailRegExp.hasMatch(email);
  if (!isValid) {
    return ValidatorResponse(valid: false, message: "invalid email");
  }
  return ValidatorResponse(valid: true, message: "all ok");
}

ValidatorResponse validateName(String name) {
  name = name.trim();
  if (name.split(" ").length < 2) {
    return new ValidatorResponse(valid: false, message: "invalid name");
  }

  return new ValidatorResponse(valid: true, message: "all ok");
}
