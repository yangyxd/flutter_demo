import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import '../utils/common.dart';
import 'dart:async';

const kAndroidUserAgent =
    "Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Mobile Safari/537.36";
String selectedUrl = "https://www.baidu.com";

class WebViewSample extends StatefulWidget {
  final String title;
  WebViewSample({this.title});

  @override
  createState() => new WebViewSampleState();
}

class WebViewSampleState extends State<WebViewSample> {

  final flutterWebviewPlugin = new FlutterWebviewPlugin();

  StreamSubscription _onDestroy;
  StreamSubscription<String> _onUrlChanged;
  StreamSubscription<WebViewStateChanged> _onStateChanged;

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  TextEditingController _urlCtrl = new TextEditingController(text: selectedUrl);
  TextEditingController _codeCtrl = new TextEditingController(text: "window.navigator.userAgent");

  final List _history = [];

  @override
  Widget build(BuildContext context) {
    var top = kToolbarHeight + Tools.getSysStatsHeight(context) + 1;
    flutterWebviewPlugin.launch(selectedUrl,
        rect: new Rect.fromLTWH(
            0.0, top, MediaQuery.of(context).size.width, MediaQuery.of(context).size.height - top),
        userAgent: kAndroidUserAgent);

    return new Scaffold(
      appBar: new AppBar(
        elevation: Styles.Elevation,
        title: new Text(widget.title),
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.more_vert), onPressed: () {

          })
        ],
      ),
//      body: new Column(
//        mainAxisAlignment: MainAxisAlignment.center,
//        children: [
//          new Container(
//            padding: const EdgeInsets.all(24.0),
//            child: new TextField(controller: _urlCtrl),
//          ),
//          new RaisedButton(
//            onPressed: () {
//              flutterWebviewPlugin.launch(selectedUrl,
//                  rect: new Rect.fromLTWH(
//                      0.0, 0.0, MediaQuery.of(context).size.width, 300.0),
//                  userAgent: kAndroidUserAgent);
//            },
//            child: new Text("Open Webview (rect)"),
//          ),
//          new RaisedButton(
//            onPressed: () {
//              flutterWebviewPlugin.launch(selectedUrl, hidden: true);
//            },
//            child: new Text("Open 'hidden' Webview"),
//          ),
//          new RaisedButton(
//            onPressed: () {
//              flutterWebviewPlugin.launch(selectedUrl);
//            },
//            child: new Text("Open Fullscreen Webview"),
//          ),
//          new RaisedButton(
//            onPressed: () {
//              Navigator.of(context).pushNamed("/widget");
//            },
//            child: new Text("Open widget webview"),
//          ),
//          new Container(
//            padding: const EdgeInsets.all(24.0),
//            child: new TextField(controller: _codeCtrl),
//          ),
//          new RaisedButton(
//            onPressed: () {
//              Future<String> future =
//              flutterWebviewPlugin.evalJavascript(_codeCtrl.text);
//              future.then((String result) {
//                setState(() {
//                  _history.add("eval: $result");
//                });
//              });
//            },
//            child: new Text("Eval some javascript"),
//          ),
//          new RaisedButton(
//            onPressed: () {
//              setState(() {
//                _history.clear();
//              });
//              flutterWebviewPlugin.close();
//            },
//            child: new Text("Close"),
//          ),
//          new RaisedButton(
//            onPressed: () {
//              flutterWebviewPlugin.getCookies().then((m) {
//                setState(() {
//                  _history.add("cookies: $m");
//                });
//              });
//            },
//            child: new Text("Cookies"),
//          ),
//          new Text(_history.join("\n"))
//        ],
//      ),
    );
  }

  @override
  void initState() {
    super.initState();
    flutterWebviewPlugin.close();

    _urlCtrl.addListener(() {
      selectedUrl = _urlCtrl.text;
    });

    _onDestroy = flutterWebviewPlugin.onDestroy.listen((_) {
      if (mounted) {
        // Actions like show a info toast.
        _scaffoldKey.currentState
            .showSnackBar(new SnackBar(content: new Text("Webview Destroyed")));
      }
    });

    // Add a listener to on url changed
    _onUrlChanged = flutterWebviewPlugin.onUrlChanged.listen((String url) {
      if (mounted) {
        setState(() {
          _history.add("onUrlChanged: $url");
        });
      }
    });

    _onStateChanged =
        flutterWebviewPlugin.onStateChanged.listen((WebViewStateChanged state) {
          if (mounted) {
            setState(() {
              _history.add("onStateChanged: ${state.type} ${state.url}");
            });
          }
        });

  }


  @override
  void dispose() {
    // Every listener should be canceled, the same should be done with this stream.
    _onDestroy.cancel();
    _onUrlChanged.cancel();
    _onStateChanged.cancel();

    flutterWebviewPlugin.close();
    flutterWebviewPlugin.dispose();

    super.dispose();
  }

}
