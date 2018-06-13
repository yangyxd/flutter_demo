import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;
import 'package:html2md/html2md.dart' as html2md;
import 'BookBeans.dart';
import '../../utils/common.dart';
import 'AllChapterPage.dart';
import 'SavedBook.dart';
import 'dart:math';

/// 阅读界面
class ReaderPage extends StatefulWidget {
  @override
  _ReaderPageState createState() => new _ReaderPageState(chapter);

  final Chapter chapter;

  ReaderPage(this.chapter);
}

class _ReaderPageState extends State<ReaderPage> {
  final Chapter chapter;

  _ReaderPageState(this.chapter);

  @override
  void initState() {
    super.initState();
    _title = chapter.name;

    loadData();
  }

  var _loading = false;
  var _lvVisable = true;
  var _title = "";

  @override
  Widget build(BuildContext context) {
    print(chapter.chapterid);
    return new Scaffold(
      body: buildBody(),
      floatingActionButton: new Opacity(
          opacity: _lvVisable ? 1.0 : 0.0,
          child: new FloatingActionButton(
            onPressed: () {
              _controller.animateTo(_controller.position.maxScrollExtent,
                  duration: new Duration(milliseconds: 300),
                  curve: Curves.easeOut);
            },
            child: new Icon(Icons.arrow_downward),
            backgroundColor: Colors.grey,
            mini: true,
          )),
    );
  }

  var _controller = ScrollController();

