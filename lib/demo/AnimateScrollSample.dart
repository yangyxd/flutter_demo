import 'package:flutter/material.dart';
import 'dart:math';
import '../utils/view/CommonView.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// 动画滚动示例
class AnimateScrollSample extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new AnimateScrollSampleState();
}

class AnimateScrollSampleState extends State<AnimateScrollSample>
    with SingleTickerProviderStateMixin {
  final ScrollController controller = new ScrollController();
  TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = new TabController(
      vsync: this,
      length: pageItems.length,
    );
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new NotificationListener(
        onNotification: onNotification,
        child: new CustomScrollView(
          controller: controller,
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 270.0,
              backgroundColor: Colors.blue,
              iconTheme: IconThemeData(color: Colors.white),
              pinned: true,
              floating: false,
              snap: false,
              actions: <Widget>[
                IconButton(icon: Icon(Icons.share, color: Colors.white), onPressed: () {})
              ],
              flexibleSpace: _buildFlexibleSpace(),
              bottom: SizedBar(
                child: _buildTabBar(),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                        bottom: BorderSide(color: Colors.black12, width: 0.5))),
              ),
              elevation: 0.0,
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Container(
                  color: Colors.white70,
                  height: double.minPositive,
                  child: _buildTabView(),
                  constraints: BoxConstraints(minHeight: 600.0),
                )
              ]),
            )
          ],
        ),
      ),
    );
  }

  bool onNotification(Notification notification) {
    // 滚动监听
    if (notification is ScrollUpdateNotification) {
      ScrollUpdateNotification n = notification;
      if (n.depth == 0) {
        setState(() {
          _t = min(n.metrics.pixels, n.metrics.maxScrollExtent * 0.6) /
              (n.metrics.maxScrollExtent * 0.6);
        });
      }
    }
    return true;
  }

  double _t = 0.0;

  _buildFlexibleSpace() {
    return FlexibleSpaceBar(
//      title: Container(
//        child:
//            Text("风云", style: TextStyle(color: Colors.white.withOpacity(_t))),
//        margin: EdgeInsets.only(bottom: 46.0), // 46是默认的TabBar高度
//      ),
      title: Transform(
        transform: new Matrix4.translationValues(0.0, -46.0, 0.0),
        child: Text("风云", style: TextStyle(color: Colors.white.withOpacity(_t))), // 46是默认的TabBar高度
      ),
      background: Container(
          color: Colors.white,
          height: 300.0,
          child: Stack(
            children: <Widget>[
              CachedNetworkImage(
                  imageUrl: "http://www.fpwap.com/UploadFiles02/news/sub/2017/10/25/1508906814806210.jpg",
                  height: 158.0,
                  width: double.infinity,
                  fit: BoxFit.fitWidth,
                  //colorBlendMode: BlendMode.srcOver,
                  //color: Colors.black54
              ),
              Container(
                margin: EdgeInsets.only(left: 8.0, top: 100.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        width: 50.0,
                        height: 50.0,
                        child: CircleAvatar(
                          child: Icon(Icons.verified_user,
                              size: 36.0, color: Colors.white),
                        )),
                    SizedBox(height: 6.0),
                    Row(
                      textBaseline: TextBaseline.alphabetic,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      children: <Widget>[
                        Text("风云", style: TextStyle(fontSize: 24.0)),
                        SizedBox(width: 8.0),
                        ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Container(
                              color: Colors.blue,
                              padding: EdgeInsets.only(left: 8.0, right: 8.0),
                              child: Text("LV 999",
                                  style: TextStyle(
                                      fontSize: 14.0, color: Colors.white)),
                            )),
                      ],
                    ),
                    SizedBox(height: 6.0),
                    DefaultTextStyle(
                      style: TextStyle(fontSize: 12.0, color: Colors.black54),
                      child: Row(
                        textBaseline: TextBaseline.ideographic,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        children: <Widget>[
                          Text("积分："),
                          Text("100",
                              style: TextStyle(
                                  color: Colors.black, fontSize: 12.0)),
                          SizedBox(width: 12.0),
                          Text("关注："),
                          Text("0",
                              style: TextStyle(
                                  color: Colors.black, fontSize: 12.0)),
                          SizedBox(width: 12.0),
                          Text("粉丝："),
                          Text("0",
                              style: TextStyle(
                                  color: Colors.black, fontSize: 12.0)),
                        ],
                      ),
                    ),
                    SizedBox(height: 6.0),
                    Text("世界那么大，我想去走走！",
                        style:
                            TextStyle(color: Colors.black54, fontSize: 12.0)),
                  ],
                ),
              )
            ],
          )),
    );
  }

  _buildTabBar() {
    return TabBar(
      controller: tabController,
      //isScrollable: true,
      labelColor: Colors.black87,
      indicatorWeight: 2.0,
      indicatorColor: Colors.blueAccent,
      indicatorPadding:
          const EdgeInsets.only(bottom: 4.0, left: 8.0, right: 8.0),
      tabs: pageItems.map((ShopPage page) {
        return new Tab(text: page.title);
      }).toList(),
    );
  }

  _buildTabView() {
    return TabBarView(
      //children: <Widget>[],
      controller: tabController,
      children: pageItems.map((ShopPage item) {
        return new Container(
          padding: null,
          child: new Center(),
        );
      }).toList(),
    );
  }
}

class ShopPage {
  final String title;
  const ShopPage({this.title});
}

const List<ShopPage> pageItems = const <ShopPage>[
  const ShopPage(title: '精选'),
  const ShopPage(title: '女装'),
  const ShopPage(title: '男装'),
];
