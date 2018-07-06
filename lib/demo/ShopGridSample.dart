import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:transparent_image/transparent_image.dart';

class ShopGridSample extends StatefulWidget {
  @override
  createState() => new ShopGridSampleState();
}

class ShopGridSampleState extends State<ShopGridSample> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: pageItems.length,
      child: Scaffold(
        appBar: AppBar(
          title: new Text("9.9省钱精选"),
          centerTitle: true,
          elevation: 0.5,
          backgroundColor: Color(0xff158cd5),
          textTheme: TextTheme(title: TextStyle(color: Colors.white, fontSize: 18.0)),
          iconTheme: IconThemeData(color: Colors.white),
          bottom: new TabBar(
            isScrollable: true,
            labelColor: Colors.white,
            indicatorWeight: 2.0,
            indicatorColor: Colors.white,
            indicatorPadding: const EdgeInsets.only(bottom: 4.0, left: 8.0, right: 8.0),
            tabs: pageItems.map((ShopPage page) {
              return new Tab(text: page.title);
            }).toList(),
          ),
        ),
        body: new TabBarView(
          //children: <Widget>[],
          children: pageItems.map((ShopPage item) {
            return new Container(
              padding: null,
              child: (item.id == 0) ? new PageView(data: item) : new Center(child: Text("敬请期待")),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class PageView extends StatefulWidget {
  final ShopPage data;
  PageView({Key key, this.data}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new PageViewState(data: this.data);
}

class PageViewState extends State<PageView> {
  final ShopPage data;
  PageViewState({this.data});

  final List<String> _ImgList = [
    ('https://img14.360buyimg.com/n0/jfs/t4015/38/1245010189/278921/a425cd20/586dd8e8N0b698bc0.jpg'),
    ( 'https://img14.360buyimg.com/n0/jfs/t12901/89/957816754/402216/89589deb/5a1773ebN25b728eb.jpg'),
    ('https://img14.360buyimg.com/n0/jfs/t3811/293/2707574404/256051/aed5ef7/5864ab62N9a3bcb0d.jpg'),
    ('https://img10.360buyimg.com/n2/jfs/t22327/332/1073634739/498315/6ea17ed4/5b1f378dN6683d2ec.jpg'),
    ( 'https://img12.360buyimg.com/n2/jfs/t4159/21/2659690871/765919/ee4ca7eb/58d4cb03Naa9567f4.jpg'),
  ];

  List<Widget> imgViews = [];

  @override
  void initState() {
    super.initState();
    imgViews.length = _ImgList.length;

    for (int i=0; i<_ImgList.length; i++) {
      imgViews[i] = new FadeInImage.memoryNetwork(
        image: _ImgList[i],
        fit: BoxFit.contain,
        height: imgH,
        placeholder: kTransparentImage,
        width: double.infinity,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xefd8d9da),
      child: CustomScrollView(
        primary: true,
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Container(
              child: Column(
                children: <Widget>[
                  _buildTopBar(),
                ],
              ),
            ),
          ),
          _buildShopGrid(),
        ],
      ),
    );
  }

  List<String> topButtons = [
    "综合", "销量", "券额", "价格"
  ];

  Widget _buildTopBar() {
    return Container(
      padding: (topButtons == null || topButtons.length == 0) ? null : EdgeInsets.all(8.0),
      child: (topButtons == null || topButtons.length == 0) ? null : Wrap(
        spacing: 8.0,
        children: topButtons.map((String v) {
          return ClipRRect(borderRadius: BorderRadius.circular(16.0), child: new RawMaterialButton(
              fillColor: Color(0xffe2e2e2),
              textStyle: TextStyle(fontSize: 13.0, color: Colors.black87, fontWeight: FontWeight.w100),
              padding: EdgeInsets.only(left: 26.0, right: 26.0),
              child: new Text(v),
              constraints: BoxConstraints(minHeight: 28.0, minWidth: 50.0),
              onPressed: () {})
          );
        }).toList(),
      ),
    );
  }

  final double imgH = 165.0;
  final Color cRed = Color(0xffe20000);

  Widget _buildShopGrid() {
    return new SliverGrid(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200.0,
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
        childAspectRatio: 200 / 265,
      ),
      delegate: new SliverChildBuilderDelegate(
         (BuildContext context, int index) {

           int vi = index % _ImgList.length;

           return new Container(
             color: Color(0xffe2e2e2),
             child: new Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: <Widget>[
                 new Container(
                   color: Colors.white,
                   child: imgViews[vi],
                 ),
                 Padding(padding: EdgeInsets.fromLTRB(4.0, 0.0, 4.0, 0.0), child: Text("商品标题 $index", overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.w300))),

                 Row(
                   children: <Widget>[
                     SizedBox(width: 4.0),
                     Expanded(child: Text("淘宝价 9.90", style: TextStyle(color: Color(0xff888888), fontSize: 11.0, decoration: TextDecoration.lineThrough))),
                     Text("已售 190 件", style: TextStyle(color: Color(0xff888888), fontSize: 11.0)),
                     SizedBox(width: 4.0),
                   ],
                 ),

                 SizedBox(height: 8.0),

                 Row(
                   children: <Widget>[
                     SizedBox(width: 4.0),
                     Container(
                       padding: EdgeInsets.only(left: 6.0, right: 4.0),
                       child:  Text("券", style: TextStyle(fontSize: 12.0, color: Colors.white)),
                       constraints: BoxConstraints(maxHeight: 20.0),
                       decoration: ShapeDecoration(
                         color: cRed,
                         shape: RoundedRectangleBorder(
                           side: BorderSide(width: 1.0, color: cRed),
                           borderRadius: BorderRadius.only(topLeft: Radius.circular(5.0), bottomLeft: Radius.circular(5.0)),
                         ),
                       ),
                     ),
                     Container(
                       constraints: BoxConstraints(maxHeight: 20.0),
                       padding: EdgeInsets.only(left: 5.0, right: 4.0),
                       child:  Text("3元", style: TextStyle(fontSize: 12.0, color: cRed)),
                       decoration: ShapeDecoration(
                         shape: RoundedRectangleBorder(
                           side: BorderSide(width: 1.0, color: cRed),
                           borderRadius: BorderRadius.only(topRight: Radius.circular(5.0), bottomRight: Radius.circular(5.0)),
                         ),
                       ),
                     ),

                     Expanded(
                       child: Container(
                         height: 16.0,
                         alignment: Alignment.bottomRight,
                         child: Text('¥', style: TextStyle(fontSize: 10.0, color: cRed)),
                       ),
                     ),

                     SizedBox(width: 4.0),
                     Text("6.99", style: TextStyle(fontSize: 16.0, color: cRed)),
                     SizedBox(width: 4.0),

                   ]
                 ),

               ],
             )
           );
         },
         childCount: 51,
         addAutomaticKeepAlives: true,
         addRepaintBoundaries: true,
       ),
    );
  }
}

class ShopPage {
  final String title;
  final int id;
  const ShopPage({this.title, this.id = -1});
}

const List<ShopPage> pageItems = const <ShopPage>[
  const ShopPage(title: '精选', id: 0),
  const ShopPage(title: '女装'),
  const ShopPage(title: '男装'),
  const ShopPage(title: '鞋包'),
  const ShopPage(title: '美妆'),
  const ShopPage(title: '母婴'),
  const ShopPage(title: '食品'),
  const ShopPage(title: '内衣'),
];