  Widget boxAdapterWidget(context) {
    return new Column(children: <Widget>[
      new Padding(
          padding: new EdgeInsets.all(10.0),
          child: Text(
            html2md.convert(text),
            style: Styles.buildStyleAndSpace(new Color(0xFF101010), 16, 1.5),
          )),
      new Divider(
        height: 1.0,
      ),
      new Container(
          child: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new FlatButton(
              onPressed: () {
                if (lasturl != "./") {
                  print(lasturl);
                  setState(() {
                    chapter.chapterid = lasturl.replaceAll(".html", "");
                    loadData();
                  });
                } else {
                  Scaffold
                      .of(context)
                      .showSnackBar(new SnackBar(content: new Text("没有上一章了")));
                }
              },
              child: new Text(
                "上一章",
              )),
          new FlatButton(
              onPressed: () {
                Tools.startPage(
                    context, new AllChapterPage(chapter.bookid, "目录"));
              },
              child: new Text("目录")),
          new FlatButton(
              onPressed: () {
                if (nexturl != "./") {
                  setState(() {
                    chapter.chapterid = nexturl.replaceAll(".html", "");
                    loadData();
                  });
                } else {
                  Scaffold
                      .of(context)
                      .showSnackBar(new SnackBar(content: new Text("没有下一章了")));
                }
              },
              child: new Text("下一章")),
        ],
      ))
    ]);
  }

  Widget buildBody() {
    if (_loading) {
      return new Scaffold(
        appBar: new AppBar(
          title: new Text(
            _title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          elevation: Styles.Elevation,
        ),
        body: new Container(
          child: new Center(child: new CircularProgressIndicator()),
		)
      );
    }

    return new Scaffold(
        body: new CustomScrollView(
      slivers: <Widget>[
        new SliverAppBar(
          title: new Text(
            _title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          pinned: false,
          elevation: Styles.Elevation,
          expandedHeight: 50.0,
          floating: true,
          snap: true,
//          flexibleSpace: new FlexibleSpaceBar(
//            title: new Text(
//				_title,
//				maxLines: 1,
//				overflow: TextOverflow.ellipsis,
//			),
//			  background: null,
//          ),
          actions: <Widget>[
            new IconButton(icon: new Icon(Icons.share), onPressed: () {})
          ],
        ),
        new SliverToBoxAdapter(
          child: boxAdapterWidget(context),
        )
      ],
    ));
  }

  var text = "";

  var REGEX_SCRIPT = "<script[^>]*?>[\\s\\S]*?<\\/script>";
  var P_SCRIPT = "<p[^>]*?>[\\s\\S]*?<\\/p>";
  var lasturl = "";
  var nexturl = "";
  var dir = "";
  var url = "";

  void loadData() async {
    setState(() {
      _loading = true;
    });
    url = "${Common.book_baseurl}/${chapter.bookid}/${chapter.chapterid}.html";
    print("loadData: " + url);
    http.get(url, headers: header).then((resp) {
      if (!mounted) return;

      setState(() {
        var root = parser.parse(resp.body);
        _title = root.querySelector("title").text;
        chapter.name = _title;
        lasturl = root.querySelector("a#pt_prev").attributes["href"];
        nexturl = root.querySelector("a#pt_next").attributes["href"];
        dir = root.querySelector("a#pt_mulu").attributes["href"];
        text = root
            .querySelector("div.Readarea")
            .innerHtml
            .replaceAll(new RegExp(REGEX_SCRIPT), "")
            .replaceAll(new RegExp(P_SCRIPT), "");
        _loading = false;
      });

      //更新最新阅读的章节
      SavedBookDao.getInstance().then((value) async {
        var old = await value.get(chapter.bookid);
        if (old != null) {
          old.lastChapterID = chapter.chapterid;
          old.lastChapterName = chapter.name;
          value.update(old).then((value) {
            //eventBus.fire("updateNewChapter");
          });
        }
      });
    }).catchError((onError) {
      Tools.toast("错误:${onError.toString()}");
      Navigator.of(context).pop();
      print(onError.toString());
    });
  }

  static var _agents = [
    "Mozilla/5.0 (iPhone 84; CPU iPhone OS 10_3_3 like Mac OS X) AppleWebKit/603.3.8 (KHTML, like Gecko) Version/10.0 MQQBrowser/7.8.0 Mobile/14G60 Safari/8536.25 MttCustomUA/2 QBWebViewType/1 WKType/1",
    "Mozilla/5.0 (Linux; Android 7.0; STF-AL10 Build/HUAWEISTF-AL10; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/53.0.2785.49 Mobile MQQBrowser/6.2 TBS/043508 Safari/537.36 V1_AND_SQ_7.2.0_730_YYB_D QQ/7.2.0.3270 NetType/4G WebP/0.3.0 Pixel/1080",
    "Mozilla/5.0 (iPhone; CPU iPhone OS 10_3_3 like Mac OS X) AppleWebKit/603.3.8 (KHTML, like Gecko) Mobile/14G60 MicroMessenger/6.5.18 NetType/WIFI Language/en",
    "Mozilla/5.0 (Linux; Android 5.1.1; vivo Xplay5A Build/LMY47V; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/48.0.2564.116 Mobile Safari/537.36 T7/9.3 baiduboxapp/9.3.0.10 (Baidu; P1 5.1.1)",
    "Mozilla/5.0 (Linux; U; Android 7.0; zh-cn; STF-AL00 Build/HUAWEISTF-AL00) AppleWebKit/537.36 (KHTML, like Gecko)Version/4.0 Chrome/37.0.0.0 MQQBrowser/7.9 Mobile Safari/537.36",
    "Mozilla/5.0 (Linux; Android 6.0; LEX626 Build/HEXCNFN5902606111S) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/35.0.1916.138 Mobile Safari/537.36 T7/7.4 baiduboxapp/8.3.1 (Baidu; P1 6.0)",
    "Mozilla/5.0 (iPhone 92; CPU iPhone OS 10_3_2 like Mac OS X) AppleWebKit/603.2.4 (KHTML, like Gecko) Version/10.0 MQQBrowser/7.7.2 Mobile/14F89 Safari/8536.25 MttCustomUA/2 QBWebViewType/1 WKType/1",
    "Mozilla/5.0 (Linux; U; Android 7.0; zh-CN; ZUK Z2121 Build/NRD90M) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/40.0.2214.89 UCBrowser/11.6.8.952 Mobile Safari/537.36",
    "Mozilla/5.0 (iPhone; CPU iPhone OS 11_0 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Mobile/15A372 MicroMessenger/6.5.17 NetType/WIFI Language/zh_HK",
    "Mozilla/5.0 (Linux; U; Android 6.0.1; zh-CN; SM-C7000 Build/MMB29M) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/40.0.2214.89 UCBrowser/11.6.2.948 Mobile Safari/537.36",
    "MQQBrowser/5.3/Mozilla/5.0 (Linux; Android 6.0; TCL 580 Build/MRA58K; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/52.0.2743.98 Mobile Safari/537.36",
    "Mozilla/5.0 (iPhone; CPU iPhone OS 10_2 like Mac OS X) AppleWebKit/602.3.12 (KHTML, like Gecko) Mobile/14C92 MicroMessenger/6.5.16 NetType/WIFI Language/zh_CN",
    "" +
        "Mozilla/5.0 (Linux; U; Android 5.1.1; zh-cn; MI 4S Build/LMY47V) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/53.0.2785.146 Mobile Safari/537.36 XiaoMi/MiuiBrowser/9.1.3",
    "" +
        "Mozilla/5.0 (Linux; U; Android 7.0; zh-CN; SM-G9550 Build/NRD90M) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/40.0.2214.89 UCBrowser/11.7.0.953 Mobile Safari/537.36",
    "Mozilla/5.0 (Linux; Android 5.1; m3 note Build/LMY47I; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/48.0.2564.116 Mobile Safari/537.36 T7/9.3 baiduboxapp/9.3.0.10 (Baidu; P1 5.1)"
  ];

  static Map<String, String> header = {
    "User-Agent": _agents[new Random().nextInt(_agents.length - 1)]
  };
}
