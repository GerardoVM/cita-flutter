import 'dart:async';
import 'dart:convert' as convert;
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'classes.dart';
import 'endpoints.dart';
import 'state.dart';
import 'store.dart';

enum LoginResponse {
  IncorrectCredentials,
  Successful,
  HttpProblem,
  Timeout,
}

class SignUpResponse {
  bool ok;
  String message;
  String dni;

  SignUpResponse({this.ok, this.message, this.dni});
}

class GeoCodingResponse {
  String place;
  double longitude;
  double latitude;

  GeoCodingResponse({this.place, this.longitude, this.latitude});
}

class CITAClient {
  http.Client client;

  bool notConnection = false;

  CITAClient() {
    this.client = new http.Client();
  }

  Future<Map<String, String>> getPlaceByGeoLocation(double lat, lon) async {
    String uriWToken = mapboxLocation(lat, lon);
    print(uriWToken);
    http.Response response;
    try {
      response = await this.client.get(uriWToken).timeout(
        Duration(seconds: 10),
        onTimeout: () {
          print('timeouttttttttttt');
        },
      );
    } catch (e) {
      print("no connection");
    }

    if (response == null) {
      throw 'Timeout or connection error';
    }

    Map geocodeFeatures = convert.json.decode(response.body);

    if (geocodeFeatures['type'] != 'FeatureCollection') {
      throw 'Bad response from mapbox';
    }

    List features = geocodeFeatures['features'];
    features.sort((item, i) {
      return item['relevance'];
    });
    // Most relevant feature
    Map important;
    for (var f in features) {
      if (f['place_type'].contains('poi')) {
        important = f;
        break;
      }
    }

    if (important == null) return null;

    return {
      "place_name": important['place_name'],
      "title": important["text"],
    };
  }

  Future<List<CITAVideo>> getAllVideos() async {
    http.Response response;
    try {
      response = await this.client.get(
        userVideosEndpoint,
        headers: {'authorization': authToken},
      ).timeout(
        Duration(seconds: 20),
        onTimeout: () {
          print('timeouttttttttttt');
        },
      );
    } catch (e) {}

    if (response == null) {
      throw 'Timeout or connection error';
    }
    if (!response.headers['content-type'].contains('application/json')) {
      print(response.headers['content-type']);
      throw 'Type response not was a JSON';
    }
    CITAResponse resp = new CITAResponse.fromJson(convert.json.decode(response.body));
    print(resp.code);
    print(resp.error);
    print(resp.userMessage);
    if (resp.code == 200) {
      List<dynamic> videos = resp.data;
      List<CITAVideo> finalVideos = List();
      videos.forEach((item) {
        finalVideos.add(new CITAVideo.fromJson(item));
      });
      return finalVideos;
    }
    return null;
  }

  Future<String> uploadVideo(String filepath) async {
    // filepath = filepath.replaceAll("file:///", "/");
    print("Filepath: $filepath");
    print("Uri: ${userUploadVideoEndpoint.toString()}");
    var uri = Uri.parse(userUploadVideoEndpoint);
    var request = new http.MultipartRequest("POST", uri);
    request.fields.addAll({
      "title": state.title,
      "latitude": state.savedCoordinates['latitude'].toString(),
      "longitude": state.savedCoordinates['longitude'].toString(),
      "location": state.finalPlace,
    });
    print(request.fields);

    request.headers["Authorization"] = authToken;
    List<int> dataBytes;
    if (filepath.contains("file://")) {
      dataBytes = File.fromUri(Uri.parse(filepath)).readAsBytesSync();
    } else {
      dataBytes = File(filepath).readAsBytesSync();
    }

    List<String> paths = filepath.split("/");

    request.files.add(
      new http.MultipartFile.fromBytes(
        "video",
        dataBytes,
        contentType: MediaType.parse("video/mp4"),
        filename: "cita_${localStorage.getFromStore("user", "dni")}_${paths[paths.length - 1]}",
      ),
    );
    http.StreamedResponse response;
    try {
      response = await request.send();
    } catch (e) {
      print("error: $e");
    }
    if (response == null) {
      return null;
    }
    // CITAResponse fResponse = CITAResponse.fromJson(
    //   convert.json.decode(await response.stream.bytesToString()),
    // );

    if (response.statusCode == 200) print("Uploaded!");
    return "uploaded";
  }

