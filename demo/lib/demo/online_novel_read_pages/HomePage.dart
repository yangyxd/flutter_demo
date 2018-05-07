import 'dart:async';
import 'package:flutter/material.dart';
import 'package:demo/utils/common.dart';
import 'package:html/dom.dart' as dom;

/// 主页
class HomePage extends StatefulWidget {
	String title;

	HomePage(this.title);

	@override
	_HomePageState createState() => new _HomePageState(this.title);
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
	final String title;

	TabController tabController;

	var _tabs = [
		new Tab(text: "玄幻"),
		new Tab(text: "仙侠"),
		new Tab(text: "都市"),
		new Tab(text: "历史"),
		new Tab(text: "网游"),
		new Tab(text: "科幻"),
		new Tab(text: "女生"),
		new Tab(text: "排行")
	];

	var _tabBarView = <Widget>[];

	_HomePageState(this.title) {
		_tabBarView = [
			new HomeSubPage(
				index: 1,
			),
			new HomeSubPage(
				index: 2,
			),
			new HomeSubPage(
				index: 3,
			),
			new HomeSubPage(
				index: 4,
			),
			new HomeSubPage(
				index: 5,
			),
			new HomeSubPage(
				index: 6,
			),
			new HomeSubPage(
				index: 7,
			),
//			new HomeRankPage()
		];
	}

	@override
	void initState() {
		tabController = new TabController(length: _tabs.length, vsync: this);
		super.initState();
	}

	@override
	void dispose() {
		tabController.dispose();
		super.dispose();
	}

	bool isSearch = false;

	@override
	Widget build(BuildContext context) {
		return new Scaffold(
			appBar: new AppBar(
				title: isSearch ? buildSearchView() : new Text(this.title),
				bottom: new TabBar(
					isScrollable: true,
					controller: tabController,
					tabs: _tabs,
				),
				actions: buildActions(),
			),
			body: new TabBarView(
				controller: tabController,
				children: _tabBarView,
			));
	}

	int preClicked = 0;

	Future<bool> _requestPop() {
		if (isSearch) {
			setState(() {
				isSearch = false;
				editController.clear();
			});
			return new Future.value(false);
		}

		return new Future.value(true);
	}

	List<Widget> buildActions() {
		var list = <Widget>[];
		if (!isSearch) {
			list.add(new IconButton(
				icon: new Icon(Icons.search),
				onPressed: () {
					setState(() {
						isSearch = true;
					});
				},
			));
		}

		list.add(new IconButton(
			icon: new Icon(Icons.share),
			onPressed: () {},
		));

		return list;
	}

	var editController = TextEditingController();

	Widget buildSearchView() {
		return new TextField(
			controller: editController,
			style: Common.buildStyle(Colors.grey, 15),
			decoration: new InputDecoration(
					border: InputBorder.none,
					hintText: "书名/作者",
					hintStyle: Common.buildStyle(Colors.white30, 15),
					suffixIcon: new Offstage(
						offstage:
						editController.text == null || editController.text.isEmpty,
						child: new IconButton(
								icon: Icon(
									Icons.clear,
									color: Colors.white,
								),
								onPressed: () {
									setState(() {
										editController.clear();
									});
								}),
					),
					prefixIcon: new IconButton(
							padding: new EdgeInsets.only(
									left: 0.0, right: 8.0, top: 8.0, bottom: 8.0),
							icon: new Icon(
								Icons.arrow_back,
								color: Colors.white,
							),
							onPressed: () {
								setState(() {
									editController.clear();
									isSearch = false;
								});
							})),
			onSubmitted: (text) {
				setState(() {
					editController.clear();
					isSearch = false;
				});
//				Navigator.push(
//						context,
//						new MyCustomRoute(
//								builder: (_) => new SearchResultPage(words: text)));
			},
			onChanged: (text) {
				setState(() {});
			},
		);
	}
}

// 主页子页面
class HomeSubPage extends StatefulWidget {
	final int index;
	final ValueChanged<bool> hideBottom;

	HomeSubPage({Key key, this.index, this.hideBottom}) : super(key: key);

	@override
	_HomeItemState createState() => new _HomeItemState(index, this.hideBottom);
}

class _HomeItemState extends State<HomeSubPage> {
	final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
	new GlobalKey<RefreshIndicatorState>();

	List<BklistItem> _datas = [];

	var index = 1;
	final ValueChanged<bool> hideBottom;
	ScrollController _scroller;

	_HomeItemState(this.index, this.hideBottom);

	@override
	Widget build(BuildContext context) {
		return new Center(child: new CircularProgressIndicator());
	}
}

// 小说列表项
class BklistItem {
	String img;
	String title;
	String author;
	String review;
	String url;
	String bookID;

	@override
	String toString() {
		return 'BklistItem{img: $img, title: $title, author: $author, review: $review, url: $url, bookID: $bookID}';
	}

	static List<BklistItem> parse(List<dom.Element> es) {
		List<BklistItem> datas = [];
		es.forEach((e) {
			var item = BklistItem();
			item.title = e.querySelector("p.title").text.trim();
			item.author = e.querySelector("p.author").text.trim();
			item.img = e.querySelector("img.lazy").attributes["data-original"].trim();
			item.review = e.querySelector("p.review").text.trim();
			item.url = e.querySelector("a").attributes["href"].trim();
			item.bookID = item.url.replaceAll("/", "");
			datas.add(item);
		});

		return datas;
	}
}