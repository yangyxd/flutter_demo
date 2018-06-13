import 'package:flutter/material.dart';

/**
 * Flow
 */
class FlowDelegateView extends FlowDelegate {
	double padding = 0.0;

	FlowDelegateView({this.padding});

	@override
	void paintChildren(FlowPaintingContext context) {
		var tempWidth = 0.0;
		var tempHeight = 0.0;
		for (int i = 0; i < context.childCount; i++) {
			var w = context.getChildSize(i).width + tempWidth + padding;
			if (w < context.size.width) {
				context.paintChild(i,
						transform: new Matrix4.translationValues(
								tempWidth + padding, tempHeight, 0.0));
				tempWidth = w;
			} else {
				tempWidth = 0.0;
				tempHeight += context.getChildSize(i).height + padding;
				context.paintChild(i,
						transform: new Matrix4.translationValues(
								tempWidth + padding, tempHeight, 0.0));
				tempWidth += context.getChildSize(i).width + padding;
			}
		}
	}

	@override
	bool shouldRepaint(FlowDelegate oldDelegate) {
		return oldDelegate != this;
	}

	@override
	BoxConstraints getConstraintsForChild(int i, BoxConstraints constraints){
		BoxConstraints boxConstraints = new BoxConstraints(maxHeight: constraints.maxHeight,maxWidth: constraints.maxWidth);
		return boxConstraints;
	}
}