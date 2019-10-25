import 'package:flutter/material.dart';
import 'dart:collection' show Queue;
import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;

/// 特效底部导航栏
class EffectBottomNavigationBar extends StatefulWidget {
  EffectBottomNavigationBar({
    Key key,
    this.items,
    this.body,
    this.currentIndex: 0,
    this.fixedColor,
    this.elevation,
    this.floatingActionButton,
    this.floatingActionButtonWidth = 56.0,
    this.floatingActionButtonIntoRatio = 1.72,
    this.floatingActionTopOffset = 0.0,
    this.iconSize: 24.0,
    this.deep = 1.0,
    this.backgroundColor,
    this.barColor,
    this.showTitles = true,
    this.onTap,
  }) : assert(items != null),
        assert(items.length >= 2),
        assert(0 <= currentIndex && currentIndex < items.length),
        assert(iconSize != null),
        super(key: key);

  /// The interactive items laid out within the bottom navigation bar.
  final List<BottomNavigationBarItem> items;

  final double elevation;
  final ValueChanged<int> onTap;
  final int currentIndex;
  final Color fixedColor;
  final double iconSize;

  /// 浮动按钮嵌入深度
  final double deep;

  /// 内容主体区域
  final Widget body;

  /// 浮动按钮
  final Widget floatingActionButton;
  /// 浮动按钮宽度
  final double floatingActionButtonWidth;
  /// 浮动按钮嵌入时的凹陷区域宽度相对于浮动按钮宽度的倍数
  final double floatingActionButtonIntoRatio;
  /// 浮动按钮Top偏移
  final double floatingActionTopOffset;

  /// 主体区域背景色
  final Color backgroundColor;

  /// 导航区域颜色
  final Color barColor;

  /// 是否显示标签
  final bool showTitles;

  @override
  _EffectBottomNavigationBarState createState() => new _EffectBottomNavigationBarState();
}

const double _kActiveFontSize = 12.0;
const double _kInactiveFontSize = 12.0;
const double _kTopMargin = 8.0;
const double _kBottomMargin = 8.0;
const double _kTopDeep = 30.0;

class _EffectBottomNavigationBarState extends State<EffectBottomNavigationBar> with TickerProviderStateMixin {
  // A queue of color splashes currently being animated.
  List<AnimationController> _controllers;
  List<CurvedAnimation> _animations;
  static final Tween<double> _flexTween = new Tween<double>(begin: 1.0, end: 1.5);

  double _evaluateFlex(Animation<double> animation) => _flexTween.evaluate(animation);

  Color _backgroundColor;

  @override
  void initState() {
    super.initState();
    _controllers = new List<AnimationController>.generate(widget.items.length, (int index) {
      return new AnimationController(
        duration: kThemeAnimationDuration,
        vsync: this,
      )..addListener(_rebuild);
    });
    _animations = new List<CurvedAnimation>.generate(widget.items.length, (int index) {
      return new CurvedAnimation(
          parent: _controllers[index],
          curve: Curves.fastOutSlowIn,
          reverseCurve: Curves.fastOutSlowIn.flipped
      );
    });
    _controllers[widget.currentIndex].value = 1.0;
    _backgroundColor = widget.items[widget.currentIndex].backgroundColor;
  }

  @override
  void dispose() {
    for (AnimationController controller in _controllers)
      controller.dispose();
    super.dispose();
  }

  void _rebuild() {
    setState(() {});
  }

  /// 绝对值
  double abs(double v) {
    if (v >= 0) return v;
    return -v;
  }

  double _additionalBottomPadding = 0.0;

  @override
  Widget build(BuildContext context) {
    _additionalBottomPadding = math.max(MediaQuery.of(context).padding.bottom - _kBottomMargin, 0.0);
    final xOffset = widget.items.length % 2 == 0 ? 0.0 : - (MediaQuery.of(context).size.width / widget.items.length / 2);

    return Stack(
      alignment: AlignmentDirectional.bottomEnd,
      children: <Widget>[
        Container(
          width: double.infinity,
          height: double.infinity,
          color:widget.backgroundColor,
          padding: EdgeInsets.only(bottom: kBottomNavigationBarHeight + _additionalBottomPadding),
          child: widget.body,
        ),
        buildItems(xOffset),
        widget.floatingActionButton == null ? Container() : buildFloatActionButton(abs(xOffset) * 2)
      ],
    );
  }

