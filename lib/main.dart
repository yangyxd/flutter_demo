import 'package:flutter/material.dart';
import 'randomwords.dart';
import 'netimage.dart';
import 'listview_h.dart';
import 'listview_tree.dart';
import 'gridview_v.dart';
import 'package:ui_flutter_plugin/ui_toast.dart';

void main() => runApp(new MyApp());

final demoNames = <String>[
    '无限滚动列表',
    '显示网上的图片',
    '水平 ListView',
    '不同类型的子项',
    '格子列表 GridList',
] ;

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'App Title',
      theme: new ThemeData(
        primaryColor: Colors.red,
      ),
      routes: <String, WidgetBuilder>{
        '/1': (BuildContext context) => new NetImageDemo(title: demoNames[1]),
        '/2': (BuildContext context) => new ListViewHDemo(title: demoNames[2]),
        '/3': (BuildContext context) => new ListViewTreeDemo(title: demoNames[3]),
        '/4': (BuildContext context) => new GridViewDemo(title: demoNames[4]),
      },
      home: new MyHomePage(),
    );
  }


}

class MyHomePage extends StatefulWidget {
  @override
  createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) => new Scaffold(
      appBar: new AppBar(
        title: new Text('Flutter Demo'),
      ),
      body: new ListView.builder(
            itemBuilder: (context, index) {
                if (index < demoNames.length) {
                    final item = demoNames[index];
                    return new ListTile(
                        leading: new Icon(Icons.list),
                        title: new Text(item),
                        onTap: () {
                            if (index == 0)
                                _showRandowWords(context, demoNames[0]);
                            else
                                Navigator.pushNamed(context, '/$index'); // 使用命名导航
                        },
                    );
                } else
                    return null;
            }
          ),
  );

  // 接收页面返回值 demo
  _showRandowWords(BuildContext context, String _title) async {
      try {
          final result = await Navigator.push(
                  context,
                  new MaterialPageRoute(
                          builder: (context) =>
                          new RandomWords(title: _title))); // 开始新的Page，保留当前page
          //Scaffold.of(context).showSnackBar(new SnackBar(content: new Text("选择了 $result 项。")));
          if (result != null) {
              Toast.show("选择了 $result 项。");

//              showDialog<Null>(
//                  context: context,
//                  builder: (context) {
//                      return new AlertDialog(
//                              content: new Text("选择了 $result 项。"),
//                              actions: <Widget>[
//                                  // FlatButton：质感设计中的平面按钮
//                                  new FlatButton(
//                                          onPressed: () {
//                                              Navigator.pop(context);
//                                          },
//                                          child: new Text('确定')
//                                  )
//                              ]
//                      );
//                  },
//              );
          }
      } finally  {
      }
  }

}
