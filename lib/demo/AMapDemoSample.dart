import 'dart:io';
import 'package:flutter_amap/flutter_amap.dart';
import 'package:flutter/material.dart';
import '../utils/common.dart';

class AMapDemoSample extends StatefulWidget {
  final String title;
  AMapDemoSample({this.title});

  final FlutterAmap amap = new FlutterAmap();

  @override
  createState() => new AMapDemoSampleSampleState();
}

class AMapDemoSampleSampleState extends State<AMapDemoSample> {
  String location = "";

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          elevation: Styles.Elevation,
          title: new Text(widget.title),
        ),
        body: new Center(
          child: new Column(
            children: <Widget>[
              new SizedBox(
                height: 30.0,
              ),
              new MaterialButton(
                  onPressed: () {
                    show();
                  },
                  child: new Text("打开地图")),
              new SizedBox(
                height: 30.0,
              ),
              new Text(location),
            ],
          ),
        ));
  }

  @override
  void initState() {
    super.initState();
    if (Platform.isIOS) {
      FlutterAmap.setApiKey('c3186fc8d4f1a276be6f9612e964ccde');
    } else {
      FlutterAmap.setApiKey('c0f25dfeb01c6cbf1ffab9fcee022e3a');
    }
  }

  void show() {
    widget.amap.show(
        mapview: new AMapView(
            centerCoordinate: new LatLng(39.9242, 116.3979),
            zoomLevel: 13.0,
            mapType: MapType.standard,
            showsUserLocation: true),
        title: new TitleOptions(title: "我的地图"));
    widget.amap.onLocationUpdated.listen((Location location) {
      print("Location changed  $location");
      setState(() {
        this.location = location.toString();
      });
    });
  }
}