  Widget buildItems(double xOffset) {
    final minHeight = kBottomNavigationBarHeight + _additionalBottomPadding + _kTopDeep;
    final Color backgroundColor = widget.barColor ?? _backgroundColor; // Theme.of(context).bottomAppBarColor;

    return Container(
      constraints: new BoxConstraints(minHeight: minHeight),
      alignment: Alignment.bottomLeft,
      child: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            constraints: BoxConstraints(minHeight: minHeight),
            child: ClipPath(
              clipper: _BottomBgClipper(
                deep: widget.deep * _kTopDeep,
                top: _kTopDeep,
                width: widget.floatingActionButtonWidth * widget.floatingActionButtonIntoRatio,
                xOffset: xOffset,
              ),
              child: Material(
                color: backgroundColor,
                elevation: widget.elevation,
              ),
            )
          ),
          Material( // Splashes
            color: Colors.transparent,// .
            type: MaterialType.transparency,
            child: Padding(
              padding: EdgeInsets.only(bottom: _additionalBottomPadding, top: _kTopDeep),
              child: MediaQuery.removePadding(
                context: context,
                removeBottom: true,
                child: _createContainer(_createTiles()),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _createContainer(List<Widget> tiles) {
    return DefaultTextStyle.merge(
      overflow: TextOverflow.ellipsis,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: tiles,
      ),
    );
  }

  List<Widget> _createTiles() {
    final MaterialLocalizations localizations = MaterialLocalizations.of(context);
    assert(localizations != null);
    final List<Widget> children = <Widget>[];

    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;
    Color themeColor;
    switch (themeData.brightness) {
      case Brightness.light:
        themeColor = themeData.primaryColor;
        break;
      case Brightness.dark:
        themeColor = themeData.accentColor;
        break;
    }
    final ColorTween colorTween = new ColorTween(
      begin: textTheme.caption.color,
      end: widget.fixedColor ?? themeColor,
    );
    for (int i = 0; i < widget.items.length; i += 1) {
      children.add(
        _BottomNavigationTile(
          widget.items[i],
          _animations[i],
          widget.iconSize,
          showTitle: widget.showTitles,
          onTap: () {
            if (widget.onTap != null)
              widget.onTap(i);
          },
          colorTween: colorTween,
          selected: i == widget.currentIndex,
          indexLabel: localizations.tabLabel(tabIndex: i + 1, tabCount: widget.items.length),
        ),
      );
    }

    if (widget.floatingActionButton != null) {
      children.insert(children.length ~/ 2, buildFloatActionButtonPlaceholder());
    }

    return children;
  }


  @override
  void didUpdateWidget(EffectBottomNavigationBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentIndex != oldWidget.currentIndex) {
      _controllers[oldWidget.currentIndex].reverse();
      _controllers[widget.currentIndex].forward();
    }
  }

  double _topOffset() => (_kTopMargin + _kBottomMargin + widget.iconSize) * 0.75;

  // 插入一个占位符
  Widget buildFloatActionButtonPlaceholder() {
    return Container(
      width: widget.floatingActionButtonWidth,
      height: _kActiveFontSize,
    );
  }

  /// 将浮动按钮放入特定位置
  Widget buildFloatActionButton(double xOffset) {
    return Container(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        width: widget.floatingActionButtonWidth,
        child: widget.floatingActionButton,
      ),
      margin: EdgeInsets.only(bottom: _topOffset() + widget.floatingActionTopOffset, right: xOffset),
    );
  }

}

class _BottomNavigationTile extends StatelessWidget {
  const _BottomNavigationTile(
      this.item,
      this.animation,
      this.iconSize, {
        this.onTap,
        this.colorTween,
        this.flex,
        this.selected: false,
        this.showTitle: true,
        this.indexLabel,
      }
      ): assert(selected != null);

  final BottomNavigationBarItem item;
  final Animation<double> animation;
  final double iconSize;
  final VoidCallback onTap;
  final ColorTween colorTween;
  final double flex;
  final bool selected, showTitle;
  final String indexLabel;

  Widget _buildIcon() {
    double tweenStart;
    Color iconColor;
    tweenStart = 8.0;
    iconColor = colorTween.evaluate(animation);
    return new Align(
      alignment: Alignment.topCenter,
      heightFactor: 1.0,
      child: new Container(
        margin: new EdgeInsets.only(
          top: new Tween<double>(
            begin: tweenStart,
            end: _kTopMargin,
          ).evaluate(animation),
        ),
        child: new IconTheme(
          data: new IconThemeData(
            color: iconColor,
            size: iconSize,
          ),
          child: item.icon,
        ),
      ),
    );
  }

  Widget _buildFixedLabel() {
    return new Align(
      alignment: Alignment.bottomCenter,
      heightFactor: 1.0,
      child: new Container(
        margin: const EdgeInsets.only(bottom: _kBottomMargin),
        child: (item.title == null) ? null : DefaultTextStyle.merge(
          style: new TextStyle(
            fontSize: _kActiveFontSize,
            color: colorTween.evaluate(animation),
          ),
          // The font size should grow here when active, but because of the way
          // font rendering works, it doesn't grow smoothly if we just animate
          // the font size, so we use a transform instead.
          child: new Transform(
            transform: new Matrix4.diagonal3(
              new Vector3.all(
                new Tween<double>(
                  begin: _kInactiveFontSize / _kActiveFontSize,
                  end: 1.0,
                ).evaluate(animation),
              ),
            ),
            alignment: Alignment.bottomCenter,
            child: item.title,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Expanded(
      flex: 1,
      child: Semantics(
        container: true,
        selected: selected,
        child: new Stack(
          children: <Widget>[
            new InkResponse(
              onTap: onTap,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: showTitle ? <Widget>[
                  _buildIcon(),
                  _buildFixedLabel(),
                ] : [
                  SizedBox(height: 8.0),
                  _buildIcon(),
                  SizedBox(height: 8.0)
                ],
              ),
            ),
            Semantics(
              label: indexLabel,
            )
          ],
        ),
      ),
    );
  }

}

class _BottomBgClipper extends CustomClipper<Path> {
  const _BottomBgClipper({
    Listenable reclip,
    this.xOffset = 0.0,
    this.width = 95.0,
    this.deep = 33.0,
    this.smooth = 18.0,
    this.top = 0.0,
  }): super(reclip: reclip);

  final double width, xOffset;
  final double deep;
  final double smooth;
  final double top;

  @override
  Path getClip(Size size) {
    double x = (size.width - width) * 0.5 + xOffset;
    double y = deep + top;

    Path path = new Path();
    path.moveTo(0.0, top);
    path.lineTo(x - smooth, top);

    path.cubicTo(x + smooth, top, x + smooth, y, x + width * 0.5, y);
    path.cubicTo(x + width - smooth, y, x + width - smooth, top, x + width + smooth, top);

    path.lineTo(x + width + smooth, top);
    path.lineTo(size.width, top);
    path.lineTo(size.width, size.height);
    path.lineTo(0.0, size.height);
    path.lineTo(0.0, top);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}