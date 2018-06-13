import 'dart:async';
import 'package:flutter/material.dart';
import '../../utils/common.dart';
import 'package:html/parser.dart' as parse;
import 'package:http/http.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'BookDetailPage.dart';
import 'BookBeans.dart';
import 'SearchResultPage.dart';

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

	final _tabBarView = [
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
		new HomeRankPage()
	];

	_HomePageState(this.title) {
		//
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
				elevation: Styles.Elevation,
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
			style: Styles.buildStyle(Colors.black, 15),
			decoration: new InputDecoration(
					border: InputBorder.none,
					hintText: "搜索书名/作者",
					hintStyle: Styles.buildStyle(Colors.grey, 15),
					suffixIcon: new Offstage(
						offstage:
						editController.text == null || editController.text.isEmpty,
						child: new IconButton(
								icon: Icon(
									Icons.refresh,
									color: Colors.grey,
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
								Icons.close,
								color: Colors.grey,
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
			  Tools.startPage(
					context, new SearchResultPage(words: text));
			},
			onChanged: (text) {
				setState(() {});
			},
		);
	}
}

// 排行页面
class HomeRankPage extends StatefulWidget {
	@override
	_HomeRankPageState createState() => new _HomeRankPageState();
}

class _HomeRankPageState extends State<HomeRankPage> {

	@override
	Widget build(BuildContext context) {
		return new Container();
	}
}

// 主页子页面
class HomeSubPage extends StatefulWidget {
	final int index;
	final ValueChanged<bool> hideBottom;

	final List<BklistItem> _datas = [];
	final _scroller = new ScrollController();

	HomeSubPage({Key key, this.index, this.hideBottom}) : super(key: key) {
	}

	@override
	_HomeItemState createState() => new _HomeItemState(index, this.hideBottom, this._datas, this._scroller);
}

class _HomeItemState extends State<HomeSubPage> {
	final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
	final List<BklistItem> _datas;

	var index = 1;
	final ValueChanged<bool> hideBottom;
	ScrollController _scroller;

	_HomeItemState(this.index, this.hideBottom, this._datas, this._scroller);

	@override
	void initState() {
		super.initState();
		// 初始化加载数据
		if (_datas.isEmpty)
			loadDatas(false);
	}

	@override
	Widget build(BuildContext context) {
		if (_datas.isEmpty) {
			return new Center(child: new CircularProgressIndicator());
		} else {
			var c = _datas.length;
			if (isLoadingmore)
				c++;
			return new NotificationListener(
				onNotification: onNotification,
				child: new RefreshIndicator(
					key: _refreshIndicatorKey,
					child: new ListView.builder(
						physics: new AlwaysScrollableScrollPhysics(),
						controller: _scroller,
						itemCount: c,
						itemBuilder: buildBkItem,
						padding: new EdgeInsets.only(top: 10.0, bottom: 10.0),
					),
					onRefresh: refresh));
		}
	}

	bool onNotification(Notification notification) {
		// 如果滚动到底部了，加载更多
		if (notification is OverscrollNotification) {
			if (!isLoadingmore) {
				isLoadingmore = true;
				print("loading more");
				if (_currentPage > _totalPage) {
					setState(() {
						isLoadingmore = false;
					});
					return true;
				}
				setState(() {
					_currentPage++;
				});
				loadDatas(false);
			}
		}
		return true;
	}

	bool isLoadingmore = false; // 是否正在加载更多
	int _currentPage = 1; // 当前已加载的页数
	int _totalPage = 1; // 总页数

	// 刷新
	Future<Null> refresh() async {
		setState(() {
			_currentPage = 1;
		});
		await loadDatas(true);
	}


	// 加载数据
	Future loadDatas(bool refresh) async {
		var url = "${Common.book_baseurl}/bqgclass/$index/$_currentPage.html";
		print(url);
		var response = await get(url);
		var html = parse.parse(response.body);
		var itemData = html.getElementsByClassName("hot_sale");
		_totalPage = int.parse(
				html.getElementById("txtPage").attributes["value"].split("/")[1]);

		if (isLoadingmore) {
			isLoadingmore = false;
		}
		if (!mounted) return;
		setState(() {
			if (refresh) {
				_datas.clear();
			}
			_datas.addAll(BklistItem.parse(itemData));
		});
	}

	// 构造列表项
	Widget buildBkItem(BuildContext context, int index) {

		if (isLoadingmore && index == _datas.length) {
			return new Row(
				mainAxisAlignment: MainAxisAlignment.center,
				children: <Widget>[
					new Text(
						'正在加载数据...',
						style: new TextStyle(fontSize: 15.0, height: 2.0, color: new Color(0xFFd0d0d0)),
					)
				],
			);
		}

		var item = _datas[index];
		return new InkWell(
			onTap: () {
				print(item.url);
				if (hideBottom != null) {
					hideBottom(true);
				}
				Tools.startPage(
					context, new BookDetailPage(bookid: item.bookID, title: item.title,));
			},
			child: new Container(
				child: new Row(
					mainAxisAlignment: MainAxisAlignment.center,
					children: <Widget>[
						new Container(
							child: new CachedNetworkImage(
								imageUrl: item.img,
								width: 60.0, height: 80.0),
							padding: new EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
						),
						new Expanded(
							child: new Column(
								crossAxisAlignment: CrossAxisAlignment.start,
								children: <Widget>[
									new Row(
										children: <Widget>[
											new Text(
												item.title,
												style: new TextStyle(fontSize: 15.0, color: new Color(0xFF212121)),
											)
										],
									),
									new Row(
										children: <Widget>[
											new Expanded(
												child: new Text(
													item.review,
													maxLines: 2,
													overflow: TextOverflow.ellipsis,
													style: new TextStyle(fontSize: 12.0, color: new Color(0xFF757575)),
												),
											)
										],
									),
									new Row(
										children: <Widget>[
											new Text(
												item.author,
												style: new TextStyle(fontSize: 12.0, color: new Color(0xFF757575)),
											)
										],
									),
								]
							)
						)
					],
				),
				decoration: new BoxDecoration(
					border: new Border(bottom: new BorderSide(color: Styles.lineColor, width: 0.5))),
			));
	}
}


