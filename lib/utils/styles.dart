import 'font_icons.dart';
import 'package:flutter/material.dart';
export 'font_icons.dart';

/**
 * 样式 by YangYxd
 */
class Styles {
	/**
	 * 默认 Elevation
	 */
	static const double Elevation = 0.5;

	/**
	 * 默认行分隔线颜色
	 */
	static const lineColor = const Color(0xFFdbdbdb);
	/**
	 * 内容颜色 (list , edit)
	 */
	static const contentColor = const Color(0xffffffff);
	/**
	 * 标题栏颜色
	 */
	static const appBarColor = const Color(0xFFffffff);
	/**
	 * 主色调
	 */
	static const mainColor = const Color(0xeF00c2da);


	static const nullColor = const Color(0x00000000);

	static const int fontSizeL1 = 20; // 正文标题
	static const int fontSizeL2 = 16; // 正文内容
	static const int fontSizeMenu = 15; // 菜单文本
	static const int fontSizeListItem = 14; // 正文列表
	static const int fontSizeL3 = 13; // 正文描述
  static const int fontSizeL4 = 12; // 正文描述
	static const int fontSizeL5 = 10; // 最小号

	/**
	 * 标题字体颜色
	 */
	static const fontColorTitle = const Color(0xffffffff);

	/**
	 * 标题字体颜色
	 */
	static const fontColorSubTitle = const Color(0xff757575);

	/**
	 * 高亮文本颜色
	 */
	static const fontColorHigh = const Color(0xff00afd8);

	/**
	 * 正文字体颜色
	 */
	static const fontColorContent = const Color(0xff2e302f);

	/**
	 * 底部导航栏前背色
	 */
	static const fontColorBottomBar = const Color(0xff00afd8);

	/**
	 * 灰底Hint提示颜色（深）
	 */
	static const fontColorHint = const Color(0xff959595);

	/**
	 * 白底Hint提示颜色（浅）
	 */
	static const fontColorHintLight = const Color(0xffbfbfbf);

	/** 菜单文本颜色  */
	static const fontColorMenuText = const Color(0xff101010);

	/** 菜单文本选中颜色  */
	static const fontColorMenuTextSel = const Color(0xffff4b4b);


	static buildSubTitle(int size){
		return new TextStyle(color: new Color(0xFF757575), fontSize: size.toDouble());
	}

	static buildTitle(int size){
		return new TextStyle(color: Colors.black87, fontSize: size.toDouble());
	}

	static buildStyle(Color color, int size){
		return new TextStyle(color: color, fontSize: size.toDouble());
	}

	static buildStyleAndSpace(Color color, int size, double space){
		return new TextStyle(color: color, fontSize: size.toDouble(), height: space);
	}

	static buildStyleContent([int size = fontSizeL2]) {
		return new TextStyle(color: fontColorContent, fontSize: size.toDouble());
	}

	static buildStyleContentHint([int size = fontSizeL2]) {
		return new TextStyle(color: fontColorHint, fontSize: size.toDouble());
	}

	/** 动作行列右边箭头 */
	static final RightMoreIcon = new Icon(FontIcons.angle_right, color: Styles.fontColorHintLight, size: Styles.fontSizeL1.toDouble(),);


}

