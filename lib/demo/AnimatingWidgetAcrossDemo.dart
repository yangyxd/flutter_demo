import 'dart:io';
import 'package:flutter_amap/flutter_amap.dart';
import 'package:flutter/material.dart';
import '../utils/common.dart';

class AnimatingWidgetAcrossDemo extends StatefulWidget {
  final String title;
  AnimatingWidgetAcrossDemo({this.title});

  final FlutterAmap amap = new FlutterAmap();

  @override
  createState() => new _SampleState();
}

class _SampleState extends State<AnimatingWidgetAcrossDemo> {

  @override
  Widget build(BuildContext context) {
    final List<String> urls = [
      'http://pic.5tu.cn/uploads/allimg/1203/021450373090.jpg',
      'http://pic1.win4000.com/pic/d/5b/9fdbefa40c.jpg',
    ];
    final List<String> tags = [
      'imgHero0',
      'imgHero1',
    ];
    return new Scaffold(
        appBar: new AppBar(
          elevation: Styles.Elevation,
          title: new Text(widget.title),
        ),
        body: new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new GestureDetector(
              onTap: () {
                Navigator.push(context, new MaterialPageRoute(builder: (_) {
                  return new DetailScreen(urls[0], tags[0]);
                }));
              },
              child: new Hero(
                tag: tags[0],
                child: new Image.network(urls[0], width: 90.0),
              ),
            ),
            new SizedBox(height: 20.0,),
            new GestureDetector(
              onTap: () {
                Navigator.push(context, new MaterialPageRoute(builder: (_) {
                  return new DetailScreen(urls[1], tags[1]);
                }));
              },
              child: new Hero(
                tag: tags[1],
                child: new Image.network(urls[1], width: 90.0),
              ),
            ),
          ],
        )
    );
  }
}

class DetailScreen extends StatelessWidget {
  DetailScreen(this.url, this.tag);
  final String url, tag;
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: new Center(
          child: new Hero(
            tag: tag,
            child: new Image.network(url),
          ),
        ),
      ),
    );
  }
}