import 'package:flutter/material.dart';
import '../utils/common.dart';

class DatetimeSample extends StatefulWidget {
  const DatetimeSample();

  @override
  createState() => new _DatetimeSampleState();
}

class _DatetimeSampleState extends State<DatetimeSample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: Styles.Elevation,
        title: Text("日期时间操作"),
      ),
      body: Scrollbar(child: Column(
        children: <Widget>[

        ],
      ))
    );
  }
}