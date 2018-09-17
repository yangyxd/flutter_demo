import 'package:flutter/material.dart';
import 'CardTitle.dart';
import 'Utils.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GenderCard extends StatefulWidget {
  final Gender initalGender;
  const GenderCard({Key key, this.initalGender}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _GenderCardState();
  }
}

class _GenderCardState extends State<GenderCard> with SingleTickerProviderStateMixin {
  AnimationController _arrowAnimationController;
  Gender selectedGender;

  @override
  void initState() {
    selectedGender = widget.initalGender ?? Gender.other; //<--- initialize selected gender

    // 动画控制器
    _arrowAnimationController = new AnimationController( //<--- initialize animation controller
      vsync: this,
      lowerBound: -defaultGenderAngle,
      upperBound: defaultGenderAngle,
      value: genderAngles[selectedGender],
    );

    super.initState();
  }

  @override
  void dispose() {
    _arrowAnimationController.dispose(); //<--- dispose controller when we're done
    super.dispose();
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
              CardTitle("性别: ${genderName[selectedGender]}"),  // GENDER
              Padding(
                padding: EdgeInsets.only(top: screenAwareSize(16.0, context)),
                child: _drawMainStack(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 绘制性别图标和背景
  Widget _drawMainStack() {
    return Container(
      width: double.infinity,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          _drawCircleIndicator(),
          GenderIconTranslated(gender: Gender.female),
          GenderIconTranslated(gender: Gender.other),
          GenderIconTranslated(gender: Gender.male),
          _drawGestureDetector(), // 手势识别层
        ],
      ),
    );
  }

  // 绘制背景和指针
  Widget _drawCircleIndicator() {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        GenderCircle(), // 圆形底图
        //GenderArrow(angle: genderAngles[selectedGender]),
        GenderArrow(listenable: _arrowAnimationController), // 使用动画控制器来控制角度
      ],
    );
  }

  // 手执识别层
  _drawGestureDetector() {
    return Positioned.fill(
      child: TapHandler(
//        onGenderTapped: (gender) => setState(() {
//          selectedGender = gender;
//          // print("$selectedGender");
//        }),
          onGenderTapped: _setSelectedGender, // 使用动画控制器来改变性别
      ),
    );
  }

  // 通过动画控制器来更改性别
  void _setSelectedGender(Gender gender) {
    setState(() {
      selectedGender = gender;
    });
    _arrowAnimationController.animateTo(
      genderAngles[gender],
      duration: Duration(milliseconds: 150),
    );
  }
}

/// 产生一个圆形
class GenderCircle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: circleSize(context),
      height: circleSize(context),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color.fromRGBO(244, 244, 244, 1.0),
      ),
    );
  }
}

/// 一条线
class GenderLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: screenAwareSize(6.0, context),
        top: screenAwareSize(8.0, context),
      ),
      child: Container(
        height: screenAwareSize(8.0, context),
        width: 1.0,
        color: Color.fromRGBO(216, 217, 223, 0.54),
      ),
    );
  }
}

/// 性别图标
class GenderIconTranslated extends StatelessWidget {

  static final Map<Gender, String> _genderImages = {
    Gender.female: "assets/bmi/images/gender_female.svg",
    Gender.other: "assets/bmi/images/gender_other.svg",
    Gender.male: "assets/bmi/images/gender_male.svg",
  };

  final Gender gender;

  const GenderIconTranslated({Key key, this.gender}) : super(key: key);

  // 是否为其它性别
  bool get isOtherGender => this.gender == Gender.other;
  // 图标资源名称
  String get assetName => _genderImages[this.gender];

  double _iconSize(BuildContext context) {
    return screenAwareSize(isOtherGender ? 22.0 : 16.0, context);
  }

  @override
  Widget build(BuildContext context) {
    Widget icon = Padding(
      padding: EdgeInsets.only(left: screenAwareSize(isOtherGender ? 8.0 : 0.0, context)),
      child: SvgPicture.asset(
        assetName,
        height: _iconSize(context),
        width: _iconSize(context),
      ),
    );

    Widget rotatedIcon = Transform.rotate(
      angle: -genderAngles[gender],
      child: icon,
    );

    Widget iconWithALine = Padding(
      padding: EdgeInsets.only(bottom: circleSize(context) / 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          rotatedIcon,
          GenderLine(),
        ],
      ),
    );

    Widget rotatedIconWithALine = Transform.rotate(
      alignment: Alignment.bottomCenter,
      angle: genderAngles[gender],
      child: iconWithALine,
    );

    Widget centeredIconWithALine = Padding(
      padding: EdgeInsets.only(bottom: circleSize(context) / 2),
      child: rotatedIconWithALine,
    );

    return centeredIconWithALine;
  }

}

/// 指针
class GenderArrow extends AnimatedWidget { // StatelessWidget {
  final double angle;

  const GenderArrow({Key key, this.angle, Listenable listenable}) : super(key: key, listenable: listenable);

  double _arrowLength(BuildContext context) => screenAwareSize(32.0, context);

  // 与圆心的偏移距离
  double _translationOffset(BuildContext context) => _arrowLength(context) * -0.4;

  @override
  Widget build(BuildContext context) {
    Animation animation = listenable;
    return Transform.rotate(
      angle: animation.value, // 使用动画来控制角度
      child: Transform.translate(
        offset: Offset(0.0, _translationOffset(context)),
        child: Transform.rotate(
          angle: -defaultGenderAngle, // 旋转角度，为负则以底部为圆心
          child: SvgPicture.asset(
            "assets/bmi/images/gender_arrow.svg",
            height: _arrowLength(context),
            width: _arrowLength(context),
          ),
        ),
      ),
    );
  }
}

/// 手势控制区，按宽度分成三列，方便点击
class TapHandler extends StatelessWidget {
  final Function(Gender) onGenderTapped;

  const TapHandler({Key key, this.onGenderTapped}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(child: GestureDetector(onTap: () => onGenderTapped(Gender.female))),
        Expanded(child: GestureDetector(onTap: () => onGenderTapped(Gender.other))),
        Expanded(child: GestureDetector(onTap: () => onGenderTapped(Gender.male))),
      ],
    );
  }
}