class State {
  int timeSelected = 0;
  Map savedCoordinates = {
    'latitude': 0,
    'longitude': 0,
    'altitude': 0,
  };
  String finalPlace = '';
  String title = '';

  Map lastVideoRecorded = {
    'exist': false,
    'recordedTime': null,
    'path': '',
    'isUploaded': false,
  };
  bool storeInit = false;

  bool justRegistered = false;
  String dniOfNewRegistered = "";

  bool firstIn = true;
}

final state = new State();
