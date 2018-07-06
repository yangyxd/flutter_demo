import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo/utils/styles.dart';
import 'package:flutter/src/material/constants.dart';
import 'package:flutter/src/foundation/platform.dart';
import 'dart:math' as math;

class Choice {
	Choice({ this.title, this.icon, this.id, this.selected = false });
	final String title;
	IconData icon;
	final int id;
	bool selected;
}

/** Icon Text */
class IconText extends StatelessWidget {
	final String text;
	final IconData icon;
	final int fontSize;
	final double spacing;
	final Color color;
	final Color bgcolor;
	final EdgeInsets padding;
	final TextOverflow overflow;
	final Axis direction;
	final VerticalDirection verticalDirection;
	final String tooltip;
	final bool useWrap;

	IconText({this.text,
		this.icon = null,
		this.fontSize = Styles.fontSizeL4,
		this.color = Styles.fontColorHint,
		this.spacing = 4.0,
		this.bgcolor = null,
		this.padding = const EdgeInsets.only(right: 6.0),
		this.overflow = TextOverflow.clip,
		this.verticalDirection = VerticalDirection.down,
		this.tooltip,
		this.direction = Axis.horizontal,
		this.useWrap = false,
	}) : assert(icon != null || text != null);

	@override
	Widget build(BuildContext context) {
		List<Widget> views = [];
		if (icon != null)
			views.add(new Icon(icon, size: fontSize.toDouble(), color: color));

		if (text != null && text.length > 0) {
			if (useWrap)
				views.add(new Text(text, style: Styles.buildStyle(color, fontSize),
						overflow: this.overflow));
			else {
				if (icon != null)
					views.add(new SizedBox(width: this.spacing,));
				if (this.overflow == TextOverflow.ellipsis)
					views.add(new Expanded(child: new Container(
						child: Text(text, style: Styles.buildStyle(color, fontSize),
								overflow: this.overflow),
					)));
				else
					views.add(new Text(text, style: Styles.buildStyle(color, fontSize),
							overflow: this.overflow));
			}
		}

		Widget result;
		if (useWrap) {
			result = new Wrap(
				children: views,
				crossAxisAlignment: WrapCrossAlignment.center,
				spacing: this.spacing,
				direction: this.direction,
				verticalDirection: this.verticalDirection,
			);
		} else if (this.direction == Axis.horizontal) {
			result = new Row(
				children: views,
				crossAxisAlignment: CrossAxisAlignment.center,
				verticalDirection: this.verticalDirection,
			);
		} else {
			result = new Column(
				children: views,
				crossAxisAlignment: CrossAxisAlignment.center,
				verticalDirection: this.verticalDirection,
			);
		}

		if (tooltip != null) {
			result = new Tooltip(
				message: tooltip,
				child: result
			);
		}

		if (bgcolor == null && padding == null) {
			return result;
		} else {
			return new Container(
				child: result,
				color: bgcolor,
				padding: this.padding,
			);
		}
	}
}

/** 文本框底部边线 */
class BootomInputBorder extends InputBorder {
	final Color color;
	final double width;

	BootomInputBorder(this.color, {this.width = 1.0}): super(borderSide: new BorderSide(color: color, width: width));

	@override
	BootomInputBorder copyWith(
			{BorderSide borderSide, BorderRadius borderRadius}) {
		return new BootomInputBorder(this.color, width: this.width);
	}

	@override
	bool get isOutline => false;

	@override
	EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

	@override
	BootomInputBorder scale(double t) =>
			BootomInputBorder(this.color, width: this.width);

	@override
	Path getInnerPath(Rect rect, {TextDirection textDirection}) {
		return new Path()..addRect(rect);
	}

	@override
	Path getOuterPath(Rect rect, {TextDirection textDirection}) {
		return new Path()..addRect(rect);
	}

	@override
	void paint(
			Canvas canvas,
			Rect rect, {
				double gapStart,
				double gapExtent: 0.0,
				double gapPercentage: 0.0,
				TextDirection textDirection,
			}) {
		canvas.drawLine(rect.bottomLeft, rect.bottomRight, borderSide.toPaint());
	}
}

/** 共用动作列表项 (带图标) */
class ActionListItem extends StatelessWidget {
	static const double defaultHeight = 47.0;
	static final defaultTitleStyle = Styles.buildStyleContent(Styles.fontSizeL2);
	static final defaultValueStyle = Styles.buildSubTitle(Styles.fontSizeL2);
	static final defaultValueHintStyle = Styles.buildStyleContentHint(Styles.fontSizeL2);

