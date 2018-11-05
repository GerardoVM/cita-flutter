import 'package:flutter/material.dart';

import '../logic/classes.dart';
import '../molecules/VideoItem.dart';

// class VideosList extends StatefulWidget {
//   List<CITAVideo> videos;

//   VideosList({this.videos});

//   @override
//   _VideosListState createState() => new _VideosListState(videos: this.videos);
// }

// class _VideosListState extends State<VideosList> {
//   List<CITAVideo> videos;

//   _VideosListState({this.videos});

//   Widget itemBuilder(BuildContext c, int i) {
//     return new Container(child: new VideoItem(video: this.videos[i]));
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (this.videos == null) {
//       return Container(
//         child: new Center(child: new Text("Cargando videos")),
//       );
//     }
//     return new ListView.builder(
//       padding: new EdgeInsets.symmetric(horizontal: 8.0),
//       itemBuilder: itemBuilder,
//       itemCount: this.videos.length,
//     );
//   }
// }

class VideosList extends StatelessWidget {
  final List<CITAVideo> videos;

  VideosList({this.videos});

  Widget itemBuilder(BuildContext c, int i) {
    return new Container(
      margin: new EdgeInsets.only(bottom: 8.0),
      child: new VideoItem(video: this.videos[i]),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (this.videos == null) {
      return Container(
        child: new Center(child: new Text("Cargando videos")),
      );
    }
    if (this.videos.length == 0) {
      return new Center(
        child: new Text("No tienes videos grabados"),
      );
    }
    return new ListView.builder(
      padding: new EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
      itemBuilder: itemBuilder,
      itemCount: this.videos.length,
    );
  }
}
