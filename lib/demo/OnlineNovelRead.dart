import 'package:flutter/material.dart';
import '../utils/common.dart';
import 'online_novel_read_pages/HomePage.dart';
import 'online_novel_read_pages/SavePage.dart';

/**
 * 本示例源自 https://github.com/badboy-tian/flutter_panovel_app
 * 此处仅作学习交流之用，感谢原作者
 */
class OnlineNovelReadDemoSample extends StatefulWidget {
	final String title;
	OnlineNovelReadDemoSample({this.title});

	@override
	createState() => new OnlineNovelReadDemoSampleState(title);
}

class OnlineNovelReadDemoSampleState extends State<OnlineNovelReadDemoSample> {
	final String title;
	OnlineNovelReadDemoSampleState(this.title);

	var _currentIndex = 0;  // 当前页索引
	var _hideBottomNavBar = false; // 是否隐藏底部导航

	@override
	Widget build(BuildContext context) {

		return new Scaffold(
			body: new Stack(
				children: <Widget>[
					new Offstage(
						offstage: _currentIndex != 0,
						child: new TickerMode(
							enabled: _currentIndex == 0,
							child: new HomePage(this.title),
						)
					),
					new Offstage(
						offstage: _currentIndex != 1,
						child: new TickerMode(
							enabled: _currentIndex == 1,
							child: new SavePage(),
						)
					),
					new Offstage(
						offstage: _currentIndex != 2,
						child: new TickerMode(
							enabled: _currentIndex == 2,
							child: new MePage(),
						)
					),
				],
			),
			bottomNavigationBar: _hideBottomNavBar ? null : buildBottomNavBar(),
		);
	}


	@override
	void initState() {
		super.initState();
	}

	BottomNavigationBar buildBottomNavBar() {
		return new BottomNavigationBar(items:
			[
				new BottomNavigationBarItem(icon: new Icon(Icons.home), title: new Text('首页')),
				new BottomNavigationBarItem(icon: new Icon(Icons.menu), title: new Text('收藏')),
				new BottomNavigationBarItem(icon: new Icon(Icons.account_box), title: new Text('我的'))
			],
			currentIndex: _currentIndex,
			onTap: (int index) {
				setState(() {
				  	this._currentIndex = index;
				});
			},
			fixedColor: Colors.blue,
		);
	}

}


/// 关于我
class MePage extends StatefulWidget {
	@override
	_MePageState createState() => new _MePageState();
}

class _MePageState extends State<MePage> {
	@override
	Widget build(BuildContext context) {
		return new Scaffold(
			appBar: new AppBar(title: new Text("我的"),elevation: Styles.Elevation,),
			body: new Center(child: new Text("敬请期待")),
		);
	}
}
