import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../utils/common.dart';

class ExpansionTileSample extends StatefulWidget {
	final String title;
	ExpansionTileSample({this.title});

	@override
	createState() => new ExpansionTileState(title);
}

class ExpansionTileState extends State<ExpansionTileSample> {
	final String title;
	ExpansionTileState(this.title);

	@override
	Widget build(BuildContext context) {
		return new Scaffold(
			appBar: new AppBar(
				elevation: Styles.Elevation,
				title: new Text(this.title),
			),
			body: new ListView.builder(
				itemBuilder: (BuildContext context, int index) => new EntryItem(data[index]),
				itemCount: data.length,
			),
		);
	}


	@override
	void initState() {
		super.initState();
	}

}

// One entry in the multilevel list displayed by this app.
class Entry {
	Entry(this.title, [this.children = const <Entry>[]]);
	final String title;
	final List<Entry> children;
}

// The entire multilevel list displayed by this app.
final List<Entry> data = <Entry>[
	new Entry('Chapter A',
		<Entry>[
			new Entry('Section A0',
				<Entry>[
					new Entry('Item A0.1'),
					new Entry('Item A0.2'),
					new Entry('Item A0.3'),
				],
			),
			new Entry('Section A1'),
			new Entry('Section A2'),
		],
	),
	new Entry('Chapter B',
		<Entry>[
			new Entry('Section B0'),
			new Entry('Section B1'),
		],
	),
	new Entry('Chapter C',
		<Entry>[
			new Entry('Section C0'),
			new Entry('Section C1'),
			new Entry('Section C2',
				<Entry>[
					new Entry('Item C2.0'),
					new Entry('Item C2.1'),
					new Entry('Item C2.2'),
					new Entry('Item C2.3'),
				],
			),
		],
	),
];

// Displays one Entry. If the entry has children then it's displayed
// with an ExpansionTile.
class EntryItem extends StatelessWidget {
	const EntryItem(this.entry);

	final Entry entry;

	Widget _buildTiles(Entry root) {
		if (root.children.isEmpty) {
//			return new ListTile(
//				title: new Text(root.title),
//				trailing: new Icon(Icons.opacity),
//				onTap: () {
//					Common.toast(entry.title);
//				},
//			);
			return new Container(
//				decoration: new BoxDecoration(
//						border: new Border(
//							//top: new BorderSide(color: Colors.grey, width: 0.1),
//							//bottom: new BorderSide(color: Colors.grey, width: 0.1),
//						)
//				),
				child: new ListTile(
					title: new Text(root.title),
					trailing: new Icon(Icons.opacity),
					onTap: () {
						Tools.toast(entry.title);
					},
				),
			);
		}

		return new ExpansionTile(
			key: new PageStorageKey<Entry>(root),
			title: new Text(root.title),
			children: root.children.map(_buildTiles).toList(),
		);
	}

	@override
	Widget build(BuildContext context) {
		return _buildTiles(entry);
	}
}