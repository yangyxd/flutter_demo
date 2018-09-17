import 'package:flutter/material.dart';

/// 选项卡标题Widget
class CardTitle extends StatelessWidget {
  CardTitle(this.title, {Key key}) : super(key: key);

  final String title;

  @override
    Widget build(BuildContext context) {
      // TODO: implement build
      return Text(title, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold));
  }
}