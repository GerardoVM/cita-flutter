import 'package:flutter/material.dart';

import '../logic/state.dart';

enum RecTimeSelected { t15, t30, t45, t60 }

const times = {
  0: '60 segundos de grabación',
  1: '45 segundos de grabación',
  2: '30 segundos de grabación',
};

Widget getTimeSelectSheet(BuildContext context, {RecTimeSelected selected, Function onSelected}) {
  if (selected == null) {
    selected = RecTimeSelected.t15;
  }

  List<Widget> timeList = new List();
  timeList.addAll(new Iterable.generate(3, (i) {
    return new ListTile(
      onTap: () {
        if (onSelected != null) {
          onSelected(RecTimeSelected.values[i]);
        } else {
          print("onSelected undefined");
        }
        state.timeSelected = i;
        Navigator.of(context).pop();
      },
      leading: new Icon(Icons.timelapse),
      title: new Text(
        times[i],
        style: new TextStyle(
          fontFamily: 'Muli',
        ),
      ),
      selected: i == state.timeSelected ? true : false,
    );
  }));

  return new Container(
    // borderRadius: new BorderRadius.only(
    //   topLeft: new Radius.circular(20.0),
    //   topRight: new Radius.circular(20.0),
    // ),
    child: new Container(
      color: Colors.white,
      height: 200.0,
      child: new Padding(
        padding: const EdgeInsets.all(0.0),
        child: new ListView(
          children: timeList,
        ),
      ),
    ),
  );
}
