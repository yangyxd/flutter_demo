import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImageListSample extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new ImageListSampleState();
  }
}

final List<String> imageList = [
  'http://lmy-art.gz.bcebos.com/v1/1006663337878/content/content_1498749492790.jpg',
  'http://lmy-art.gz.bcebos.com/v1/1005256145660/content/content_1497316670935.jpg',
  'http://lmy-art.gz.bcebos.com/v1/1008524843831/content/content_1500527395338.jpg',
  'http://lmy-art.gz.bcebos.com/v1/1008524843831/content/content_1500527346640.jpg',
  'http://lmy-art.gz.bcebos.com/v1/1000000534108/content/content_1496552614575.jpg',
  'http://lmy-art.gz.bcebos.com/v1/1000000534109/content/content_1498408767477.jpg',
  'http://lmy-art.gz.bcebos.com/v1/1000000534108/content/content_1492224762726.jpg',
  'http://lmy-art.gz.bcebos.com/v1/1006663337878/content/content_1498749739492.jpg',
  'http://lmy-art.gz.bcebos.com/v1/1005256145660/content/content_1497921926270.jpg',
  'http://lmy-art.gz.bcebos.com/v1/1000000534109/content/content_1497099047080.jpg',
  'http://lmy-art.gz.bcebos.com/v1/1000000534108/content/content_1496109728713.jpg',
  'http://lmy-art.gz.bcebos.com/v1/1000000534108/content/content_1495756883208.jpg',
  'http://lmy-art.gz.bcebos.com/v1/1000000534108/content/content_1495160230652.jpg',
  'http://lmy-art.gz.bcebos.com/v1/1000000534108/content/content_1491213473387.jpg',
  'http://lmy-art.gz.bcebos.com/v1/1000000534109/content/content_1497661133681.jpg'
];

class ImageListSampleState extends State<ImageListSample> {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("图像列表测试"),
        elevation: 0.5,
      ),
      body: Container(
        child: ListView.builder(
          itemCount: 10000,
          itemBuilder: ((BuildContext context, int index) {
            var _url = imageList[index % imageList.length] + "?t=${DateTime.now().millisecondsSinceEpoch}";
            return new Container(
              height: 230.0,
              padding: const EdgeInsets.all(8.0),
              child:  new CachedNetworkImage(
                //placeholder: new CircularProgressIndicator(),
                imageUrl: _url,
                fit: BoxFit.cover,
              ),
            );
          }),
        ),
      ),
    );
  }
}