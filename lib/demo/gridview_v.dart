import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/common.dart';

class GridViewDemo extends StatefulWidget {
    final String title;
    GridViewDemo({this.title});

  @override
  createState() => new GridViewDemoState(title);

  bool showAppBar = true;
}

class GridViewDemoState extends State<GridViewDemo> {
    final String title;
    GridViewDemoState(this.title);

  @override
  Widget build(BuildContext context) {
    //SystemChrome.setSystemUIOverlayStyle(Styles.uiStyle);

    return new Scaffold(
      appBar: widget.showAppBar ?  new AppBar(
        title: new Text(widget.title),
      ) : null,
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Container(
              color: Colors.yellow,
              height: 80.0,
              width: double.infinity,
              child: new Row(
                children: <Widget>[
                  new Checkbox(value: widget.showAppBar, onChanged: (bool v) {
                    setState(() {
                      widget.showAppBar = v;
                    });
                  }),
                  new Text("显示AppBar"),
                ],
              ),
            ),
            new Expanded(child: new Container(
              child: new Row(
                children: <Widget>[
                  new Container(
                    width: 60.0,
                    color: Colors.blueAccent,
                  ),
                  new Expanded(child: new GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: 1.8,
                      mainAxisSpacing: 2.0,
                      crossAxisSpacing: 2.0,
                      padding: const EdgeInsets.all(2.0),
                      children: new List.generate(20, (index) {
                        return  new InkWell(
                          child: new Container(
                            color: Colors.black26,
                            height: 60.0,
                          ),
                          onTap: () {},
                        );
                      })),
                  )
                ],
              ),
            ))
          ],
        ),
      ),
    );
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
