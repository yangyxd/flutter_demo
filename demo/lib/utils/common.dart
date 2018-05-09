import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

//import 'package:ui_flutter_plugin/ui_toast.dart';

/**
 * 公共函数库 by YangYxd
 */
class Common {
	/**
	 * 在线小说网址
	 */
	static final String book_baseurl = 'https://m.biquguan.com';

	/**
	 * 默认 Elevation
	 */
	static final double Elevation = 0.5;

	/**
	 * 默认行分隔线颜色
	 */
	static var lineColor = new Color(0xFFdbdbdb);

	/**
	 * 显示Toast消息
	 */
	static void toast(String msg, {Toast toastLength,
		int timeInSecForIos,
		ToastGravity gravity}) {
		Fluttertoast.showToast(msg: msg,
			timeInSecForIos: timeInSecForIos,
			gravity: gravity,
			toastLength: toastLength
		);
	}

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


}

