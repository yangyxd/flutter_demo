import 'package:fluttertoast/fluttertoast.dart';
//import 'package:ui_flutter_plugin/ui_toast.dart';

/**
 * 公共函数库 by YangYxd
 */
class Common {

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
}