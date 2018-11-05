import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pigment/pigment.dart';
import 'package:video_player/video_player.dart';

import '../logic/state.dart' as s;

class PreviewVideo extends StatefulWidget {
  @override
  _PreviewVideoState createState() => _PreviewVideoState();
}

class _PreviewVideoState extends State<PreviewVideo> {
  String videoPath;
  bool error = false;
  bool isFromFile = false;
  VideoPlayerController videoController;
  bool videoIsPlaying = false;

  @override
  void initState() {
    super.initState();
    if (s.state.lastVideoRecorded["exist"]) {
      this.videoPath = s.state.lastVideoRecorded["path"];
    } else {
      this.error = true;
      throw "last video recorded not found";
    }
    videoPath = videoPath.replaceAll("file://", "");
    print("-- VIDEO PATH --> $videoPath");
    // /data/user/0/com.utec.cita/app_flutter/Videos/CITA/1535726451200.mp4
    // file:///storage/emulated/0/WhatsApp/Media/WhatsApp%20Video/VID-20180831-WA0030.mp4
    File videoFile = new File(this.videoPath);
    videoController = new VideoPlayerController.file(videoFile);
    videoController.addListener(() {
      final bool isPlaying = videoController.value.isPlaying;
      if (isPlaying != videoIsPlaying) {
        setState(() {
          videoIsPlaying = isPlaying;
        });
      }
    });

    videoController.initialize().then((_) {
      videoController.setLooping(true);
      setState(() {});
    });
  }

  playVideo() async {
    await videoController.play();
    setState(() {
      this.videoIsPlaying = true;
    });
  }

  pauseVideo() async {
    await videoController.pause();
    setState(() {
      this.videoIsPlaying = false;
    });
  }

  toggleVideoState() {
    if (videoIsPlaying) {
      pauseVideo();
    } else {
      playVideo();
    }
  }

  @override
  void dispose() {
    super.dispose();
    this.videoController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    double scale = 1.0;
    if (videoController.value.initialized) {
      scale = h / w / videoController.value.aspectRatio;
    }

    return Scaffold(
      body: new Stack(
        children: <Widget>[
          new Transform.scale(
            child: new Center(
              child: videoController.value.initialized
                  ? new AspectRatio(
                      child: VideoPlayer(this.videoController),
                      aspectRatio: 1 / this.videoController.value.aspectRatio,
                    )
                  : new Container(),
            ),
            scale: scale,
          ),
        ],
      ),
      floatingActionButton: new Builder(
        builder: (context) {
          return new FloatingActionButton(
            onPressed: toggleVideoState,
            tooltip: 'play/pause',
            backgroundColor: Pigment.fromString('#1867C0'),
            child: new Icon(this.videoIsPlaying ? Icons.pause : Icons.play_arrow),
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
                    onPressed: () => Navigator.of(context).pop(),
                    icon: new Icon(Icons.arrow_back),
                    color: Pigment.fromString("#FF3472")),
                new Text(
                  "Descartar",
                  style: new TextStyle(
                    fontFamily: 'Muli',
                  ),
                ),
              ],
            ),
            new Row(
              children: <Widget>[
                new Text(
                  "Continuar",
                  style: new TextStyle(
                    fontFamily: 'Muli',
                  ),
                ),
                new IconButton(
                  onPressed: () => Navigator.of(context).popAndPushNamed("savevideo"),
                  icon: new Icon(Icons.check),
                  color: Pigment.fromString("#50E8D7"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
