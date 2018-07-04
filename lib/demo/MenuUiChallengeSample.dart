import 'package:flutter/material.dart';
import 'package:flutter_demo/utils/common.dart';
import 'dart:math' as math;

class Task {
  final String name;
  final String category;
  final String time;
  final Color color;
  final bool completed;

  Task({this.name, this.category, this.time, this.color, this.completed});
}

List<Task> tasks = [
  new Task(
      name: "Catch up with Brian",
      category: "Mobile Project",
      time: "5pm",
      color: Colors.orange,
      completed: false),
  new Task(
      name: "Make new icons",
      category: "Web App",
      time: "3pm",
      color: Colors.cyan,
      completed: true),
  new Task(
      name: "Design explorations",
      category: "Company Website",
      time: "2pm",
      color: Colors.pink,
      completed: false),
  new Task(
      name: "Lunch with Mary",
      category: "Grill House",
      time: "12pm",
      color: Colors.cyan,
      completed: true),
  new Task(
      name: "Teem Meeting",
      category: "Hangouts",
      time: "10am",
      color: Colors.cyan,
      completed: true),
];

class MenuUiChallengeSample extends StatefulWidget {
  @override
  createState() => new MenuUiChallengeSampleState();
}

class MenuUiChallengeSampleState extends State<MenuUiChallengeSample> {
  static const double _imageHeight = 210.0;
  final GlobalKey<AnimatedListState> _listKey =
      new GlobalKey<AnimatedListState>();
  ListModel listModel;
  bool showOnlyCompleted = false;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Stack(
        children: <Widget>[
          _buildTimeline(),
          _buildImage(),
          _buildTopHeader(),
          _buildProfileRow(),
          _buildBottomPart(),
          _buildFab(),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    listModel = new ListModel(_listKey, tasks);
  }

  _buildImage() {
    return new ClipPath(
      clipper: new DialogonalClipper(),
      child: new Image.asset(
        'assets/images/birds.jpg',
        fit: BoxFit.fill,
        height: _imageHeight,
        width: double.infinity,
        colorBlendMode: BlendMode.srcOver,
        color: const Color(0xa5140a28),
      ),
    );
  }

  _buildTopHeader() {
    return new Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 32.0),
      child: new Row(
        children: <Widget>[
          new BackButton(color: Colors.white),
          new Expanded(
              child: new Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: new Text("Timeline",
                style: new TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w300)),
          )),
          new Material(
            color: Colors.transparent,
            child: new IconButton(
                padding: const EdgeInsets.all(0.0),
                icon: new Icon(Icons.linear_scale, color: Colors.white),
                onPressed: () {
                  //Tools.toast('click icon');

                  // 这里是显示一个弹出菜单
                  final RenderBox button = context.findRenderObject();
                  final RenderBox overlay = Overlay.of(context).context.findRenderObject();
                  final RelativeRect position = new RelativeRect.fromRect(
                    new Rect.fromPoints(
                      button.localToGlobal(button.size.topRight(const Offset(0.0, 50.0)), ancestor: overlay),
                      button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay),
                    ),
                    Offset.zero & overlay.size,
                  );
                  showMenu(context: context, position: position, items: _buildMenuItems(context))
                    .then<void>((value) {
                    if (value == "返回")
                      Navigator.pop(context);
                  });

                }),
          ),
        ],
      ),
    );
  }

  _buildMenuItems(BuildContext context) {
    List<PopupMenuItem<String>> list = new List<PopupMenuItem<String>>();
    list.add(new PopupMenuItem<String>(
      value: "返回",
      child: new Text("返回"),
    ));
    return list;
  }

  _buildProfileRow() {
    return new Padding(
      padding: const EdgeInsets.only(left: 16.0, top: _imageHeight / 2.5),
      child: new Row(
        children: <Widget>[
          new CircleAvatar(
            minRadius: 28.0,
            maxRadius: 28.0,
            backgroundColor: Colors.grey,
            child: new Icon(
              Icons.face,
              size: 48.0,
              color: Colors.white,
            ),
          ),
          new Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new Text('YangYxd',
                    style: new TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 26.0,
                        color: Colors.white)),
                new Text(
                  'Product designer',
                  style: new TextStyle(
                      fontSize: 14.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w300),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  _buildBottomPart() {
    return new Padding(
      padding: const EdgeInsets.only(top: _imageHeight),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildMyTasksHeader(),
          _buildTasksList(),
        ],
      ),
    );
  }

  _buildMyTasksHeader() {
    return new Padding(
      padding: new EdgeInsets.only(left: 64.0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Text(
            '我的任务',
            style: new TextStyle(fontSize: 34.0),
          ),
          new Text(
            'FEBRUARY 8, 2015',
            style: new TextStyle(color: Colors.grey, fontSize: 12.0),
          ),
        ],
      ),
    );
  }

  _buildTasksList() {
    return new Expanded(
      child: new AnimatedList(
        initialItemCount: tasks.length,
        key: _listKey,
        itemBuilder: (context, index, animation) {
          return new TaskRow(
            task: listModel[index],
            animation: animation,
          );
        },
      ),
    );
  }

  Widget _buildTimeline() {
    return new Positioned(
      top: 0.0,
      bottom: 0.0,
      left: 32.0,
      child: new Container(
        width: 1.0,
        color: Colors.grey[300],
      ),
    );
  }

  _buildFab() {
    return new Positioned(
      top: _imageHeight - 100.0,
      right: -40.0,
      child: new AnimatedFab(
        onClick: _changeFilterState,
      ),
    );
  }

  void _changeFilterState() {
    showOnlyCompleted = !showOnlyCompleted;
    tasks.where((task) => !task.completed).forEach((task) {
      if (showOnlyCompleted) {
        listModel.removeAt(listModel.indexOf(task));
      } else {
        listModel.insert(tasks.indexOf(task), task);
      }
    });
  }
}

class DialogonalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = new Path();
    path.lineTo(0.0, size.height - 60.0);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class TaskRow extends StatelessWidget {
  final Animation<double> animation;
  final Task task;
  final double dotSize = 12.0;

  const TaskRow({Key key, this.task, this.animation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new FadeTransition(
      opacity: animation,
      child: new SizeTransition(
        sizeFactor: animation,
        child: _buildChild(),
      ),
    );
  }

  _buildChild() {
    return new Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: new Row(
        children: <Widget>[
          new Padding(
            padding: new EdgeInsets.symmetric(horizontal: 32.0 - dotSize / 2),
            child: new Container(
              height: dotSize,
              width: dotSize,
              decoration:
                  new BoxDecoration(shape: BoxShape.circle, color: task.color),
            ),
          ),
          new Expanded(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(
                  task.name,
                  style: new TextStyle(fontSize: 18.0),
                ),
                new Text(
                  task.category,
                  style: new TextStyle(fontSize: 12.0, color: Colors.grey),
                )
              ],
            ),
          ),
          new Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: new Text(
              task.time,
              style: new TextStyle(fontSize: 12.0, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}

class ListModel {
  ListModel(this.listKey, items) : this.items = new List.of(items);

  final GlobalKey<AnimatedListState> listKey;
  final List<Task> items;

  AnimatedListState get _animatedList => listKey.currentState;

  void insert(int index, Task item) {
    items.insert(index, item);
    _animatedList.insertItem(index, duration: new Duration(milliseconds: 150));
  }

  Task removeAt(int index) {
    final Task removedItem = items.removeAt(index);
    if (removedItem != null) {
      _animatedList.removeItem(
          index,
          (context, animation) => new TaskRow(
                task: removedItem,
                animation: animation,
              ),
          duration: new Duration(
              milliseconds: (150 + 150 * (index / length)).toInt()));
    }
    return removedItem;
  }

  int get length => items.length;

  Task operator [](int index) => items[index];

  int indexOf(Task item) => items.indexOf(item);
}

class AnimatedFab extends StatefulWidget {
  final VoidCallback onClick;

  const AnimatedFab({Key key, this.onClick}) : super(key: key);

  @override
  _AnimatedFabState createState() => new _AnimatedFabState();
}

class _AnimatedFabState extends State<AnimatedFab> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<Color> _colorAnimation;
  final double expandedSize = 180.0;
  final double hiddenSize = 20.0;

  @override
  void initState() {
    super.initState();
    _animationController = new AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    _colorAnimation = new ColorTween(begin: Colors.pink, end: Colors.pink[800])
        .animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new SizedBox(
      child: new AnimatedBuilder(
          animation: _animationController,
          builder: (BuildContext context, Widget child) {
            return new Stack(
              alignment: Alignment.center,
              children: <Widget>[
                _buildExpandedBackground(),
                _buildOption(Icons.check_circle, 0.0),
                _buildOption(Icons.flash_on, -math.pi / 3),
                _buildOption(Icons.access_time, -2 * math.pi / 3),
                _buildOption(Icons.error_outline, math.pi),
                _buildFabCore()
              ],
            );
          }),
      width: expandedSize,
      height: expandedSize,
    );
  }

  Widget _buildExpandedBackground() {
    double size = hiddenSize + (expandedSize - hiddenSize) * _animationController.value;
    return new Container(
      height: size,
      width: size,
      decoration: new BoxDecoration(shape: BoxShape.circle, color: Colors.pink),
    );
  }

  Widget _buildFabCore() {
    double scaleFactor = 2 * (_animationController.value - 0.5).abs();
    return new FloatingActionButton(
      onPressed: _onFabTap,
      child: new Transform(
        alignment: Alignment.center,
        transform: new Matrix4.identity()..scale(1.0, scaleFactor),
        child: new Icon(
          _animationController.value > 0.5 ? Icons.close : Icons.filter_list,
          color: Colors.white,
          size: 26.0,
        ),
      ),
      backgroundColor: _colorAnimation.value,
    );
  }

  static const _iconsSize = 26.0;

  Widget _buildOption(IconData icon, double angle) {
    double iconSize = 0.0;
    if (_animationController.value > 0.8) {
      iconSize = _iconsSize * (_animationController.value - 0.8) * 5;
    }
    return new Transform.rotate(
      angle: angle,
      child: new Align(
        alignment: Alignment.topCenter,
        child: new Padding(
          padding: new EdgeInsets.only(top: 8.0),
          child: new IconButton(
            onPressed: (iconSize >= _iconsSize - 1) ? _onIconClick : null,
            icon: new Transform.rotate(
              angle: -angle,
              child: new Icon(
                icon,
                color: Colors.white,
              ),
            ),
            iconSize: iconSize,
            alignment: Alignment.center,
            padding: new EdgeInsets.all(0.0),
          ),
        ),
      ),
    );
  }

  _onFabTap() {
    if (_animationController.isDismissed) {
      open();
    } else {
      close();
    }
  }

  open() {
    if (_animationController.isDismissed) {
      _animationController.forward();
    }
  }

  close() {
    if (_animationController.isCompleted) {
      _animationController.reverse();
    }
  }

  _onIconClick() {
    widget.onClick();
    close();
  }

}