	const ActionListItem({
		Key key,
		this.icon,
		this.color = Styles.contentColor,
		this.title,
		this.value,
		this.valueHint,
		this.iconSize = 24.0,
		this.titleStyle = null,
		this.valueStyle = null,
		this.spacingTop = 0.0,
		this.spacingBottom = 0.0,
		this.lineWidth = 0.5,
		this.lineColor = Styles.lineColor,
		this.iconColor = Styles.mainColor,
		this.height = ActionListItem.defaultHeight,
		this.showRightIcon = true,
		this.rightChild,
		this.onTap,
		this.borderRadius,
	}) : super(key: key);

	final IconData icon;
	final Color color, lineColor, iconColor;
	final String title, value, valueHint;
	final VoidCallback onTap;
	final double iconSize, lineWidth;
	final TextStyle titleStyle;
	final TextStyle valueStyle;
	final double spacingTop, spacingBottom, height;
	final bool showRightIcon;
	final Widget rightChild;
	final BorderRadius borderRadius;

	@override
	Widget build(BuildContext context) {
		Widget v = new Material(
			child: new InkWell(
				onTap: onTap,
				child: new SizedBox(
					height: this.height,
					child: new Row(
						children: <Widget>[
							new Padding(padding: new EdgeInsets.only(left: 20.0 + ((icon == null) ? iconSize : 0.0), right: 16.0),
								child: (icon == null) ? null : new Icon(icon, size: iconSize, color: iconColor),
							),
							(title == null || title.length == 0) ? new Container():	new Text(title, style: titleStyle == null ? defaultTitleStyle : titleStyle),
							new Expanded(child: new Container(
								alignment: Alignment.centerRight,
								child: (value == null || value.length == 0) ?
									((valueHint != null) ? new Text(valueHint, style: defaultValueHintStyle) : null ) :
									new Text(value, style: valueStyle == null ? defaultValueStyle : valueStyle),
							)),
							new Padding(padding: new EdgeInsets.only(left: 8.0, right: showRightIcon ? 4.0: 0.0),
								child: showRightIcon ? Styles.RightMoreIcon : rightChild
							),
						],
					),
				),
			),
			color: color,
			borderRadius: borderRadius,
			shape: lineWidth > 0.01 ?  new Border(top: new BorderSide(color: Styles.lineColor, width: lineWidth),
					bottom: spacingBottom > 0.01 ? new BorderSide(color: Styles.lineColor, width: lineWidth) : BorderSide.none) : null,
		);
		if (spacingTop > 0 || spacingBottom > 0) {
			v = new Padding(
				padding: new EdgeInsets.only(top: spacingTop, bottom: spacingBottom),
				child: v,
			);
		}
		return v;
	}
}

/** 共用文本编辑列表项 (带图标) */
class EditListItem extends StatefulWidget {
	static const double defaultHeight = 47.0;
	static final defaultTitleStyle = new TextStyle(fontSize: Styles.fontSizeL2.toDouble(), color: Styles.fontColorContent);
	static final defaultValueStyle = Styles.buildSubTitle(Styles.fontSizeL2);
	static final defaultValueHintStyle = Styles.buildStyleContentHint(Styles.fontSizeL2);

	EditListItem({
		Key key,
		this.icon,
		this.color = Styles.contentColor,
		this.title,
		this.titleWidth = 95.0,
		this.titleAlignment = Alignment.centerRight,

		this.value,
		this.valueHint,
		this.iconSize = 24.0,
		this.titleStyle = null,
		this.valueStyle = null,
		this.spacingTop = 0.0,
		this.spacingBottom = 0.0,
		this.spacingValue = 16.0,
		this.lineWidth = 0.5,
		this.lineColor = Styles.lineColor,
		this.iconColor = Styles.mainColor,
		this.height = EditListItem.defaultHeight,
		this.rightChild,
		this.borderRadius,
		this.onTap,
		this.keyboardType = TextInputType.text,
		this.maxLength = 50,
		this.isPwd = false,
		this.textAlign = TextAlign.left,
		this.enabled = true,
		this.onChanged,
		this.onSubmitted,
		this.inputFormatters,
	}) : super(key: key) {
		controller.text = value;
	}

