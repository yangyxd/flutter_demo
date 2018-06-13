import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../utils/common.dart';

class TabbedAppBarSample extends StatefulWidget {
	final String title;
	TabbedAppBarSample({this.title});

	@override
	createState() => new TabbedAppBarSampleState(title);
}

class TabbedAppBarSampleState extends State<TabbedAppBarSample> {
	final String title;
	TabbedAppBarSampleState(this.title);

	@override
	Widget build(BuildContext context) {
		final tabbar = new TabBar(
			isScrollable: true,
			tabs: choices.map((Choice choice) {
				return new Tab(
					text: choice.title,
					icon: new Icon(choice.icon),
				);
			}).toList(),
		);

		return new DefaultTabController(
			length: choices.length,
			child: new Scaffold(
				appBar: new AppBar(
					elevation: Styles.Elevation,
					title: new Text(this.title),
					bottom: tabbar,
				),
				body: new TabBarView(
					//children: <Widget>[],
					children: choices.map((Choice choice) {
						return new Padding(
							padding: const EdgeInsets.all(16.0),
							child: new ChoiceCard(choice: choice),
						);
					}).toList(),
				),
			)
		);
	}


	@override
	void initState() {
		super.initState();
	}

}

class Choice {
	const Choice({ this.title, this.icon });
	final String title;
	final IconData icon;
}

const List<Choice> choices = const <Choice>[
	const Choice(title: 'CAR', icon: Icons.directions_car),
	const Choice(title: 'BICYCLE', icon: Icons.directions_bike),
	const Choice(title: 'BOAT', icon: Icons.directions_boat),
	const Choice(title: 'BUS', icon: Icons.directions_bus),
	const Choice(title: 'TRAIN', icon: Icons.directions_railway),
	const Choice(title: 'WALK', icon: Icons.directions_walk),
];

class ChoiceCard extends StatelessWidget {
	const ChoiceCard({ Key key, this.choice }) : super(key: key);

	final Choice choice;

	@override
	Widget build(BuildContext context) {
		final TextStyle textStyle = Theme.of(context).textTheme.display1;
		return new Card(
			color: Colors.white,
			child: new Center(
				child: new Column(
					mainAxisSize: MainAxisSize.min,
					crossAxisAlignment: CrossAxisAlignment.center,
					children: <Widget>[
						new Icon(choice.icon, size: 128.0, color: textStyle.color),
						new Text(choice.title, style: textStyle),
					],
				),
			),
		);
	}
}
