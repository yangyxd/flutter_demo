import 'package:flutter/material.dart';
import 'CardTitle.dart';
import 'Utils.dart';
import 'GenderCard.dart';
import 'WeightCard.dart';
import 'HeightCard.dart';
import 'Dot.dart';

class InputPage extends StatefulWidget {

  @override
  createState() => new _InputPageState();
}

class _InputPageState extends State<InputPage> with TickerProviderStateMixin {
  AnimationController _submitAnimationController;

  @override
  void initState() {
    _submitAnimationController = AnimationController(vsync: this, duration: Duration(seconds: 2));
    super.initState();
  }

  @override
  void dispose() {
    _submitAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.transparent,
      body: Padding(
          padding: MediaQuery.of(context).padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildTitle(context),
              Expanded(child: _buildCards(context)),
              _buildBottom(context),
            ],
          )
      ));
  }

  // 标题区域
  Widget _buildTitle(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 8.0,
        top: screenAwareSize(32.0, context),
      ),
      child: Row(
        children: <Widget>[
          SizedBox(width: 16.0),
          Text(
            "BMI Calculator",
            style: new TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // 底部内容
  Widget _buildBottom(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(left: 14.0, right: 14.0),
      height: screenAwareSize(108.0, context),
      width: double.infinity,
      child: PacmanSlider(
        submitAnimationController: _submitAnimationController,
        onSubmit: () {
          // 开始提交
          // 播放提交成功动画
          _submitAnimationController.forward();
        },
      ),
    );
  }

  Widget _buildCards(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 14.0,
        right: 14.0,
        top: screenAwareSize(32.0, context),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              children: <Widget>[
                Expanded(child: GenderCard()),
                Expanded(child: WeightCard()),
              ],
            ),
          ),
          Expanded(child: HeightCard())
        ],
      ),
    );
  }

  Widget _tempCard(String label) {
    return Card(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        child: Text(label),
      ),
    );
  }
}