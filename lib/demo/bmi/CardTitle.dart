import 'package:flutter/material.dart';

/// 选项卡标题Widget
class CardTitle extends StatelessWidget {
  CardTitle(this.title, {Key key, this.subtitle}) : super(key: key);

  final String title, subtitle;

  @override
  Widget build(BuildContext context) {
    if (subtitle == null)
      return Text(title, style: _titleStyle);
    return RichText(
      text: TextSpan(
        text: title,
        style: _titleStyle,
        children: <TextSpan>[
          TextSpan(
            text: subtitle ?? "",
            style: _subtitleStyle,
          )
        ]
      )
    );
  }
}

const TextStyle _titleStyle = TextStyle(
  fontSize: 16.0,
  fontWeight: FontWeight.w500,
  color: Color.fromRGBO(14, 24, 35, 1.0),
);

const TextStyle _subtitleStyle = TextStyle(
  fontSize: 8.0,
  fontWeight: FontWeight.w500,
  color: Color.fromRGBO(78, 102, 114, 1.0),
);