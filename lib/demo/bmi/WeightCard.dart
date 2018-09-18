import 'package:flutter/material.dart';
import 'CardTitle.dart';
import 'Utils.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'WeightSlider.dart';

/// 体重卡片部件
class WeightCard extends StatefulWidget {
  final int initialWeight;

  WeightCard({Key key, this.initialWeight}): super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _WeightCardState();
  }
}

class _WeightCardState extends State<WeightCard> {
  int weight;

  @override
  void initState() {
    super.initState();
    weight = widget.initialWeight ?? 70;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.only(top: screenAwareSize(32.0, context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CardTitle("体重", subtitle: "(KG)"), // WEIGHT
            Expanded(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: _drawSlider(),
                ),
              ),
            )
          ],
        )
      ),
    );
  }

  Widget _drawSlider() {
    return WeightBackground(child: LayoutBuilder(
      builder: (context, constraints) {
        return constraints.isTight
            ? Container()
            : WeightSlider(
              minValue: 30,
              maxValue: 110,
              width: constraints.maxWidth,
              onChanged: (val) => setState(() => weight = val),
              value: weight,
            );
    }));
  }



}

/// 背景
class WeightBackground extends StatelessWidget {
  final Widget child;

  const WeightBackground({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        Container(
          height: screenAwareSize(100.0, context),
          decoration: BoxDecoration(
            color: Color.fromRGBO(244, 244, 244, 1.0),
            borderRadius: BorderRadius.circular(screenAwareSize(50.0, context))
          ),
          child: child,
        ),
        SvgPicture.asset(
          "assets/bmi/images/weight_arrow.svg",
          height: screenAwareSize(10.0, context),
          width: screenAwareSize(18.0, context),
          //color: Colors.red,
        ),
      ],
    );
  }
}