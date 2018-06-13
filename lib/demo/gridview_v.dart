import 'package:flutter/material.dart';
import '../utils/common.dart';

class GridViewDemo extends StatefulWidget {
    final String title;
    GridViewDemo({this.title});

  @override
  createState() => new GridViewDemoState(title);
}

class GridViewDemoState extends State<GridViewDemo> {
    final String title;
    GridViewDemoState(this.title);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(title), elevation: Styles.Elevation,
        ),
        body: new GridView.count(
            crossAxisCount: 2,
            children: new List.generate(100, (index) {
              return new Center(
                  child: new MyButton(
                'Item $index',
                style: Theme.of(context).textTheme.headline,
              ));
            })));
  }
}

// 带触莫水波效果的 Button
class MyButton extends StatelessWidget {
  final String text;
  final TextStyle style;

  MyButton(this.text, {this.style});

  @override
  Widget build(BuildContext context) {
    // The InkWell Wraps our custom flat button Widget
    return new InkWell(
      // When the user taps the button, show a snackbar
      onTap: () {
        Scaffold.of(context).showSnackBar(new SnackBar(
              content: new Text('Tap'),
            ));
      },
      child: new Container(
        padding: new EdgeInsets.all(8.0),
        child: new Text(text, style: this.style),
      ),
    );
  }
}