  Future<LoginResponse> login(String dni, password) async {
    if (dni.length != 8 || int.parse(dni) == null) {
      throw 'Invalid dni, please check it';
    }
    if (password.length != 4 || int.parse(password) == null) {
      throw 'Invalid password, please check it';
    }
    http.Response resp;
    bool timeout = false;
    try {
      resp = await this
          .client
          .post(
            loginEndpoint,
            headers: new Map.from({"content-type": "application/json"}),
            body: convert.json.encode({
              "username": dni,
              "password": password,
            }),
          )
          .timeout(Duration(seconds: 6), onTimeout: () {
        timeout = true;
      });
    } catch (e) {
      if (timeout) {
        return LoginResponse.Timeout;
      }
      return LoginResponse.HttpProblem;
    }

    // if (resp.statusCode != 200) throw "invalid response";
    Map body;
    try {
      body = convert.json.decode(resp.body);
    } catch (e) {
      return LoginResponse.HttpProblem;
    }
    print(body.toString());
    if (body['code'] == 401) {
      localStorage.saveToStore("user", "auth", false);
      return LoginResponse.IncorrectCredentials;
    } else if (body['code'] == 200) {
      localStorage.saveToStore("user", "auth_token", body["token"]);
      localStorage.saveToStore("user", "dni", dni);
      localStorage.saveToStore("user", "auth", true);
      return LoginResponse.Successful;
    }
    return LoginResponse.HttpProblem;
  }

  Future<String> getTemporalVideoPreview(String filename) async {
    String uri = videoUri(filename);
    http.Response r = await this.client.get(uri);
    CITAResponse response = CITAResponse.fromJson(convert.json.decode(r.body));
    if (response.code != 200) {
      throw "Problems requesting th temporal videl url";
    }
    return response.data;
  }

  Future<UserInfo> getUserInfo() async {
    http.Response response;
    try {
      response = await this.client.get(
        userEndpoint,
        headers: {'authorization': authToken},
      );
    } catch (e) {
      print("error $e");
    }

    if (response == null) {
      return null;
    }

    Map map = convert.json.decode(response.body);
    CITAResponse data = CITAResponse.fromJson(map);
    UserInfo userInfo = UserInfo.fromJson(data.data);
    return userInfo;
  }

  Future<bool> ping() async {
    http.Response response;
    try {
      response = await this.client.get(
        userEndpoint,
        headers: {'authorization': authToken},
      ).timeout(Duration(seconds: 5));
    } catch (e) {}
    if (response == null) {
      return false;
    }
    return true;
  }

  Future<SignUpResponse> signUp(Map payload) async {
    http.Response response;

    try {
      response = await this
          .client
          .post(
            signUpEndpoint,
            headers: new Map.from({"content-type": "application/json"}),
            body: convert.json.encode(payload),
          )
          .timeout(Duration(seconds: 10));
      Map resp = convert.json.decode(response.body);
      if (response.statusCode == 200) {
        print(resp);
        String dni = resp["data"]["dni"];

        return new SignUpResponse(
            ok: true, message: "Usted ($dni) se ha registrado con éxito", dni: dni);
      }
      print("bad response from signup: $resp");
      return new SignUpResponse(ok: false, message: resp["user_message"]);
    } catch (e) {
      print("error at signup: $e");
      return new SignUpResponse(
          ok: false, message: "Hubieron problemas con la conexion a internet");
    }
  }

  Future<GeoCodingResponse> getLocationWithName(String name) async {
    http.Response response;

    try {
      response = await this.client.get(mapBoxGeoCodingForward(name));
      print(response.statusCode);
      if (response.statusCode == 200) {
        Map mapBoxReponse = convert.json.decode(response.body);

        if (mapBoxReponse["type"].toString().contains("FeatureCollection")) {
          List<dynamic> features = mapBoxReponse["features"];

          if (features[0]["place_name"] != "") {
            print(features[0]["center"]);
            return GeoCodingResponse(
              place: features[0]["place_name"],
              latitude: double.parse(features[0]["center"][1].toString()),
              longitude: double.parse(features[0]["center"][0].toString()),
            );
          }
          return new GeoCodingResponse();
        }
      }
    } catch (e) {
      print("Error: ${e.toString()}");
      throw e;
    }
    return new GeoCodingResponse();
  }

  Future<String> launchRecoveryPassword(String dni) async {
    try {
      http.Response response = await client.post(recoveryPassword(dni));
      if (response.statusCode == 200) {
        Map<String, dynamic> body = convert.json.decode(response.body);
        return body["user_message"];
      }
    } catch (e) {
      print(e);
      return "invalid dni";
    }
    return "invalid dni";
  }
}

final client = new CITAClient();
