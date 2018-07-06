import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './utils/common.dart';
import './demo/randomwords.dart';
import './demo/netimage.dart';
import './demo/listview_h.dart';
import './demo/listview_tree.dart';
import './demo/gridview_v.dart';
import './demo/AnimatedList.dart';
import './demo/ExpansionTile.dart';
import './demo/TabbedAppBar.dart';
import './demo/FadeAppTest.dart';
import './demo/SignaturePainter.dart';
import './demo/AsyncLoadListView.dart';
import './demo/OnlineNovelRead.dart';
//import './demo/AMapDemoSample.dart';
import './demo/AnimatingWidgetAcrossDemo.dart';
import './demo/ButtonSample.dart';
import './demo/WebViewSample.dart';
import './demo/HtmlViewSample.dart';
import './demo/MenuUiChallengeSample.dart';
import './demo/ShopGridSample.dart';
import './demo/AnimateScrollSample.dart';
import './demo/AnimateParallaxSwitchSample.dart';

import 'package:flutter_localizations/flutter_localizations.dart';

void main() => runApp(new MyApp());

final demoNames = <String>[
  '无限滚动列表',
  '显示网上的图片',
  '水平(ListView)',
  '不同类型的子项',
  '格子列表(GridList)',
  '卡片列表(AnimatedList)',
  '多级列表(ExpansionTile)',
  '选项卡式AppBar',
  '动画示例',
  '绘制画布Canvas',
  '异步加载列表',
  '-',
  '在线小说阅读',
  '-', //'''高德地图Demo',
  '-',
  '动画放大图像',
  '按钮',
  '-',
  '浏览器 WebView',
  'html标签富文本',
  'Menu - Timeline',
  '商品展示',
  '动画控制示例',
  '视差轮播动效',
];

class MyApp extends StatelessWidget {
  Widget getWidget(BuildContext context, int i, String item) {
    switch (i) {
      case 1:
        return new NetImageDemo(title: item);
      case 2:
        return new ListViewHDemo(title: item);
      case 3:
        return new ListViewTreeDemo(title: item);
      case 4:
        return new GridViewDemo(title: item);
      case 5:
        return new AnimatedListSample(title: item);
      case 6:
        return new ExpansionTileSample(title: item);
      case 7:
        return new TabbedAppBarSample(title: item);
      case 8:
        return new FadeAppTestSample(title: item);
      case 9:
        return new SignaturePainterSample(title: item);
      case 10:
        return new AsyncLoadListSample(title: item);

      case 12:
        return new OnlineNovelReadDemoSample(title: item);
//      case 13:
//        return new AMapDemoSample(title: item);
//
      case 15:
        return new AnimatingWidgetAcrossDemo(title: item);
      case 16:
        return new ButtonSample(title: item);

      case 18:
        return new WebViewSample(title: item);
      case 19:
        return new HtmlViewSample(title: item);
      case 20:
        return new MenuUiChallengeSample();
      case 21:
        return new ShopGridSample();
      case 22:
        return new AnimateScrollSample();
      case 23:
        return new AnimateParallaxSwitchSample(title: item);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, WidgetBuilder> routes = new Map();
    for (int i = 0; i < demoNames.length; i++) {
      String item = demoNames[i];
      if (item == '-' || Tools.strIsEmpty(item)) continue;
      routes["/$i"] = (BuildContext context) => getWidget(context, i, item);
    }

    return new MaterialApp(
      title: 'App Title',
      theme: new ThemeData(
        primaryColor: const Color(0xFFfffff8), // 标题工具栏主题颜色
        //primaryColorLight: Colors.yellow,
        //splashColor: Colors.grey,  // 水波颜色
        //dividerColor: Colors.black,
        //scaffoldBackgroundColor: Colors.white,
        //primaryColorDark: Colors.red,
        //primarySwatch: Colors.blue,
        //cardColor: Colors.yellow,
      ),
      routes: routes,
//      routes: <String, WidgetBuilder>{
//        '/1': (BuildContext context) => new NetImageDemo(title: demoNames[1]),
//      },
      home: new MyHomePage(),

      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        // 多语言本地化
        const Locale('zh', 'CH'),
        const Locale('en', 'US'),
      ],
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _select(Choice choice) {
    setState(() {
      // Causes the app to rebuild with the new _selectedChoice.
      Tools.toast(choice.title);
    });
  }

  @override
  Widget build(BuildContext context) {
    //SystemChrome.setSystemUIOverlayStyle(Styles.uiStyle);
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Flutter Demo'),
        automaticallyImplyLeading: false,
        elevation: 0.5, // 纸墨设计中控件的 z 坐标顺序，默认值为 4，对于可滚动的 SliverAppBar，
        // 当 SliverAppBar 和内容同级的时候，该值为 0， 当内容滚动 SliverAppBar 变
        // 为 Toolbar 的时候，修改 elevation 的值
        actions: <Widget>[
          new PopupMenuButton<Choice>(
            // overflow menu
            onSelected: _select,
            itemBuilder: (BuildContext context) {
              return choices.skip(2).map((Choice choice) {
                return new PopupMenuItem<Choice>(
                  value: choice,
                  child: new Text(choice.title),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: new ListView.builder(
          itemCount: demoNames.length,
          itemBuilder: (context, index) {
            if (index < demoNames.length) {
              final item = demoNames[index];
              if (item == '-') {
                return new Divider();
              }
              return new ListTile(
                leading: new Icon(Icons.list),
                title: new Text(
                  item,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: new TextStyle(
                    decorationColor: Colors.red[400],
                    decorationStyle: TextDecorationStyle.solid,
                    letterSpacing: 0.0,
                    //fontWeight: FontWeight.lerp(FontWeight.w100, FontWeight.w900, 0.1),
                  ),
                ),
                onTap: () {
                  if (index == 0)
                    _showRandowWords(context, demoNames[0]);
                  else
                    Navigator.pushNamed(context, '/$index'); // 使用命名导航
                },
              );
            }
          }),
    );
  }

  // 接收页面返回值 demo
  void _showRandowWords(BuildContext context, String _title) async {
    try {
      final result = await Navigator.push(context, new MaterialPageRoute(builder: (context) => new RandomWords(title: _title))); // 开始新的Page，保留当前page
      //Scaffold.of(context).showSnackBar(new SnackBar(content: new Text("选择了 $result 项。")));
      if (result != null) {
        Tools.toast("选择了 $result 项。");
      }
    } finally {}
  }
}

class Choice {
  const Choice({this.title, this.icon});
  final String title;
  final IconData icon;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: 'Car', icon: Icons.directions_car),
  const Choice(title: 'Bicycle', icon: Icons.directions_bike),
  const Choice(title: 'Boat', icon: Icons.directions_boat),
  const Choice(title: 'Bus', icon: Icons.directions_bus),
  const Choice(title: 'Train', icon: Icons.directions_railway),
  const Choice(title: 'Walk', icon: Icons.directions_walk),
];
