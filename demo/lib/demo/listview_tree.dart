import 'package:flutter/material.dart';
import 'package:demo/utils/common.dart';

class ListViewTreeDemo extends StatefulWidget {
    final String title;
    ListViewTreeDemo({this.title});

  @override
  createState() => new ListViewTreeDemoState(title,
    new List<ListItem>.generate(1000, 
      (i) => i % 6 == 0 ?
        new HeadingItem("Heading $i"): new MessageItem("Sender $i", "Message body $i"),
    ),
  );
}

class ListViewTreeDemoState extends State<ListViewTreeDemo> {
    final String title;
    List<ListItem> _items;

  ListViewTreeDemoState(this.title, this._items);

  @override
  Widget build(BuildContext context) {
    return new Scaffold (
        appBar: new AppBar(
          title: new Text(title), elevation: Common.Elevation,
        ),
        body: new Container(
            margin: new EdgeInsets.symmetric(vertical: 12.0),
            child: new ListView.builder(
                itemBuilder: (context, index) {
                  final item = _items[index];

                  if (item is HeadingItem) {
                    return new ListTile(
                      title: new Text(
                      item.heading,
                      style: Theme.of(context).textTheme.headline),
                    );
                  } else if (item is MessageItem) {
//                    return new ListTile(
//                      title: new Text(item.sender),
//                      subtitle: new Text(item.body),
//                      onTap: (){},
//                    );
                    // 滑动关闭
                    return new Dismissible(
                      // Each Dismissible must contain a Key. Keys allow Flutter to
                      // uniquely identify Widgets.
                      key: new Key(item.sender),
                      // We also need to provide a function that will tell our app
                      // what to do after an item has been swiped away.
                      onDismissed: (direction) {
                        Scaffold.of(context).showSnackBar(
                           new SnackBar(
                             content: new Text(item.sender + " dismissed.")
                           ));
                        setState(() {
                            _items.removeAt(index);
                        });
                      },
                      // Show a red background as the item is swiped away
                      background: new Container(color: Colors.red),
                      child: new ListTile(
                        title: new Text(item.sender),
                        subtitle: new Text(item.body),
                        onTap: (){},
                      ),
                    );

                  }
                }
            )
        )
    );
  }
}

abstract class ListItem {}

// A ListItem that contains data to display a heading
class HeadingItem implements ListItem {
  final String heading;

  HeadingItem(this.heading);
}

// A ListItem that contains data to display a message
class MessageItem implements ListItem {
  final String sender;
  final String body;

  MessageItem(this.sender, this.body);
}