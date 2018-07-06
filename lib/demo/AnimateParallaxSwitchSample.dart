import 'package:flutter/material.dart';

class AnimateParallaxSwitchSample extends StatefulWidget {
  final String title;
  AnimateParallaxSwitchSample({this.title});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new AnimateParallaxSwitchSampleState();
  }
}

class AnimateParallaxSwitchSampleState extends State<AnimateParallaxSwitchSample> {
  final PageController _controller = new PageController();
  double _currentPage = 0.0;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        elevation: 0.5,
      ),
      body: NotificationListener(
        onNotification: onNotification,
        child: LayoutBuilder(
          // 通过 constraints 可以获取真实宽度
          builder: (BuildContext context, BoxConstraints constraints) {
            //return Text("width: ${constraints.maxWidth}, height: ${constraints.maxHeight}");
            return PageView.custom(
              controller: _controller,
              physics: const PageScrollPhysics(parent: const BouncingScrollPhysics()),
              childrenDelegate: new SliverChildBuilderDelegate((BuildContext context, int index) {
                return _ParallaxPage("$index",
                  // 小字 Text 在页面滑动时要比整体移动速度快一倍，所以小字的 translate X 为 \tt{pageWidth / 2 * progress}
                  parallaxOffset: constraints.maxWidth / 2.0 * (index - _currentPage),
                );
              }, childCount: 10),
            );
          },
        )
      ),
    );
  }

  bool onNotification(ScrollNotification  n) {
    setState(() {
      _currentPage = _controller.page;
    });
    return true;
  }
}

class _ParallaxPage extends StatelessWidget {
  _ParallaxPage(this.data, {
    Key, key,
    this.parallaxOffset = 0.0
  }) : super (key: key);

  final String data;
  final double parallaxOffset;

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new Center(
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Text(
              data,
              style: const TextStyle(fontSize: 60.0),
            ),
            new SizedBox(height: 40.0),
            new Transform(
              transform: new Matrix4.translationValues(parallaxOffset, 0.0, 0.0),
              child: const Text('Yet another line of text'),
            ),
          ],
        ),
      ),
    );
  }
}