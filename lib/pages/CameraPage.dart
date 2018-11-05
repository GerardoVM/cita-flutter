import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pigment/pigment.dart';

import '../atoms/NoCamera.dart';
import '../atoms/RecTimeSelector.dart';
import '../atoms/Snackbar.dart';
import '../logic/state.dart' as state;

const modes = {0: '60s', 1: '45s', 2: '30s'};

class CameraPage extends StatefulWidget {
  // List<CameraDescription> cameras;

  CameraPage(); // {@required this.cameras});

  @override
  _CameraPageState createState() => new _CameraPageState(); // cameras: this.cameras);
}

class _CameraPageState extends State<CameraPage> {
  List<CameraDescription> cameras;
  CameraController controller;

  // _CameraPageState({this.cameras});

  bool cameraInitialized = false;

  bool recording = false;
  int recordMode = state.state.timeSelected;

  int timeRecording = 0;
  Timer recordingTimer;

  String videoPath;
  bool savingVideo = false;

  // List<CameraDescription> cameras;
  // final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  String timeRecording2String(int secondsTime) {
    double minutes = 0.0;
    int s, m;
    String ss, mm;

    minutes = secondsTime / 60.0;
    m = minutes.floor();
    s = secondsTime - m * 60;

    ss = s.toString();
    mm = m.toString();

    if (s < 10) ss = "0" + ss;
    if (m < 10) mm = "0" + mm;
    return mm + ':' + ss;
  }

  String timestamp() => new DateTime.now().millisecondsSinceEpoch.toString();

  Future<String> startVideoRecording(context) async {
    if (!controller.value.isInitialized) {
      showBasicSnackBar(context, 'Error: select a camera first');
      return null;
    }

    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Videos/CITA';
    await new Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.mp4';
    if (controller.value.isRecordingVideo) {
      // A recording is already started, do nothing.
      showBasicSnackBar(context, "a recording is already started, do nothing");
      return null;
    }

    try {
      videoPath = filePath;
      await controller.startVideoRecording(filePath);
    } on CameraException catch (e) {
      showBasicSnackBar(context, "error: ${e.description}");
      return null;
    }
    return filePath;
  }

  Future<void> stopVideoRecording() async {
    if (!controller.value.isRecordingVideo) {
      return null;
    }

    try {
      await controller.stopVideoRecording();
    } on CameraException catch (e) {
      try {
        showBasicSnackBar(context, "error: ${e.description}");
      } catch (e) {
        // Here I have a big error, bregy solved it
      }
      return null;
    }
  }

  void onRecordButtonPressed(BuildContext context) {
    if (!recording) {
      state.state.lastVideoRecorded['exist'] = false;
      startVideoRecording(context).then((String filePath) {
        if (mounted)
          setState(() {
            recordingTimer = Timer.periodic(Duration(seconds: 1), (timer) {
              setState(() {
                const checker = {0: 60, 1: 45, 2: 30};
                this.timeRecording += 1;
                if (checker[state.state.timeSelected] != null) {
                  if (this.timeRecording > checker[state.state.timeSelected]) {
                    onRecordButtonPressed(context);
                  }
                }
              });
            });
            recording = !recording;
          });
        // if (filePath != null) showBasicSnackBar(context, 'Saving video to $filePath');
      });
    } else {
      if (timeRecording > 30) {
        stopVideoRecording().then((_) {
          if (mounted)
            setState(() {
              if (recordingTimer != null) {
                recordingTimer.cancel();
                this.timeRecording = 0;
              }
              recording = !recording;
            });
          // showBasicSnackBar(context, 'Video recorded to: $videoPath');

          // record Finished...

          state.state.lastVideoRecorded['exist'] = true;
          state.state.lastVideoRecorded['lastVideoRecorded'] = DateTime.now();
          state.state.lastVideoRecorded['path'] = videoPath;
          state.state.lastVideoRecorded['isUploaded'] = false;
          Navigator.pushNamed(context, "preview");
        });
      } else {
        showBasicSnackBar(context, 'Tienes que grabar al menos 30 segundos.');
      }
    }
  }

  @override
  void initState() {
    super.initState();

    availableCameras().then((cameras) {
      this.cameras = cameras;
      if (this.cameras.length > 0) {
        controller = new CameraController(this.cameras[0], ResolutionPreset.high);
        controller.initialize().then((_) {
          if (!mounted) {
            return;
          }
          setState(() {
            cameraInitialized = true;
          });
        });
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        iconTheme: new IconThemeData(
          color: !cameraInitialized ? Pigment.fromString("#162A40") : Pigment.fromString("white"),
        ),
        centerTitle: true,
        backgroundColor: !cameraInitialized ? Pigment.fromString("white") : Colors.transparent,
        // Colors.white,
        elevation: 0.0,
        title: !cameraInitialized
            ? new Text(
                "Huaycos y crecidas",
                style: new TextStyle(
                  color: Pigment.fromString("#162A40"),
                  fontFamily: "StagSans",
                  fontSize: 20.0,
                  letterSpacing: 0.3,
                ),
              )
            : null,
      ),
      body: !cameraInitialized
          ? new NoCamera()
          : new Stack(
              children: <Widget>[
                new Transform.scale(
                  scale: 1.1 / controller.value.aspectRatio,
                  child: new Center(
                    child: new AspectRatio(
                      aspectRatio: controller.value.aspectRatio,
                      child: CameraPreview(controller),
                    ),
                  ),
                ),
              ],
            ),
      floatingActionButton: new Builder(
        builder: (context) {
          return new FloatingActionButton(
            onPressed: () => onRecordButtonPressed(context),
            tooltip: 'Rec a new video',
            backgroundColor: Pigment.fromString('#5ACDBC'),
            child: new Icon(savingVideo ? Icons.save : recording ? Icons.stop : Icons.videocam),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: new BottomAppBar(
        color: Pigment.fromString('#FFFFFF'),
        shape: new CircularNotchedRectangle(),
        notchMargin: 6.0,
        // hasNotch: true,
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new Row(
              children: <Widget>[
                new IconButton(
                  onPressed: () => print("Rek, ejé"),
                  icon: new Icon(Icons.fiber_manual_record),
                  color: !this.recording
                      ? Pigment.fromString('#9D9D9D')
                      : Pigment.fromString('#FF6C6C'),
                ),
                new Text(
                  timeRecording2String(this.timeRecording),
                  style: new TextStyle(
                    fontFamily: 'Muli',
                  ),
                ),
              ],
            ),
            new Row(
              children: <Widget>[
                new Text(
                  modes[state.state.timeSelected],
                  style: new TextStyle(
                    fontFamily: 'Muli',
                  ),
                ),
                new IconButton(
                  onPressed: () {
                    if (!this.recording) {
                      showModalBottomSheet(context: context, builder: getTimeSelectSheet).then((v) {
                        setState(() {});
                      });
                    }
                  },
                  icon: new Icon(Icons.timer),
                  color: !this.recording
                      ? Pigment.fromString('#26283F')
                      : Pigment.fromString('#9D9D9D'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
