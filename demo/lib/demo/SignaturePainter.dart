import 'package:flutter/material.dart';
import 'package:demo/utils/common.dart';

class SignaturePainterSample extends StatefulWidget {
	final String title;
	SignaturePainterSample({this.title});

	@override
	createState() => new SignaturePainterSampleState(title);
}

class SignaturePainterSampleState extends State<SignaturePainterSample>  {
	final String title;
	SignaturePainterSampleState(this.title);

	List<Offset> _points = <Offset>[];

	@override
	Widget build(BuildContext context) {
		final appbar = new AppBar(
			elevation: Common.Elevation,
			title: new Text(this.title),
		);

		final Container canvas = new Container (
				margin: const EdgeInsets.all(4.0),
				alignment: Alignment.topLeft,
				color: Colors.teal.shade50,
				child: new CustomPaint(
					painter: new SignaturePainter(_points),
				)
		);

		GestureDetector body = new GestureDetector(
			onPanUpdate: (DragUpdateDetails details) {
				setState(() {
					RenderBox referenceBox = context.findRenderObject();
					Offset p = referenceBox.globalToLocal(details.globalPosition);
					p = p.translate(0.0, -(appbar.preferredSize.height));

					_points = new List.from(_points)..add(p);
				});
			},
			onPanEnd: (DragEndDetails details) => _points.add(null),
			child: canvas,
		);

		return new Scaffold(
			appBar: appbar,
			body: body,
			floatingActionButton: new FloatingActionButton(
				tooltip: 'Fade',
				backgroundColor: Colors.grey,
				child: new Icon(Icons.refresh),
				onPressed: () {
					setState(() {
						_points.clear();
					});
				},
			),
		);
	}

	@override
	void initState() {
		super.initState();
	}

}

class SignaturePainter extends CustomPainter {
	SignaturePainter(this.points);
	final List<Offset> points;
	void paint(Canvas canvas, Size size) {
		var paint = new Paint()
			..color = Colors.black
			..strokeCap = StrokeCap.round
			..strokeWidth = 3.0;
		for (int i = 0; i < points.length - 1; i++) {
			if (points[i] != null && points[i + 1] != null)
				canvas.drawLine(points[i], points[i + 1], paint);
		}
	}
	bool shouldRepaint(SignaturePainter other) => other.points != points;
}
