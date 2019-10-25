import 'package:flutter/material.dart';
import 'package:flutter_demo/utils/common.dart';

import 'EffectBottomNavigationBar.dart';

/// 底部导航栏特效
class EffectBootomNavigatorPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _EffectBootomNavigatorPageState();
  }
}

class _EffectBootomNavigatorPageState extends State<EffectBootomNavigatorPage> {

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
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
      floatingActionButton: FloatingActionButton(child: Icon(Icons.add), onPressed: (){
        // Tools.toast("add");
      }),
      floatingActionTopOffset: 8.0,
      floatingActionButtonWidth: 45.0,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.scanner)),
        BottomNavigationBarItem(icon: Icon(Icons.search), title: Text("Search")),
        BottomNavigationBarItem(icon: Icon(Icons.gesture), title: Text("Gesture")),
        BottomNavigationBarItem(icon: Icon(Icons.sentiment_satisfied), title: Text("Me")),
      ],
      backgroundColor: Colors.tealAccent,
      deep: 1.12,
      showTitles: true,
      body: Container(
        child: Center(
          child: Text("Hello Flutter", style: TextStyle(fontSize: 24.0)),
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