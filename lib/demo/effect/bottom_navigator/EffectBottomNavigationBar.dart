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
    this.showSelectedLabels = true,
    this.showUnselectedLabels = false,
    this.selectedFontSize = 14.0,
    this.unselectedFontSize = 12.0,
    this.selectedLabelStyle,
    this.unselectedLabelStyle,
    this.selectedIconTheme = const IconThemeData(),
    this.unselectedIconTheme = const IconThemeData(),
    this.popupButton,
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
  final bool showSelectedLabels;
  final bool showUnselectedLabels;

  final double selectedFontSize;
  final double unselectedFontSize;
  final TextStyle selectedLabelStyle;
  final TextStyle unselectedLabelStyle;

  final IconThemeData selectedIconTheme;
  final IconThemeData unselectedIconTheme;

  /// 弹出活动按钮列表
  final BottomNavigationBarPopupActionList popupButton;

  @override
  _EffectBottomNavigationBarState createState() => new _EffectBottomNavigationBarState();
}

const double _kActiveFontSize = 12.0;
const double _kInactiveFontSize = 12.0;
const double _kTopMargin = 8.0;
const double _kBottomMargin = 8.0;
const double _kTopDeep = 30.0;

/// 底部导航栏弹出活动按钮列表
class BottomNavigationBarPopupActionList {
  const BottomNavigationBarPopupActionList({
    this.children,
    this.iconSize = 24.0,
    this.floatingActionButtonIcon = const Icon(Icons.add),
    this.floatingActionCloseButtonIcon = const Icon(Icons.close)
  });
  final List<BottomNavigationBarPopupActionItem> children;
  final double iconSize;
  final Icon floatingActionButtonIcon;
  final Icon floatingActionCloseButtonIcon;
}

class BottomNavigationBarPopupActionItem {
  const BottomNavigationBarPopupActionItem({
    this.icon, this.title, this.onTap,
  });
  final Widget icon;
  final String title;
  final VoidCallback onTap;
}

class _EffectBottomNavigationBarState extends State<EffectBottomNavigationBar> with TickerProviderStateMixin {
  // A queue of color splashes currently being animated.
  List<AnimationController> _controllers = <AnimationController>[];
  List<CurvedAnimation> _animations;

  CurvedAnimation _popupAnimation;
  Animation<double> _popupAnim;

  static final Tween<double> _flexTween = new Tween<double>(begin: 1.0, end: 1.5);

  double _evaluateFlex(Animation<double> animation) => _flexTween.evaluate(animation);

  Color _backgroundColor;
  double _additionalBottomPadding = 0.0;
  Widget _floatingActionButton;
  bool _isPopup = false;

  void _resetState() {
    for (AnimationController controller in _controllers)
      controller.dispose();
    _controllers = List<AnimationController>.generate(widget.items.length, (int index) {
      return AnimationController(
        duration: kThemeAnimationDuration,
        vsync: this,
      )..addListener(_rebuild);
    });
    _animations = List<CurvedAnimation>.generate(widget.items.length, (int index) {
      return CurvedAnimation(
        parent: _controllers[index],
        curve: Curves.fastOutSlowIn,
        reverseCurve: Curves.fastOutSlowIn.flipped,
      );
    });

    _controllers.add(
        AnimationController(
          duration: kThemeAnimationDuration,
          vsync: this,
        )..addListener(_popoupAnimation)
    );
    _popupAnimation = CurvedAnimation(
      parent: _controllers.last,
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.fastOutSlowIn.flipped,
    );
    _popupAnim = Tween<double>(
      begin:  0.0,
      end: 1.0,
    ).animate(_popupAnimation);

    _controllers[widget.currentIndex].value = 1.0;
    _backgroundColor = widget.items[widget.currentIndex].backgroundColor;
  }

