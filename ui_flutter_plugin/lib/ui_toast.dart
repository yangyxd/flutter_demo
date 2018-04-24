import 'dart:async';
import 'package:flutter/services.dart';

enum ToastLength {
	LENGTH_SHORT,
	LENGTH_LONG
}

enum ToastGravity {
	TOP,
	BOTTOM,
	CENTER
}

class Toast {
	static const MethodChannel _channel = const MethodChannel('ui_flutter_plugin');

	static Future<String> show(final String msg,
			{ToastLength toastLength,
				int timeInSecForIos,
				ToastGravity gravity
			}) async {

		String toast = "short";
		if (toastLength == ToastLength.LENGTH_LONG)
			toast = "long";

		String gravityToast = "bottom";
		if (gravity == ToastGravity.TOP)
			gravityToast = "top";
		else if (gravity == ToastGravity.CENTER)
			gravityToast = "center";

		final Map<String, dynamic> params = <String, dynamic> {
			'msg': msg,
			'length': toast,
			'time': timeInSecForIos,
			'gravity': gravityToast
		};

		String res = await _channel.invokeMethod('showToast', params);
		return res;
	}
}
