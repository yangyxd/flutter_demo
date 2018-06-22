import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../utils/common.dart';

class ButtonSample extends StatefulWidget {
  final String title;
  ButtonSample({this.title});

  @override
  createState() => new ButtonSampleState();


}

class ButtonSampleState extends State<ButtonSample> with TickerProviderStateMixin {
  String dropdownButtonValue = null;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        elevation: Styles.Elevation,
        title: new Text(widget.title),
      ),
      body: new ListView(
        padding: const EdgeInsets.all(12.0),
        children: <Widget>[
          new MaterialButton(onPressed: (){}, child: new Text("MeterialButton"), color: Colors.grey, highlightColor: Colors.black12, textColor: Colors.white,),
          new SizedBox(height: 8.0,),
          new MaterialButton(onPressed: (){}, child: new Text("MeterialButton"), color: Colors.red, textColor: Colors.white, height: 32.0, elevation: 0.0, ),
          new SizedBox(height: 8.0,),
          new FlatButton(onPressed: (){}, child: new Text("FlatButton"), textColor: Colors.black54,),
          new SizedBox(height: 8.0,),
          new FlatButton(onPressed: (){}, child: new Text("FlatButton"), textColor: Colors.black54, color: Colors.cyanAccent),
          new SizedBox(height: 8.0,),
          new OutlineButton(onPressed: (){}, child: new Text("OutlineButton"), highlightElevation: 0.0, color: Colors.blue, textColor: Colors.red, disabledTextColor: Colors.white,
            borderSide: const BorderSide(width: 5.0, color: Colors.red), padding: const EdgeInsets.all(12.0), highlightedBorderColor: Colors.blueAccent),
          new SizedBox(height: 8.0,),
          new OutlineButton.icon(onPressed: () {}, icon: new Icon(Icons.account_balance, size: 24.0,), label: new Text("OutlineButton icon"),
            color: Colors.blue, highlightedBorderColor: Colors.blue, splashColor: Colors.transparent, highlightElevation: 0.0, ),
          new SizedBox(height: 8.0,),
          new RaisedButton(onPressed: (){}, child: new Text("RaisedButton"), animationDuration: const Duration(microseconds: 10), ),
          new SizedBox(height: 8.0,),
          new RaisedButton(onPressed: (){}, child: new Text("RaisedButton"), elevation: 0.0, color: Colors.amber, splashColor: Colors.blue, shape: new RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(const Radius.circular(16.0))
          )),
          new SizedBox(height: 8.0,),
          new IconButton(icon: new Icon(Icons.ac_unit), onPressed: () {}, color: Colors.cyan),
          new SizedBox(height: 8.0,),
          new DropdownButton<String>(items: <DropdownMenuItem<String>>[
            new DropdownMenuItem(value: "列表项1", child: new Text("1： 列表1"),),
            new DropdownMenuItem(value: "列表项2", child: new Text("2： 列表2"),),
            new DropdownMenuItem(value: "列表项3", child: new Text("3： 列表3"),),
            new DropdownMenuItem(value: "列表项4", child: new Icon(Icons.android)),
          ], onChanged: (value){
            print(value);
            setState(() {
              dropdownButtonValue = value;
            });
          }, hint: new Text("提示内容"), value: dropdownButtonValue, isDense: false),
          new SizedBox(height: 8.0,),
          new PopupMenuButton<Choice>(itemBuilder: (BuildContext context){
            return choices.skip(2).map((Choice choice) {
              return new PopupMenuItem<Choice>(
                value: choice,
                child: new Text(choice.title),
              );
            }).toList();
          }, tooltip: "选择提示", child: new Text("PopupMenuButton"), onSelected: (Choice v) {
            Tools.toast(v.title);
          },),
          new SizedBox(height: 8.0,),
          new FloatingActionButton.extended(onPressed: (){}, icon: new Icon(Icons.add), label: new Text("FloatingActionButton")),
          new SizedBox(height: 8.0,),
          new Divider(),
          new CupertinoButton(child: new Text("CupertinoButton"), onPressed: (){}),
          new SizedBox(height: 8.0,),
          new CupertinoButton(child: new Text("CupertinoButton"), onPressed: (){
            CupertinoAlertDialog dlg = new CupertinoAlertDialog(
              title: new Text( "标题"),
              content: new Text("Cupertino Alert Dialog Content."),
              actions: <Widget>[
                new CupertinoButton(child: new Text("确定"), onPressed: (){}),
                new CupertinoButton(child: new Text("取消"), onPressed: (){Navigator.pop(context);}),
              ],
            );
            showDialog(context: context, child: dlg);
          }, color: Colors.red,
            borderRadius: const BorderRadius.all(const Radius.circular(16.0)),
            pressedOpacity: 0.5,
            padding: const EdgeInsets.all(4.0),
            minSize: 32.0,
          ),
          //new SizedBox(height: 8.0,),
        ],
      ),
    );
  }

}


class Choice {
  const Choice({ this.title, this.icon });
  final String title;
  final IconData icon;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: 'Car', icon: Icons.directions_car),
  const Choice(title: 'Bicycle', icon: Icons.directions_bike),
  const Choice(title: 'Boat', icon: Icons.directions_boat),
  const Choice(title: 'Bus', icon: Icons.directions_bus),
  const Choice(title: 'Train', icon: Icons.directions_railway),
  const Choice(title: 'Walk', icon: Icons.directions_walk),
];