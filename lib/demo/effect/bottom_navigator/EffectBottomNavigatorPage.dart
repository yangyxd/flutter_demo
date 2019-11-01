import 'package:flutter/material.dart';
import 'package:flutter_demo/utils/common.dart';

import 'EffectBottomNavigationBar.dart';

/// 底部导航栏特效
/// 可直接指定浮动按钮, 实现嵌入效果
class EffectBottomNavigatorPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _EffectBottomNavigatorPageState();
  }
}

class _EffectBottomNavigatorPageState extends State<EffectBottomNavigatorPage> {

  int currentIndex = 0;
  bool showActionButton = true;

  @override
  Widget build(BuildContext context) {
    // BottomNavigationBar();
    return Scaffold(
      appBar: AppBar(
        title: Text("底部导航栏特效"),
        elevation: 0.0,
      ),
      body: buildBottomNavigatorBar(),
    );
  }

  Widget buildBottomNavigatorBar() {
    return EffectBottomNavigationBar(
      fixedColor: Colors.blue,
      // type: BottomNavigationBarType.fixed,
      // backgroundColor: Colors.yellow,
      currentIndex: currentIndex,
      floatingActionButton: showActionButton ? FloatingActionButton(child: Icon(Icons.sentiment_satisfied), onPressed: (){
        // Tools.toast("add");
      }): null,
      floatingActionTopOffset: 2.0,
      floatingActionButtonWidth: 55.0,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.scanner), title: Text("Scan")),
        BottomNavigationBarItem(icon: Icon(Icons.search), title: Text("Search")),
        BottomNavigationBarItem(icon: Icon(Icons.gesture), title: Text("Gesture")),
        BottomNavigationBarItem(icon: Icon(Icons.sentiment_satisfied), title: Text("Me")),
      ],
      popupButton: BottomNavigationBarPopupActionList(
        children: [
          BottomNavigationBarPopupActionItem(icon: Icon(Icons.photo_camera), title: "拍照", onTap: (){}),
          BottomNavigationBarPopupActionItem(icon: Icon(Icons.share), title: "分享", onTap: (){}),
          BottomNavigationBarPopupActionItem(icon: Icon(Icons.content_copy), title: "复制", onTap: (){}),
        ]
      ),
      backgroundColor: Colors.tealAccent,
      deep: 1.12,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      body: Container(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text("Hello Flutter", style: TextStyle(fontSize: 24.0)),
              SizedBox(height: 8.0),
              RaisedButton(child: Text(showActionButton ? "隐藏浮动按钮" : "显示浮动按钮"), onPressed: () {
                setState(() {
                  showActionButton = !showActionButton;
                });
              })
            ],
          ),
        ),
      ),
      onTap: (index) {
        if (currentIndex != index) {
          setState(() {
            currentIndex = index;
          });
        }
      },
      elevation: 10.0,
    );
  }
}