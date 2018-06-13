import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../utils/common.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AsyncLoadListSample extends StatefulWidget {
	final String title;
	AsyncLoadListSample({this.title});

	@override
	createState() => new AsyncLoadListSampleState(title);
}

class AsyncLoadListSampleState extends State<AsyncLoadListSample> {
	final String title;
	AsyncLoadListSampleState(this.title);

	List widgets = [];

	@override
	Widget build(BuildContext context) {

		return new Scaffold(
			appBar: new AppBar(
				elevation: Common.Elevation,
				title: new Text(this.title),
			),
			body: getBody(),
		);
	}


	@override
	void initState() {
		super.initState();
		loadData();
	}

	// 在异步函数中加载数据
	loadData() async {
		String dataURL = "https://jsonplaceholder.typicode.com/posts";
		http.Response response = await http.get(dataURL);
		setState(() {
			widgets = JSON.decode(response.body);
		});
	}

	showLoadingDialog() {
		if (widgets.length == 0) {
			return true;
		}

		return false;
	}

	ListView getListView() => new ListView.builder(
			itemCount: widgets.length,
			itemBuilder: (BuildContext context, int position) {
				return getRow(position);
			});

	getBody() {
		if (showLoadingDialog()) {
			return getProgressDialog();
		} else {
			return getListView();
		}
	}

	getProgressDialog() {
		return new Center(child: new CircularProgressIndicator());
	}

	Widget getRow(int i) {
		return new Padding(
				padding: new EdgeInsets.all(10.0),
				child: new Text("Row ${widgets[i]["title"]}")
		);
	}
}