  @override
  void initState() {
    super.initState();
    _resetState();
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

  void _popoupAnimation() {
    setState(() {});
  }

  /// 绝对值
  double abs(double v) {
    if (v >= 0) return v;
    return -v;
  }

  Widget _buildPopupFloatingActionButton() {
    return FloatingActionButton(child: widget.popupButton.floatingActionButtonIcon, onPressed: (){
      if (_isPopup) {
        _controllers.last.reverse();
      } else
        _controllers.last.forward();
      _isPopup = !_isPopup;
    });
  }

  @override
  Widget build(BuildContext context) {
    _additionalBottomPadding = math.max(MediaQuery.of(context).padding.bottom - _kBottomMargin, 0.0);
    final xOffset = widget.items.length % 2 == 0 ? 0.0 : - (MediaQuery.of(context).size.width / widget.items.length / 2);
    _floatingActionButton = widget.floatingActionButton != null ? widget.floatingActionButton : widget.popupButton == null ? null : _buildPopupFloatingActionButton();

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
        _floatingActionButton == null ? Container() : buildFloatActionButton(abs(xOffset) * 2)
      ],
    );
  }

  Widget buildItems(double xOffset) {
    final _topDeep = (_floatingActionButton == null ? 0.0 : _kTopDeep);
    final minHeight = kBottomNavigationBarHeight + _additionalBottomPadding + _topDeep;
    final backgroundColor = widget.barColor ?? _backgroundColor; // Theme.of(context).bottomAppBarColor;
    final _bg = Material(
      color: backgroundColor,
      elevation: widget.elevation,
    );
    return Container(
      constraints: new BoxConstraints(minHeight: minHeight),
      alignment: Alignment.bottomLeft,
      child: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            constraints: BoxConstraints(minHeight: minHeight),
            child: _floatingActionButton == null ? _bg :  ClipPath(
              clipper: _BottomBgClipper(
                deep: widget.deep * _kTopDeep,
                top: _kTopDeep,
                width: widget.floatingActionButtonWidth * widget.floatingActionButtonIntoRatio,
                xOffset: xOffset,
              ),
              child: _bg,
            )
          ),
          Material( // Splashes
            color: Colors.transparent,// .
            type: MaterialType.transparency,
            child: Padding(
              padding: EdgeInsets.only(bottom: _additionalBottomPadding, top: _topDeep),
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

  static TextStyle _effectiveTextStyle(TextStyle textStyle, double fontSize) {
    textStyle ??= const TextStyle();
    // Prefer the font size on textStyle if present.
    return textStyle.fontSize == null ? textStyle.copyWith(fontSize: fontSize) : textStyle;
  }

  List<Widget> _createTiles() {
    final MaterialLocalizations localizations = MaterialLocalizations.of(context);
    assert(localizations != null);

    final ThemeData themeData = Theme.of(context);

    final TextStyle effectiveSelectedLabelStyle =
    _effectiveTextStyle(widget.selectedLabelStyle, widget.selectedFontSize);
    final TextStyle effectiveUnselectedLabelStyle =
    _effectiveTextStyle(widget.unselectedLabelStyle, widget.unselectedFontSize);

    Color themeColor;
    switch (themeData.brightness) {
      case Brightness.light:
        themeColor = themeData.primaryColor;
        break;
      case Brightness.dark:
        themeColor = themeData.accentColor;
        break;
    }

    final ColorTween colorTween =  ColorTween(
      begin: themeData.textTheme.caption.color,
      end: widget.fixedColor ?? themeColor,
    );

    final List<Widget> children = <Widget>[];
    for (int i = 0; i < widget.items.length; i += 1) {
      children.add(
        _BottomNavigationTile(
          widget.items[i],
          _animations[i],
          widget.iconSize,
          showSelectedLabels: widget.showSelectedLabels,
          showUnselectedLabels: widget.showUnselectedLabels,
          selectedLabelStyle: effectiveSelectedLabelStyle,
          unselectedLabelStyle: effectiveUnselectedLabelStyle,
          selectedIconTheme: widget.selectedIconTheme,
          unselectedIconTheme: widget.unselectedIconTheme,
          onTap: () {
            if (widget.onTap != null)
              widget.onTap(i);
          },
          colorTween: colorTween,
          flex: _evaluateFlex(_animations[i]),
          selected: i == widget.currentIndex,
          indexLabel: localizations.tabLabel(tabIndex: i + 1, tabCount: widget.items.length),
        ),
      );
    }

    if (_floatingActionButton != null) {
      children.insert(children.length ~/ 2, buildFloatActionButtonPlaceholder());
    }

    return children;
  }


  @override
  void didUpdateWidget(EffectBottomNavigationBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.items.length != oldWidget.items.length) {
      _resetState();
      return;
    }
    if (widget.currentIndex != oldWidget.currentIndex) {
      _controllers[oldWidget.currentIndex].reverse();
      _controllers[widget.currentIndex].forward();
    } else {
      if (_backgroundColor != widget.items[widget.currentIndex].backgroundColor)
        _backgroundColor = widget.items[widget.currentIndex].backgroundColor;
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
        child: AnimatedBuilder(
          animation: _popupAnim,
          builder: (context, _) {
            return Transform.rotate(
              child: _floatingActionButton,
              angle: _popupAnim.value * 0.8,
            );
          },
        ),
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
        this.showSelectedLabels: true,
        this.showUnselectedLabels,
        this.selectedLabelStyle,
        this.unselectedLabelStyle,
        this.selectedIconTheme,
        this.unselectedIconTheme,
        this.indexLabel,
      }
      ): assert(selected != null);

  final BottomNavigationBarItem item;
  final Animation<double> animation;
  final double iconSize;
  final VoidCallback onTap;
  final ColorTween colorTween;
  final double flex;
  final bool selected;
  final IconThemeData selectedIconTheme;
  final IconThemeData unselectedIconTheme;
  final bool showSelectedLabels;
  final bool showUnselectedLabels;
  final TextStyle selectedLabelStyle;
  final TextStyle unselectedLabelStyle;
  final String indexLabel;

  @override
  Widget build(BuildContext context) {
    final double selectedIconSize = iconSize;
    final double unselectedIconSize = iconSize;
    final double selectedFontSize = selectedLabelStyle.fontSize;
    final double selectedIconDiff = math.max(selectedIconSize - unselectedIconSize, 0);
    final double unselectedIconDiff = math.max(unselectedIconSize - selectedIconSize, 0);

    double bottomPadding;
    double topPadding;

    if (showSelectedLabels && !showUnselectedLabels) {
      bottomPadding = Tween<double>(
        begin: selectedIconDiff / 2.0,
        end: selectedFontSize / 2.0 - unselectedIconDiff / 2.0,
      ).evaluate(animation);
      topPadding = Tween<double>(
        begin: selectedFontSize + selectedIconDiff / 2.0,
        end: selectedFontSize / 2.0 - unselectedIconDiff / 2.0,
      ).evaluate(animation);
    } else if (!showSelectedLabels && !showUnselectedLabels) {
      bottomPadding = Tween<double>(
        begin: selectedIconDiff / 2.0,
        end: unselectedIconDiff / 2.0,
      ).evaluate(animation);
      topPadding = Tween<double>(
        begin: selectedFontSize + selectedIconDiff / 2.0,
        end: selectedFontSize + unselectedIconDiff / 2.0,
      ).evaluate(animation);
    } else {
      bottomPadding = Tween<double>(
        begin: selectedFontSize / 2.0 + selectedIconDiff / 2.0,
        end: selectedFontSize / 2.0 + unselectedIconDiff / 2.0,
      ).evaluate(animation);
      topPadding = Tween<double>(
        begin: selectedFontSize / 2.0 + selectedIconDiff / 2.0,
        end: selectedFontSize / 2.0 + unselectedIconDiff / 2.0,
      ).evaluate(animation);
    }

    return Expanded(
      flex: 1,
      child: Semantics(
        container: true,
        selected: selected,
        child: Focus(
          child: Stack(
            children: <Widget>[
              InkResponse(
                onTap: onTap,
                child: Padding(
                  padding: EdgeInsets.only(top: topPadding, bottom: bottomPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      _TileIcon(
                        colorTween: colorTween,
                        animation: animation,
                        iconSize: iconSize,
                        selected: selected,
                        item: item,
                        selectedIconTheme: selectedIconTheme,
                        unselectedIconTheme: unselectedIconTheme,
                      ),
                      _Label(
                        colorTween: colorTween,
                        animation: animation,
                        item: item,
                        selectedLabelStyle: selectedLabelStyle,
                        unselectedLabelStyle: unselectedLabelStyle,
                        showSelectedLabels: showSelectedLabels,
                        showUnselectedLabels: showUnselectedLabels,
                      ),
                    ],
                  ),
                ),
              ),
              Semantics(
                label: indexLabel,
              ),
            ],
          ),
        ),
      ),
    );
  }

}

