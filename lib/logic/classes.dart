import 'dart:convert' as convert;

class CITAResponse {
  int code;
  dynamic data;
  dynamic error;
  String userMessage;

  CITAResponse.fromJson(Map<String, dynamic> json) {
    this.code = json["code"];
    this.data = json["data"];
    this.error = json["error"];
    this.userMessage = json["user_message"];
  }
}

class CITAVideo {
  String id;
  String title;
  DateTime date;

  String location;
  List<int> remoteThumb;
  String url;

  CITAVideo({this.id, this.title, this.date, this.location, this.remoteThumb});

  CITAVideo.fromJson(Map<String, dynamic> data) {
    this.id = data['_id'];
    this.title = data['title'];

    this.date = DateTime.parse(data['_created']);
    this.location = data['location'];
    this.remoteThumb = convert.base64.decode(data['thumbnail']);
    this.url = data['url'];
  }
}

class UserInfo {
  String id;
  String type;
  String name;
  String email;
  String phone;
  String dni;

  UserInfo.fromJson(Map<String, dynamic> data) {
    this.id = data['_id'];
    this.type = data['type'];
    this.name = data['name'];
    this.email = data['email'];
    this.phone = data['phone'];
    this.dni = data['dni'];
  }
}

// enum QueuedVideoStatus { uploaded, inQueue, uploading }

// class QueuedVideo {
//   String path;
//   String title;
//   String location;

//   QueuedVideoStatus status;

//   double latitude;
//   double longitude;

// }
