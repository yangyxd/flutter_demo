import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math' as math;
import 'Utils.dart';

// 小白圈
class Dot extends StatelessWidget {
  final double size;

  const Dot({Key key, @required this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var wh = screenAwareSize(size, context);
    return Container(
      height: wh,
      width: wh,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
    );
  }
}

// 吃小白圈的人图标
class PacmanIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        right: screenAwareSize(16.0, context),
      ),
      child: SvgPicture.asset('assets/bmi/images/pacman.svg',
          width: screenAwareSize(21.0, context),
          height: screenAwareSize(25.0, context)
      ),
    );
  }
}

// 吃小白圈的滑块
class PacmanSlider extends StatefulWidget{
  final VoidCallback onSubmit;
  final AnimationController submitAnimationController;

  const PacmanSlider({Key key, this.onSubmit, this.submitAnimationController}) : super(key: key);

  @override
  _PacmanSliderState createState() => _PacmanSliderState();
}

class _PacmanSliderState extends State<PacmanSlider> with TickerProviderStateMixin {
  Animation<BorderRadius> _bordersAnimation;
  double _pacmanPosition = _sliderHorizontalMargin;
  AnimationController pacmanMovementController;
  Animation<double> pacmanAnimation;

  Animation<double> _submitWidthAnimation;
  double get width => _submitWidthAnimation?.value ?? 0.0; //replace field with a getter

  @override
  void initState() {
    super.initState();
    pacmanMovementController = AnimationController(vsync: this, duration: Duration(milliseconds: 400));

    _bordersAnimation = BorderRadiusTween( //create BorderRadiusTween
      begin: BorderRadius.circular(8.0),
      end: BorderRadius.circular(50.0),
    ).animate(CurvedAnimation(
      parent: widget.submitAnimationController,
      curve: Interval(0.0, 0.07), //specify interval from 0 to 7%
    ));
  }

  @override
  void dispose() {
    pacmanMovementController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _submitWidthAnimation = Tween<double>(
          begin: constraints.maxWidth, //start with maximum width
          end: screenAwareSize(52.0, context), //finish with width equal to height
        ).animate(CurvedAnimation(
          parent: widget.submitAnimationController, //use the same animation controller...
          curve: Interval(0.05, 0.25), //... but in different time frame from border animation
        ));

        return AnimatedBuilder(
          animation: widget.submitAnimationController,
          builder: (context, child) {

            Decoration decoration = BoxDecoration(
              borderRadius: _bordersAnimation.value,
              color: Theme.of(context).primaryColor,
            );

            var body = Container(
              height: screenAwareSize(52.0, context),
              width: width, // double.infinity,
              decoration: decoration,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: screenAwareSize(24.0, context)
                ),
                child: _submitWidthAnimation.isDismissed ? LayoutBuilder(builder: (context, constraints) {
                  return Stack(
                    alignment: Alignment.centerLeft,
                    children: <Widget>[
                      AnimatedDots(),
                      _drawDotCurtain(decoration, width: constraints.maxWidth),
                      _drawPacman(width: constraints.maxWidth),
                    ],
                  );
                }) : Container(),
              ),
            );

            return Center(
              child: InkWell(
                child: body,
                onTap: !_submitWidthAnimation.isDismissed ? () {
                  setState(() {
                    widget.submitAnimationController.reset();
                    _resetPacman();
                  });
                } : null,
              ),
            );

          }
        );
      },
    );
  }

  /// 绘制遮罩层，遮住被吃掉的小白圈
  Widget _drawDotCurtain(Decoration decoration, {double width}) {
    if (width <= 0.0) return Container();
    return Container(
      width: _pacmanPosition + screenAwareSize(_pacmanWidth * 0.5, context),
      decoration: decoration,
    );
    return Positioned.fill(
      right: width - _pacmanPosition - screenAwareSize(_pacmanWidth / 2, context),
      child: Container(decoration: decoration),
    );
  }

  /// 绘制吃圆点的人图标
  Widget _drawPacman({double width}) {
    if (pacmanAnimation == null && width != 0.0) {
      pacmanAnimation = _initPacmanAnimation(width);
    }
    return Positioned(
      left: _pacmanPosition,
      child: GestureDetector(
        //onHorizontalDragUpdate: (details) => _onPacmanDrag(width, details),
        onHorizontalDragUpdate: (details) => _onPacmanDrag(width, details),
        onHorizontalDragEnd: (details) => _onPacmanEnd(width, details),
        child: PacmanIcon(),
      ),
    );
  }

  // 吃圆点的人图标拖动处理
  _onPacmanDrag(double width, DragUpdateDetails details) {
    setState(() {
      _pacmanPosition += details.delta.dx;
      _pacmanPosition = math.max(_pacmanMinPosition(),
          math.min(_pacmanMaxPosition(width), _pacmanPosition));
    });
  }

  // 拖动结束时，如果吃圈图标没有过半，则返回开始位置，否则动画到最后之处
  _onPacmanEnd(double width, DragEndDetails details) {
    bool isOverHalf = _pacmanPosition + screenAwareSize(_pacmanWidth / 2, context) > 0.5 * width;
    if (isOverHalf) {
      pacmanMovementController.forward(from: _pacmanPosition / _pacmanMaxPosition(width)); // 动画到结束处
    } else {
      _resetPacman();
    }
  }

  // 重置吃圈图标位置
  _resetPacman() {
    setState(() => _pacmanPosition = _pacmanMinPosition());
  }

  // 初始化吃圈图标的动画控制器
  Animation<double> _initPacmanAnimation(double width) {
    Animation<double> animation = Tween(
      begin: _pacmanMinPosition(),
      end: _pacmanMaxPosition(width),
    ).animate(pacmanMovementController);

    animation.addListener(() {
      setState(() {
        _pacmanPosition = animation.value;
      });
      if (animation.status == AnimationStatus.completed) {
        // 动画完成时
        _onPacmanSubmited();
      }
    });
    return animation;
  }

  _onPacmanSubmited() {
    // 动画完成时，延时复位到开始处
    if (widget.onSubmit == null)
      Future.delayed(Duration(seconds: 1), () => _resetPacman());
    else
      widget.onSubmit();
  }

  double _pacmanMinPosition() => screenAwareSize(_sliderHorizontalMargin, context);

  double _pacmanMaxPosition(double sliderWidth) => sliderWidth - screenAwareSize(_sliderHorizontalMargin / 2 + _pacmanWidth, context);
}

