import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';  // 在 pubspec.yaml 中加入： transparent_image: ^0.1.0
import 'package:cached_network_image/cached_network_image.dart'; // 在 pubspec.yaml 中加入： cached_network_image: "^0.4.0"

class NetImageDemo extends StatefulWidget {
  final String title;
  NetImageDemo({this.title});

  @override
  createState() => new NetImageDemoState(this.title);
}

class NetImageDemoState extends State<NetImageDemo> {
  final String title;
  NetImageDemoState(this.title);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(title),
      ),
      body: new ListView(
        padding: new EdgeInsets.all(6.0),
        children: <Widget>[
          new Text('大白 - 用占位符淡入图片'),
          new FadeInImage.memoryNetwork(
            placeholder: kTransparentImage,
            image: 'http://img.zcool.cn/community/0171a35530c25e000000c50031b524.jpg@2o.jpg',
          ),
          new Text('FMXUI'),
          new Image.network('https://avatars2.githubusercontent.com/u/14143779?s=460&v=4',),
          new Text('GIF动画'),
          new Image.network('http://img.zcool.cn/community/01b1b3590877caa8012145507aec92.gif',),
          new Text('使用缓存图片'),
          new CachedNetworkImage(
            placeholder: new CircularProgressIndicator(),
            imageUrl: 'https://github.com/flutter/website/blob/master/_includes/code/layout/lakes/images/lake.jpg?raw=true',
          ),
        ],
      ),
    );
  }
}