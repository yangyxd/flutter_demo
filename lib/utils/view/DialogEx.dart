import 'package:flutter/material.dart';

class DialogEx {
  /**
   * 生成一个等待动画
   */
  static Widget buildCircularProgress({String text,
    Color color = const Color(0x1f000000),
    TextStyle style,
    Color bgcolor = const Color(0xbf303030)})
  {
    var v;
    if (text == null || text.isEmpty)
      v = new CircularProgressIndicator(strokeWidth: 2.0);
    else
      v = new Wrap(
        direction: Axis.vertical,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 8.0,
        children: <Widget>[
          new CircularProgressIndicator(strokeWidth: 2.0),
          new Text(text, style: style,)
        ],
      );

    return new Positioned.fill(child: new Container(
      color: color,
      child: new Center(
        child: new ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 36.0, minHeight: 36.0),
          child: new Material(
            color: bgcolor,
            child: new Container(
              padding: const EdgeInsets.all(16.0),
              child: v,
            ),
            shape: const RoundedRectangleBorder(
                borderRadius: const BorderRadius.all(const Radius.circular(9.0))
            ),
          ),
        ),
      ),
    ));

  }

  static const double _DefaultIconSize = 32.0;
  static const double _DefaultIconSpace = 16.0;

  /** 列表显示对话框 */
  static show(BuildContext context, String title, List<Widget> items) {
    showDialog(
        context: context,
        builder: (BuildContext context)
    {
      return new SimpleDialog(title: title == null ? null : new Text(title), children: items);
    });
  }

  /** 列表显示对话框 */
  static showList(BuildContext context, String title, List<DialogItem> items, {Color iconcolor, double iconSize = _DefaultIconSize,
    double spaceing = _DefaultIconSpace, TextStyle textStyle})
  {
    show(context, title, DialogDemoItem.buildItems(items,
      iconcolor: iconcolor,
      iconSize: iconSize,
      spaceing: spaceing,
      textStyle: textStyle,
    ));
  }
}

/** 列表对话框列表项 (带图标) */
class DialogDemoItem extends StatelessWidget {
  const DialogDemoItem({
    Key key, this.icon, this.color, this.text, this.onPressed,
    this.iconSize = DialogEx._DefaultIconSize,
    this.spaceing = DialogEx._DefaultIconSpace,
    this.textStyle = null,
    this.clickPop = true,
  }) : super(key: key);

  final IconData icon;
  final Color color;
  final String text;
  final VoidCallback onPressed;
  final double iconSize, spaceing;
  final TextStyle textStyle;
  final bool clickPop;

  @override
  Widget build(BuildContext context) {
    return new SimpleDialogOption(
      onPressed: onPressed == null ? null : (clickPop ? () {
        Navigator.pop(context);
        onPressed();
      } : onPressed),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Icon(icon, size: iconSize, color: color),
          (spaceing > 0.0) ?
          new Padding(
            padding: new EdgeInsets.only(left: spaceing),
            child: new Text(text, style: textStyle),
          ) : new Text(text, style: textStyle),
        ],
      ),
    );
  }

  static List<Widget> buildItems(List<DialogItem> items, {Color iconcolor, double iconSize = DialogEx._DefaultIconSize, double spaceing = DialogEx._DefaultIconSpace, TextStyle textStyle}) {
    List<Widget> v = [];
    if (items != null && items.length > 0) {
      for (int i=0; i<items.length; i++) {
        if (items[i].isLine)
          v.add(new Divider());
        else
          v.add(new DialogDemoItem(
            icon: items[i].icon,
            text: items[i].text,
            onPressed: items[i].onTap,
            color: iconcolor,
            iconSize: iconSize,
            textStyle: textStyle,
            spaceing: spaceing,
        ));
      }
    }
    return v;
  }
}

class DialogItem {
  final String text;
  final IconData icon;
  final VoidCallback onTap;
  final bool isLine;
  const DialogItem({this.text, this.icon, this.onTap, this.isLine = false});
}

