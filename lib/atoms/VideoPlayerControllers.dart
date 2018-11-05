import 'package:flutter/material.dart';

class PreVideoPlayerController extends StatefulWidget {
  final VoidCallback onPlay;
  final VoidCallback onPause;
  final bool playing;

  PreVideoPlayerController({
    @required this.playing,
    @required this.onPlay,
    @required this.onPause,
  });

  @override
  _PreVideoPlayerControllerState createState() => new _PreVideoPlayerControllerState(
      onPause: this.onPause, onPlay: this.onPlay, playing: this.playing);
}

class _PreVideoPlayerControllerState extends State<PreVideoPlayerController> {
  VoidCallback onPlay;
  VoidCallback onPause;
  bool playing;

  _PreVideoPlayerControllerState({
    @required this.playing,
    @required this.onPlay,
    @required this.onPause,
  });

  onPlayButtonPressed() {
    if (this.playing) {
      this.playing = false;
      this.onPause();
      return;
    } else {
      this.playing = true;
      this.onPlay();
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: new Center(
        child: new IconButton(
          color: Colors.white,
          iconSize: 48.0,
          icon: new Icon(this.playing ? Icons.pause_circle_filled : Icons.play_circle_filled),
          onPressed: onPlayButtonPressed,
        ),
      ),
    );
  }
}
