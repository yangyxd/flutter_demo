import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:math' as math;
import 'dart:async';
import 'Utils.dart';

/// 水平体重选择器小部件
class WeightSlider extends StatelessWidget {
  WeightSlider({
    Key key,
    @required this.minValue,
    @required this.maxValue,
    @required this.width,
    @required this.onChanged,
    this.value,
    this.columnCount = 3,
  }) : scrollController = new ScrollController(
    initialScrollOffset: (value - minValue) * width / columnCount,
  ), super(key: key);

  final int minValue;
  final int maxValue;
  final double width;
  final int columnCount;

  final int value;
  final ValueChanged<int> onChanged;
  final ScrollController scrollController;

  double get itemExtent => width / columnCount;
  int indexToValue(int index) => minValue + (index - 1);

  @override
  Widget build(BuildContext context) {
    int itemCount = (maxValue - minValue) + columnCount;
    return NotificationListener(
      onNotification: _onNotification,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        controller: scrollController,
        physics: BouncingScrollPhysics(),
        itemExtent: itemExtent,
        itemCount: itemCount,
        itemBuilder: (BuildContext context, int index) {
          final int itemValue = indexToValue(index);
          bool isExtra = index == 0 || index == itemCount - 1;

          return isExtra
            ? Container()
            : GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              _animateTo(itemValue, durationMillis: 60);  // 点击时，动画到当前值
            },
            child: FittedBox(
              child: Text("$itemValue", style: _getTextStyle(itemValue)),
              fit: BoxFit.scaleDown,
            ),
          );
        },
      ),
    );
  }

  TextStyle _getDefaultTextStyle() {
    return new TextStyle(
      color: Color.fromRGBO(196, 197, 203, 1.0),
      fontSize: 14.0,
    );
  }

  TextStyle _getHighlightTextStyle() {
    return new TextStyle(
      color: Color.fromRGBO(77, 123, 243, 1.0),
      fontSize: 28.0,
    );
  }

  TextStyle _getTextStyle(int itemValue) {
    return itemValue == value
        ? _getHighlightTextStyle()
        : _getDefaultTextStyle();
  }

  int _offsetToMiddleIndex(double offset) => (offset + width / 2) ~/ itemExtent;

  int _offsetToMiddleValue(double offset) {
    int indexOfMiddleElement = _offsetToMiddleIndex(offset);
    int middleValue = indexToValue(indexOfMiddleElement);
    middleValue = math.max(minValue, math.min(maxValue, middleValue));
    return middleValue;
  }

  bool isStop = true;

  timerEvent() {
    if (isStop) {
      if (_useTimerEvent()) {
        _animateTo(value, durationMillis: 80);
        print("timer animate.");
      }
      isStop = false;
    }
  }

  bool _useTimerEvent() {
    double targetExtent = (value - minValue) * itemExtent;
    return (scrollController.positions.isNotEmpty && abs(scrollController.position.pixels - targetExtent) > 0.0001);
  }

  bool _onNotification(Notification ntf) {
    if (ntf is ScrollNotification) {
      int middleValue = _offsetToMiddleValue(ntf.metrics.pixels);

      if(_userStoppedScrolling(ntf)) {
        _animateTo(middleValue);
        isStop = true;
      } else if (ntf is ScrollEndNotification) {
        // 快速点击和在滚动时点击，会有异常（当前值不会在中间），加一个定时器来纠正
        if (!isStop) isStop = true;
        if (isStop && _useTimerEvent())
          Timer(Duration(milliseconds: 300), timerEvent);
      } else if (ntf is ScrollStartNotification) {
        isStop = false;
      }

      if (middleValue != value) {
        if (onChanged != null)
          onChanged(middleValue); // update selection
      }
    }
    return true;
  }

  bool _userStoppedScrolling(Notification notification) {
    bool v = notification is UserScrollNotification &&
        notification.direction == ScrollDirection.idle &&
        scrollController.position.activity is! HoldScrollActivity;
    return v;
  }

  _animateTo(int valueToSelect, {int durationMillis = 200}) {
    double targetExtent = (valueToSelect - minValue) * itemExtent;
    scrollController.animateTo(
      targetExtent,
      duration: new Duration(milliseconds: durationMillis),
      curve: Curves.decelerate,
    );
  }
}