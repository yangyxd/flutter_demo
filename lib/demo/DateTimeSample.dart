import 'package:flutter/material.dart';
import '../utils/common.dart';

class DatetimeSample extends StatefulWidget {
  const DatetimeSample();

  @override
  createState() => new _DatetimeSampleState();
}

class _DatetimeSampleState extends State<DatetimeSample> {
  var t1 = new DateTime.now();
  var t2 = null;
  var t1Controller = TextEditingController(text: "100");

  void _updateDate() {
    t2 = Tools.dateOffset(t1, Tools.strToInt(t1Controller.text));
  }

  @override
  Widget build(BuildContext context) {
    _updateDate();
    return Scaffold(
      appBar: AppBar(
        elevation: Styles.Elevation,
        title: Text("日期时间操作"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: <Widget>[
          _buildItem1(context),
          _buildItem2(context),
          _buildItem3(context),
        ],
      )
    );
  }

  Widget _buildItem1(BuildContext context) {
    return buildCard('N天后的日期：', Row(
      children: <Widget>[
        MaterialButton(
            child: Text(Tools.dateToStr(t1)),
            onPressed: () {
              showDatePicker(
                context: context,
                initialDate: t1,
                firstDate: new DateTime.now().subtract(new Duration(days: 365000)),
                lastDate: new DateTime.now().add(new Duration(days: 365000)),
              ).then((DateTime val) {
                if (val == null) return;
                setState(() {
                  t1 = val;
                });
              });
            }
        ),
        SizedBox(width: 8.0),
        Expanded(
            child: Container(
              height: 36.0,
              child: TextField(
                controller: t1Controller,
                scrollPadding: EdgeInsets.all(0.0),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    gapPadding: 0.0,
                  ),
                  focusedBorder: OutlineInputBorder(
                    gapPadding: 0.0,
                  ),
                  suffixText: "天后是 ${t2 == null ? "" : Tools.dateToStr(t2)}",
                  prefixText: "的  ",
                  contentPadding: EdgeInsets.fromLTRB(12.0, 8.0, 8.0, 4.0),
                ),
                onSubmitted: (v) {
                  setState(() {
                    _updateDate();
                  });
                },
              ),
            )
        )
      ],
    ));
  }

  var t3 = DateTime.now();
  var t4 = DateTime.now().add(new Duration(days: 1));

  Widget _buildItem2(BuildContext context) {
    return buildCard('日期之间的天数：', Row(
      children: <Widget>[
        MaterialButton(
            child: Text(Tools.dateToStr(t3)),
            onPressed: () {
              showDatePicker(
                context: context,
                initialDate: t3,
                firstDate: new DateTime.now().subtract(new Duration(days: 365000)),
                lastDate: new DateTime.now().add(new Duration(days: 365000)),
              ).then((DateTime val) {
                if (val == null) return;
                setState(() {
                  t3 = val;
                });
              });
            }
        ),
        SizedBox(width: 8.0),
        Text('与'),
        SizedBox(width: 8.0),
        MaterialButton(
            child: Text(Tools.dateToStr(t4)),
            onPressed: () {
              showDatePicker(
                context: context,
                initialDate: t4,
                firstDate: new DateTime.now().subtract(new Duration(days: 365000)),
                lastDate: new DateTime.now().add(new Duration(days: 365000)),
              ).then((DateTime val) {
                if (val == null) return;
                setState(() {
                  t4 = val;
                });
              });
            }
        ),
        SizedBox(width: 8.0),
        Text('相隔  ${Tools.daysBetween(t3, t4)}  天'),
      ],
    ));
  }

  var t5 = DateTime.now();

  Widget _buildItem3(BuildContext context) {
    return buildCard("时间戳(毫秒)", Row(
      children: <Widget>[
        MaterialButton(
            child: Text(Tools.dateTimeToStr(t5)),
            onPressed: () {
              showDatePicker(
                context: context,
                initialDate: t5,
                firstDate: new DateTime.now().subtract(new Duration(days: 365000)),
                lastDate: new DateTime.now().add(new Duration(days: 365000)),
              ).then((DateTime val) {
                if (val == null) return;
                setState(() {
                  t5 = val;
                });
              });
            }
        ),
        SizedBox(width: 8.0),
        Text('${t5.millisecondsSinceEpoch}'),
        SizedBox(width: 16.0),
        FlatButton(
          child: Text('现在'),
          onPressed: () {
            setState(() {
              t5 = DateTime.now();
            });
          },
        )
      ],
    ));
  }

  Widget buildCard(String title, Widget child) {
    return Card(
      elevation: 1.0,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(title),
            SizedBox(height: 8.0),
            Container(
              child: child,
            )
          ],
        ),
      ),
    );
  }
}