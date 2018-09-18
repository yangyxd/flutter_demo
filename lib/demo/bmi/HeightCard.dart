import 'package:flutter/material.dart';
import 'CardTitle.dart';
import 'Utils.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math' as math;

/// 身高卡片部件
class HeightCard extends StatefulWidget {
  final int height;
  const HeightCard({Key key, this.height}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HeightCardState();
  }
}

class _HeightCardState extends State<HeightCard> {
  int height;

  @override
  void initState() {
    super.initState();
    height = widget.height ?? 170;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.only(top: screenAwareSize(8.0, context)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CardTitle("身高", subtitle: "(CM)"),  // GEN
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: screenAwareSize(8.0, context)),
                  child: LayoutBuilder(builder: (context, constraints) {
                    return HeightPicker(
                      widgetHeight: constraints.maxHeight,
                      height: height,
                      onChange: (val) => setState(() {
                        height = val;
                      })
                    );
                  }),
                ),
              )// DER
            ],
          ),
        ),
      ),
    );
  }

}

/// 高度选择器
class HeightPicker extends StatefulWidget {
  final double widgetHeight;
  final int height, maxHeight, minHeight;
  final ValueChanged<int> onChange;

  const HeightPicker({Key key, this.height, this.widgetHeight, this.onChange, this.maxHeight = 190, this.minHeight = 145}): super(key: key);

  /// 总单位
  int get totalUnits => maxHeight - minHeight;

  @override
  State<StatefulWidget> createState() {
    return _HeightPickerState();
  }
}

class _HeightPickerState extends State<HeightPicker> {
  /// 返回一个单位是多少像素
  double get _pixelsPerUnit {
    return _drawingHeight / widget.totalUnits;
  }

  /// 返回滑块位置
  double get _sliderPosition {
    double halfOfBottomLabel = labelsFontSize / 2;
    int unitsFromBottom = widget.height - widget.minHeight;
    return halfOfBottomLabel + unitsFromBottom * _pixelsPerUnit;
  }

  /// 返回滑块的实际高度，以便能够滑动
  double get _drawingHeight {
    double totalHeight = widget.widgetHeight;
    double marginBottom = marginBottomAdapted(context);
    double marginTop = marginTopAdapted(context);
    return totalHeight - (marginBottom + marginTop + labelsFontSize);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTapDown: _onTapDown,
      onVerticalDragStart: _onDragStart,
      onVerticalDragUpdate: _onDragUpdate,
      child: Stack(
        children: <Widget>[
          _drawPersonImage(),
          _drawLabels(),
          _drawSlider(),
        ],
      ),
    );
  }

  /// 画刻度标签
  Widget _drawLabels() {
    int labelsToDisplay = widget.totalUnits ~/ 5 + 1;
    List<Widget> labels = List.generate(labelsToDisplay, (index) {
      return Text("${widget.maxHeight - 5 * index}", style: labelsTextStyle);
    });

    return Align(
      alignment: Alignment.centerRight,  // 靠右显示
      child: IgnorePointer( // 忽略所有手势
        child: Padding(
          padding: EdgeInsets.only(
            right: screenAwareSize(12.0, context),
            bottom: marginBottomAdapted(context),
            top: marginBottomAdapted(context),
          ),
          child: Column(
            children: labels,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,  // 内部相同间隔分布
          ),
        ),
      ),
    );
  }

  /// 画控制器
  Widget _drawSlider() {
    return Positioned(
      child: HeightSlider(height: widget.height),
      left: 2.0,
      right: 0.0,
      bottom: _sliderPosition,
    );
  }

  /// 画模拟人像
  Widget _drawPersonImage() {
    double personImageHeight = _sliderPosition + marginBottomAdapted(context);
    return Align(
      alignment: Alignment.bottomCenter,
      child: SvgPicture.asset(
        "assets/bmi/images/person.svg",
        height: personImageHeight,
        width: personImageHeight / 3,
      ),
    );
  }

  /// 按下事件
  _onTapDown(TapDownDetails v) {
    int h = _globalOffsetToHeight(v.globalPosition);
    widget.onChange(_normalizeHeight(h));
  }

  // 对值进行检测，确保在最大和最小之间
  int _normalizeHeight(int height) {
    return math.max(widget.minHeight, math.min(widget.maxHeight, height));
  }

  // 将手势的全局位置转为上下文的高度
  int _globalOffsetToHeight(Offset globalOffset) {
    RenderBox getBox = context.findRenderObject();
    Offset localPosition = getBox.globalToLocal(globalOffset);
    double dy = localPosition.dy;
    dy = dy - marginTopAdapted(context) - labelsFontSize / 2;
    int height = widget.maxHeight - (dy ~/ _pixelsPerUnit);
    return height;
  }

  double startDragYOffset;
  int startDragHeight;

  /// 拖动控制器处理
  _onDragStart(DragStartDetails dragStartDetails) {
    // 开始拖动时，我们就更新高度并保存开始的高度和偏移值，这样当拖动更新时，我
    // 们需要做的就是检查在开始时保存的偏移与更新偏移量之间的差异，然后通过
    // onChange方法计算新的高度和更新
    int newHeight = _globalOffsetToHeight(dragStartDetails.globalPosition);
    widget.onChange(newHeight);
    setState(() {
      startDragYOffset = dragStartDetails.globalPosition.dy;
      startDragHeight = newHeight;
    });
  }

  /// 拖动更新
  _onDragUpdate(DragUpdateDetails dragUpdateDetails) {
    double currentYOffset = dragUpdateDetails.globalPosition.dy;
    double verticalDifference = startDragYOffset - currentYOffset;
    int diffHeight = verticalDifference ~/ _pixelsPerUnit;
    int height = _normalizeHeight(startDragHeight + diffHeight);
    setState(() => widget.onChange(height));
  }
}

/// 控制器
class HeightSlider extends StatelessWidget {
  final int height;

  const HeightSlider({Key key, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SliderLabel(height: height),
          Row(
            children: <Widget>[
              SliderCircle(),
              Expanded(child: SliderLine()),
            ],
          ),
        ],
      ),
    );
  }
}

/// 控制器标签
class SliderLabel extends StatelessWidget {
  final int height;

  const SliderLabel({Key key, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: screenAwareSize(4.0, context),
        bottom: screenAwareSize(2.0, context),
      ),
      child: Text(
        "$height",
        style: TextStyle(
          fontSize: selectedLabelFontSize,
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// 控制线
class SliderLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: List.generate(
          40, (i) => Expanded(
            child: Container(
              height: 1.0,
              decoration: BoxDecoration(
                  color: i.isEven
                      ? Theme.of(context).primaryColor
                      : Colors.transparent),
            ),
          )),
    );
  }
}

/// 控制圆
class SliderCircle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: circleSizeAdapted(context),
      height: circleSizeAdapted(context),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.unfold_more,
        color: Colors.white,
        size: 0.6 * circleSizeAdapted(context),
      ),
    );
  }
}

