import 'package:flutter/material.dart';
import 'dart:math' as math;

const double baseHeight = 650.0;

/// 根据屏幕的实际高度与我们设计期的高试比，来计算出实际的高度，这样可以适应不同的设备
double screenAwareSize(double size, BuildContext context) {
  return size * MediaQuery.of(context).size.height / baseHeight;
}

/// 性别
enum Gender { male, female, other }

// 三个性别图标之间存在45度的角，也就是pi / 4
const double defaultGenderAngle = math.pi / 4;
const Map<Gender, double> genderAngles = {
  Gender.female: -defaultGenderAngle,
  Gender.other: 0.0,
  Gender.male: defaultGenderAngle,
};

const Map<Gender, String> genderName = {
  Gender.female: "女人",
  Gender.other: "其它",
  Gender.male: "男人",
};

/// 计算圆的大小
double circleSize(BuildContext context) => screenAwareSize(80.0, context);
