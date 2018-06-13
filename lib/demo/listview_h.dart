import 'package:flutter/material.dart';
import '../utils/common.dart';

class ListViewHDemo extends StatefulWidget {
  final String title;
  ListViewHDemo({this.title});

  @override
  createState() => new ListViewHDemoState(title);
}

class ListViewHDemoState extends State<ListViewHDemo> {
  final String title;
  ListViewHDemoState(this.title);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(title), elevation: Common.Elevation,
        ),
        body: new Container(
            margin: new EdgeInsets.symmetric(vertical: 20.0),
            height: 200.0,
            child: new ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                new Container(
                  width: 160.0,
                  color: Colors.red,
                ),
                new Container(
                  width: 160.0,
                  color: Colors.blue,
                ),
                new Container(
                  width: 160.0,
                  color: Colors.green,
                ),
                new Container(
                  width: 160.0,
                  color: Colors.yellow,
                ),
                new Container(
                  width: 160.0,
                  color: Colors.orange,
                ),
              ],
            )));
  }
}