class _TileIcon extends StatelessWidget {
  const _TileIcon({
    Key key,
    @required this.colorTween,
    @required this.animation,
    @required this.iconSize,
    @required this.selected,
    @required this.item,
    @required this.selectedIconTheme,
    @required this.unselectedIconTheme,
  }) : assert(selected != null),
        assert(item != null),
        super(key: key);

  final ColorTween colorTween;
  final Animation<double> animation;
  final double iconSize;
  final bool selected;
  final BottomNavigationBarItem item;
  final IconThemeData selectedIconTheme;
  final IconThemeData unselectedIconTheme;

  @override
  Widget build(BuildContext context) {
    final Color iconColor = colorTween.evaluate(animation);
    final IconThemeData defaultIconTheme = IconThemeData(
      color: iconColor,
      size: iconSize,
    );
    final IconThemeData iconThemeData = IconThemeData.lerp(
      defaultIconTheme.merge(unselectedIconTheme),
      defaultIconTheme.merge(selectedIconTheme),
      animation.value,
    );

    return Align(
      alignment: Alignment.topCenter,
      heightFactor: 1.0,
      child: Container(
        child: IconTheme(
          data: iconThemeData,
          child: selected ? item.activeIcon : item.icon,
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label({
    Key key,
    @required this.colorTween,
    @required this.animation,
    @required this.item,
    @required this.selectedLabelStyle,
    @required this.unselectedLabelStyle,
    @required this.showSelectedLabels,
    @required this.showUnselectedLabels,
  }) : assert(colorTween != null),
        assert(animation != null),
        assert(item != null),
        assert(selectedLabelStyle != null),
        assert(unselectedLabelStyle != null),
        assert(showSelectedLabels != null),
        assert(showUnselectedLabels != null),
        super(key: key);

  final ColorTween colorTween;
  final Animation<double> animation;
  final BottomNavigationBarItem item;
  final TextStyle selectedLabelStyle;
  final TextStyle unselectedLabelStyle;
  final bool showSelectedLabels;
  final bool showUnselectedLabels;

  @override
  Widget build(BuildContext context) {
    final double selectedFontSize = selectedLabelStyle.fontSize;
    final double unselectedFontSize = unselectedLabelStyle.fontSize;

    final TextStyle customStyle = TextStyle.lerp(
      unselectedLabelStyle,
      selectedLabelStyle,
      animation.value,
    );
    Widget text = DefaultTextStyle.merge(
      style: customStyle.copyWith(
        fontSize: selectedFontSize,
        color: colorTween.evaluate(animation),
      ),
      // The font size should grow here when active, but because of the way
      // font rendering works, it doesn't grow smoothly if we just animate
      // the font size, so we use a transform instead.
      child: Transform(
        transform: Matrix4.diagonal3(
          Vector3.all(
            Tween<double>(
              begin: unselectedFontSize / selectedFontSize,
              end: 1.0,
            ).evaluate(animation),
          ),
        ),
        alignment: Alignment.bottomCenter,
        child: item.title,
      ),
    );

    if (!showUnselectedLabels && !showSelectedLabels) {
      // Never show any labels.
      text = Opacity(
        alwaysIncludeSemantics: true,
        opacity: 0.0,
        child: text,
      );
    } else if (!showUnselectedLabels) {
      // Fade selected labels in.
      text = FadeTransition(
        alwaysIncludeSemantics: true,
        opacity: animation,
        child: text,
      );
    } else if (!showSelectedLabels) {
      // Fade selected labels out.
      text = FadeTransition(
        alwaysIncludeSemantics: true,
        opacity: Tween<double>(begin: 1.0, end: 0.0).animate(animation),
        child: text,
      );
    }

    return Align(
      alignment: Alignment.bottomCenter,
      heightFactor: 1.0,
      child: Container(child: text),
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