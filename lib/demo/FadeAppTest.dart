import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:demo/utils/common.dart';

class FadeAppTestSample extends StatefulWidget {
	final String title;
	FadeAppTestSample({this.title});

	@override
	createState() => new FadeAppTestSampleState(title);
}

class FadeAppTestSampleState extends State<FadeAppTestSample> with TickerProviderStateMixin {
	final String title;
	FadeAppTestSampleState(this.title);

	AnimationController controller;
	CurvedAnimation curve;


	@override
	Widget build(BuildContext context) {
		return new Scaffold(
			appBar: new AppBar(
				elevation: Common.Elevation,
				title: new Text(this.title),
			),
			body: new Center(
					child: new Container(
							child: new FadeTransition(
									opacity: curve,
									child: new FlutterLogo(
										size: 100.0,
									)))),
			floatingActionButton: new FloatingActionButton(
				tooltip: 'Fade',
				child: new Icon(Icons.brush),
				onPressed: () {
					if (controller.isCompleted) {
						controller.reverse();
					} else
						controller.forward();
				},
			),
		);
	}

	@override
	void initState() {
		super.initState();
		controller = new AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);
		curve = new CurvedAnimation(parent: controller, curve: Curves.easeIn);
	}

}