const double _pacmanWidth = 21.0;
const double _sliderHorizontalMargin = 8.0;
const double _dotsLeftMargin = 8.0;

class AnimatedDots extends StatefulWidget {
  @override
  _AnimatedDotsState createState() => _AnimatedDotsState();
}

class _AnimatedDotsState extends State<AnimatedDots> with TickerProviderStateMixin {
  final int numberOfDots = 10;
  final double minOpacity = 0.1;
  final double maxOpacity = 0.5;
  AnimationController hintAnimationController;

  @override
  void initState() {
    super.initState();
    _initHintAnimationController();
    hintAnimationController.forward();
  }

  @override
  void dispose() {
    hintAnimationController.dispose();
    super.dispose();
  }

  void _initHintAnimationController() {
    hintAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    hintAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(Duration(milliseconds: 800), () {
          if (this.mounted) {
            hintAnimationController.forward(from: 0.0);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: screenAwareSize(_sliderHorizontalMargin + _pacmanWidth + _dotsLeftMargin, context),
          right: screenAwareSize(_sliderHorizontalMargin, context)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(numberOfDots, _generateDot)
          ..add(Opacity(
            opacity: maxOpacity,
            child: Dot(size: 14.0),
          )),
      ),
    );
  }

  Widget _generateDot(int dotNumber) {
    Animation animation = _initDotAnimation(dotNumber);
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) => Opacity(
        opacity: animation.value,
        child: child,
      ),
      child: Dot(size: 9.0),
    );
  }

  Animation<double> _initDotAnimation(int dotNumber) {
    double lastDotStartTime = 0.4;
    double dotAnimationDuration = 0.5;
    double begin = lastDotStartTime * dotNumber / numberOfDots;
    double end = begin + dotAnimationDuration;
    //    return SinusoidalTween(min: minOpacity, max: maxOpacity).animate(
//        CurvedAnimation(
//          parent: hintAnimationController,
//          curve: Interval(begin, end),
//        ),
//    );

    return SinusoidalAnimation(min: minOpacity, max: maxOpacity).animate(
      CurvedAnimation(
        parent: hintAnimationController,
        curve: Interval(begin, end),
      ),
    );
    // 使用Tween来指定动画的开始和结束值
    return Tween(begin: minOpacity, end: maxOpacity).animate(
      // 使用曲线动画
//      CurvedAnimation(
//        parent: hintAnimationController,
//        curve: Interval(begin, end),
//      ),
      ReverseAnimation(hintAnimationController),
    );
  }
}

/// 正弦动画
/// 实现从最小值到最大值的动画效果
class SinusoidalAnimation extends Animatable<double> {
  SinusoidalAnimation({this.min, this.max});

  final double min;
  final double max;

  @override
  double transform(double t) {
    return min + (max - min) * math.sin(math.pi * t);
  }
}

class SinusoidalTween extends Tween<double> {
  SinusoidalTween({ double min, double max }) : super(begin: min, end: max);

  @override
  double lerp(double t) => begin + (end - begin) * math.sin(math.pi * t);
}