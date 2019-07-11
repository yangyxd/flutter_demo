import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import '../utils/common.dart';
import 'dart:async';

const kAndroidUserAgent =
    "Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Mobile Safari/537.36";
String selectedUrl = "https://www.baidu.com";

class HtmlViewSample extends StatefulWidget {
  final String title;
  HtmlViewSample({this.title});

  @override
  createState() => new HtmlViewSampleState();
}

class HtmlViewSampleState extends State<HtmlViewSample> {
  final String html = '<h1>This is &nbsp;heading 1</h1> <p><video src="http://yun.it7090.com/video/XHLaunchAd/video03.mp4"></video></p> <h2>This is heading 2</h2><h3>This is heading 3</h3><h4>This is heading 4</h4><h5>This is heading 5</h5><h6>This is heading 6</h6><p><img alt="Test Image" src="https://img0.pclady.com.cn/pclady/1806/19/1830196_dilireba2.jpg" /></p><a href="https://www.baidu.com">Go Baidu</a> <a href="mailto:ponnamkarthik3@gmail.com">Mail to me</a>';

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        elevation: Styles.Elevation,
        title: new Text(widget.title),
      ),
      body: new SingleChildScrollView(
        child: new Center(
          child: new Html(data: html),
        ),
      ),
    );
  }

}