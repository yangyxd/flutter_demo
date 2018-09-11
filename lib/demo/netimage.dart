import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';  // 在 pubspec.yaml 中加入： transparent_image: ^0.1.0
import 'package:cached_network_image/cached_network_image.dart'; // 在 pubspec.yaml 中加入： cached_network_image: "^0.4.0"
import 'package:carousel_slider/carousel_slider.dart';

import '../utils/common.dart';

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
    final List<ImageProvider> imgs = [
      new CachedNetworkImageProvider('https://s.pc.qq.com/guanjia//news/uploads/allimg/160302/15-16030214422KK.png'),
      new CachedNetworkImageProvider('https://photo.16pic.com/00/21/38/16pic_2138544_b.jpg'),
      new CachedNetworkImageProvider('http://img.zcool.cn/community/01b1b3590877caa8012145507aec92.gif'),
    ];

    return new Scaffold(
      body: new CustomScrollView(
          slivers: [
            new SliverAppBar(
              pinned: false,
              elevation: Styles.Elevation,
              expandedHeight: 200.0,
              floating: true,
              snap: true,
              title: new Text(widget.title),
              primary: true,
              flexibleSpace: new FlexibleSpaceBar(
                //title: new Text(widget.title, style: new TextStyle(color: Colors.white),),
//                background: new ImageCarousel(
//                  <ImageProvider>[
//                    new CachedNetworkImageProvider('https://s.pc.qq.com/guanjia//news/uploads/allimg/160302/15-16030214422KK.png'),
//                    new CachedNetworkImageProvider('https://photo.16pic.com/00/21/38/16pic_2138544_b.jpg'),
//                    new CachedNetworkImageProvider('http://img.zcool.cn/community/01b1b3590877caa8012145507aec92.gif'),
//                  ],
//                  interval: new Duration(seconds: 1),
//                  height: 200.0,
//                  allowZoom: false,
//                  platform: TargetPlatform.iOS,
//                ),
                background: new CarouselSlider(
                  items: <Widget>[
                    Image(image: imgs[0]),
                    Image(image: imgs[1]),
                    Image(image: imgs[2]),
                  ],
                ),
              ),
              backgroundColor: Colors.blue,
            ),
            new SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: new Column(
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
                      placeholder: new LinearProgressIndicator(),
                      //placeholder: new RefreshProgressIndicator(),
                      imageUrl: 'https://github.com/flutter/website/blob/master/_includes/code/layout/lakes/images/lake.jpg?raw=true',
                    ),
                  ],
                ),
              ),
            )
          ]
      ),
    );
  }
}