	final IconData icon;
	final Color color, lineColor, iconColor;
	final String title, value, valueHint;
	final VoidCallback onTap;
	final double iconSize, lineWidth;
	final TextStyle titleStyle;
	final double titleWidth;
	final TextStyle valueStyle;
	final double spacingTop, spacingBottom, spacingValue, height;
	final Widget rightChild;
	final BorderRadius borderRadius;

	final int maxLength;
	final TextInputType keyboardType;
	final bool isPwd;
	final AlignmentGeometry titleAlignment;
	final TextAlign textAlign;
	final bool enabled;
	final ValueChanged<String> onChanged;
	final ValueChanged<String> onSubmitted;
	final List<TextInputFormatter> inputFormatters;

	final TextEditingController controller = new TextEditingController();

	String get text => controller.text;
	set text(String newText) {
		controller.text = newText;
	}

	@override
	_EditListItemState createState() => new _EditListItemState();

	Widget buildWidget(BuildContext context, FocusNode _focusNode) {
		Widget v = new Material(
			child: new InkWell(
				onTap: onTap,
				child: new SizedBox(
					height: this.height,
					child: new Row(
						children: <Widget>[
							new Padding(padding: new EdgeInsets.only(left: ((titleAlignment == Alignment.centerRight) ? 8.0 : 20.0) + ((icon == null) ? iconSize : 0.0), right: 16.0),
								child: (icon == null) ? null : new Icon(icon, size: iconSize, color: iconColor),
							),
							new Container(width: this.titleWidth, alignment: titleAlignment, padding: (spacingValue > 0) ? new EdgeInsets.only(right: this.spacingValue): null,
									child: 	new Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: titleStyle == null ? defaultTitleStyle : titleStyle)),
							new Expanded(child: new Container(
									alignment: Alignment.centerRight,
									child: new TextField(
											focusNode: _focusNode,
											textAlign: textAlign,
											controller: controller,
											keyboardType: keyboardType,
											maxLength: this.maxLength,
											obscureText: this.isPwd,
											autocorrect: false,
											enabled: enabled,
											style: valueStyle == null ? defaultValueStyle: valueStyle,
											onChanged: this.onChanged,
											onSubmitted: this.onSubmitted,
											inputFormatters: this.inputFormatters,
											decoration: new InputDecoration(
												counterText: "",
												counterStyle: new TextStyle(fontSize: 0.01),
												//border: _focusNode.hasFocus ? new BootomInputBorder(lineColor, width: 0.5) : InputBorder.none,
												border: InputBorder.none,
												contentPadding: new EdgeInsets.fromLTRB(2.0, 12.0, 2.0, 2.0),
												hintText: this.valueHint,
												hintStyle: defaultValueHintStyle,
											)
									)
							)),
							new Padding(padding: new EdgeInsets.only(left: 8.0),
									child: rightChild
							),
						],
					),
				),
			),
			color: color,
			borderRadius: borderRadius,
			shape: lineWidth > 0.01 ?  new Border(top: new BorderSide(color: Styles.lineColor, width: lineWidth),
					bottom: spacingBottom > 0.01 ? new BorderSide(color: Styles.lineColor, width: lineWidth) : BorderSide.none) : null,
		);
		if (spacingTop > 0 || spacingBottom > 0) {
			v = new Padding(
				padding: new EdgeInsets.only(top: spacingTop, bottom: spacingBottom),
				child: v,
			);
		}
		return v;
	}
}

class _EditListItemState extends State<EditListItem> {

	FocusNode _focusNode = new FocusNode();

	@override
	Widget build(BuildContext context) {
		return widget.buildWidget(context, _focusNode);
	}
}

/// 支持设置大小和背景色的 Bar
class SizedBar extends StatefulWidget implements PreferredSizeWidget {
	final PreferredSizeWidget child;
	final Color color;
	final double width, height;
	final BoxConstraints constraints;
	final Decoration decoration;

	SizedBar({Key key, this.color, this.width, this.height, this.constraints, this.decoration, this.child}): super(key: key);

	@override
	State<StatefulWidget> createState() => new SizedBarState();

	@override
	Size get preferredSize {
		return child.preferredSize;
	}
}

class SizedBarState extends State<SizedBar> {
	@override
	Widget build(BuildContext context) {
		return Container(
			color: widget.color,
			width: widget.width,
			height: widget.height,
			constraints: widget.constraints,
			decoration: widget.decoration,
			child: widget.child,
		);
	}
}

