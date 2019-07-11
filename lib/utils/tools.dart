import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:qr_reader/qr_reader.dart';

import 'view/DialogEx.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as Http;
import 'package:http_parser/http_parser.dart';

/**
 * 工具类
 * coypright by YangYxd 2018
 */
class Tools {
  static String _documentsPath = null;

  /**
   * 共有状态数据
   */
  static final SharedState = new PageState(null, name: "__sharedstate");

  /**
   * 显示Toast消息
   */
  static void toast(String msg,
      {Toast toastLength, int timeInSecForIos, ToastGravity gravity}) {
    Fluttertoast.showToast(
        msg: msg,
        timeInSecForIos: timeInSecForIos,
        gravity: gravity,
        toastLength: toastLength);
  }

  /** 返回当前时间戳 */
  static int currentTimeMillis() {
    return new DateTime.now().millisecondsSinceEpoch;
  }

  /** 复制到剪粘板 */
  static copyToClipboard(final String text) {
    if (text == null) return;
    Clipboard.setData(new ClipboardData(text: text));
  }

  /// 隐藏软键盘
  static void hideSoftKey() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  /// 显示软键盘
  static void showSoftKey() {
    SystemChannels.textInput.invokeMethod('TextInput.show');
  }

  static const RollupSize_Units = ["GB", "MB", "KB", "B"];
  /** 返回文件大小字符串 */
  static String getRollupSize(int size) {
    int idx = 3;
    int r1 = 0;
    String result = "";
    while (idx >= 0) {
      int s1 = size % 1024;
      size = size >> 10;
      if (size == 0 || idx == 0) {
        r1 = (r1 * 100) ~/ 1024;
        if (r1 > 0) {
          if (r1 >= 10)
            result = "$s1.$r1${RollupSize_Units[idx]}";
          else
            result = "$s1.0$r1${RollupSize_Units[idx]}";
        } else
          result = s1.toString() + RollupSize_Units[idx];
        break;
      }
      r1 = s1;
      idx--;
    }
    return result;
  }

  /** 路径分隔符 */
  static String get pathSeparator => Platform.pathSeparator;

  /**
   * 获取文档目录
   */
  static Future<String> getDocumentsPath() async {
    if (_documentsPath == null)
      _documentsPath = (await getApplicationDocumentsDirectory()).path;
    return _documentsPath;
  }

  static String getDocumentsPathSync() {
    if (_documentsPath == null) getDocumentsPath();
    return _documentsPath;
  }

  /**
   * 获取下载目录
   */
  static Future<String> getDownloadsPath() async {
    if (Platform.isIOS)
      return (await getApplicationDocumentsDirectory()).path;
    else {
      if (_downloadPath == null) {
        _downloadPath = (await getExternalStorageDirectory()).path;
        if (!await existPath(_downloadPath))
          _downloadPath = (await getTemporaryDirectory()).path;
      }
      print("downloadPath: $_downloadPath");
      return _downloadPath;
    }
  }

  static String _downloadPath = null;

  /**
   * 检测文件是否存在
   */
  static bool existFile(final String file) {
    return new File(file).existsSync();
  }

  /**
   * 创建目录
   */
  static Future<bool> createPath(final String path) async {
    return (await new Directory(path).create(recursive: true)).exists();
  }

  /**
   * 检测路径是否存在
   */
  static bool existPath(final String _path) {
    return new Directory(_path).existsSync();
  }

  /**
   * 提取文件路径, 结尾包含路径分隔符
   */
  static String getFilePath(final String file) {
    return path.dirname(file) + Platform.pathSeparator;
  }

  /**
   * 提取文件名（不包含路径和扩展名）
   */
  static String getFileName(final String file) {
    return path.basenameWithoutExtension(file);
  }

  /**
   * 提取文件扩展名
   */
  static String getFileExt(final String file) {
    return path.extension(file);
  }

  /**
   * 提取文件名（包含扩展名）
   */
  static String getFileFullName(final String file) {
    return path.basename(file);
  }

  /**
   * 创建文件, 如果目录不存在会尝试创建目录
   */
  static Future<File> createFile(final String file) async {
    try {
      String path = Tools.getFilePath(file);
      if (!await existPath(path)) {
        if (!await createPath(path)) {
          return null;
        }
      }
      return await new File(file).create(recursive: true);
    } catch (e) {
      print(e);
      return null;
    }
  }

  /**
   * 删除文件
   */
  static Future<bool> deleteFile(final String file) async {
    try {
      await new File(file).delete(recursive: true);
      return true;
    } on Exception catch (e) {
      print(e);
      return false;
    }
  }

  static String check(String src) {
    if (src == null) return "";
    return src;
  }

  /** 日期转为字符串 */
  static String dateToStr(DateTime v) {
    return "${v.year}-${v.month}-${v.day}";
  }

  static String _twoDigits(int n) {
    if (n >= 10) return "${n}";
    return "0${n}";
  }

  /** 日期时间转化为字符串  */
  static String dateTimeToStr(DateTime v, [bool cn = false]) {
    if (cn)
      return "${v.month}月${v.day}日 ${_twoDigits(v.hour)}:${_twoDigits(v.minute)}";
    else
      return "${v.year}-${v.month}-${v.day} ${_twoDigits(v.hour)}:${_twoDigits(v.minute)}:${_twoDigits(v.second)}";
  }

  /** 字符串转为日期时间 */
  static DateTime strToDateTime(String str, [DateTime defaultValue = null]) {
    try {
      return DateTime.parse(str);
    } catch (e) {
      return defaultValue;
    }
  }

  /** 字符串转为整数 */
  static int strToInt(String str, [int defaultValue = 0]) {
    try {
      return int.parse(str);
    } catch (e) {
      return defaultValue;
    }
  }

  /** 开始一个页面 */
  static void startPage(BuildContext context, StatefulWidget page) {
    if (page == null) return;
    Navigator.push(context, new MyCustomRoute(builder: (_) => page));
  }

  /** 开始一个页面，并等待结束 */
  static Future<Object> startPageWait(
      BuildContext context, StatefulWidget page) async {
    if (page == null) return null;
    return await Navigator.push(
        context, new MyCustomRoute(builder: (_) => page));
  }

  /** 显示底部模态框 */
  static Future<T> showModalBottomSheet<T>({
    @required BuildContext context,
    @required WidgetBuilderEx builder,
    double maxHeight = -1.0,
    double minHeight = 0.0,
    double maxWidth = -1.0,
    bool clickPop = true,
  }) {
    assert(context != null);
    assert(builder != null);
    return Navigator.push(
        context,
        new _ModalBottomSheetRoute<T>(
          builder: builder,
          theme: Theme.of(context, shadowThemeOnly: true),
          maxHeight: maxHeight,
          maxWidth: maxWidth,
          minHeight: minHeight,
          clickPop: clickPop,
          barrierLabel:
              MaterialLocalizations.of(context).modalBarrierDismissLabel,
        ));
  }

  static Map parseJson(final String data) {
    return JsonDecoder().convert(data);
  }

  static List parseJsonAsList(final String data) {
    return JsonDecoder().convert(data);
  }

  static String jsonToString(final Map data) {
    return JsonEncoder().convert(data);
  }

  /** 检测字符串是否为空 */
  static bool strIsEmpty(final String v) {
    return (v == null) || (v.length == 0);
  }

  /** 连接字符串 */
  static String linkStr([final String a, final String b, final String c]) {
    return check(a) + check(b) + check(c);
  }

  /** 字符串查询：没找到或原串为null返回 -1 */
  static int strPos(final String src, final String pattern,
      [int start = 0, bool ignoreCase = false]) {
    if (src == null || pattern == null) return -1;
    if (ignoreCase)
      return src.toLowerCase().indexOf(pattern.toLowerCase(), start);
    return src.indexOf(pattern, start);
  }

  static const List<String> STimeUtils = ["天", "小时", "分钟", "刚刚"];

  /** 返回指定时间对于当前时间相差的时间字符串（如：1小时前，5天前） */
  static String timeBetween(DateTime start,
      [String suffix = "",
      DateTime curTime = null,
      List<String> utils = STimeUtils]) {
    if (start == null) return "";
    int cur = (curTime == null)
        ? DateTime.now().millisecondsSinceEpoch
        : curTime.millisecondsSinceEpoch;
    int v = cur - start.millisecondsSinceEpoch;
    if (v ~/ 1000 < 60) return utils[3];
    if (v ~/ 1000 < 3600) return "${v ~/ (1000 * 60)}${utils[2]}$suffix";
    if (v ~/ 1000 < 86400) return "${v ~/ (1000 * 3600)}${utils[1]}$suffix";
    v = v ~/ (1000 * 86400);
    if (v > 60) return Tools.dateToStr(start);
    return "$v${utils[0]}$suffix";
  }

  /** 返回两个日期相差的天数 */
  static int daysBetween(DateTime a, DateTime b, [bool ignoreTime = false]) {
    if (ignoreTime) {
      int v = a.millisecondsSinceEpoch ~/ 86400000 -
          b.millisecondsSinceEpoch ~/ 86400000;
      if (v < 0) return -v;
      return v;
    } else {
      int v = a.millisecondsSinceEpoch - b.millisecondsSinceEpoch;
      if (v < 0) v = -v;
      return v ~/ 86400000;
    }
  }

  /// 返回指定日期偏移指定天数后的日期
  static DateTime dateOffset(DateTime value, int offsetDays) {
    return value.add(new Duration(days: offsetDays));
  }

  /** 获取屏幕宽度 */
  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  /** 获取屏幕高度 */
  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  /** 获取系统状态栏高度 */
  static double getSysStatsHeight(BuildContext context) {
    return MediaQuery.of(context).padding.top;
  }

  /** 扫描二维码  */
  static Future<String> scanQRCode() async {
    try {
      return new QRCodeReader()
          .setAutoFocusIntervalInMs(200)
          .setForceAutoFocus(true)
          .setTorchEnabled(true)
          .setHandlePermissions(true)
          .setExecuteAfterPermissionGranted(true)
          .scan();
    } catch (e) {
      Tools.toast("未知错误：${e.toString()}");
      return null;
    }
  }

  static Map _makeHttpHeaders(
      [String contentType,
      String accept,
      String token,
      String XRequestWith,
      String XMethodOverride]) {
    Map headers = new Map<String, String>();
    int i = 0;

    if (!strIsEmpty(contentType)) {
      i++;
      headers["Content-Type"] = contentType;
    }

    if (!strIsEmpty(accept)) {
      i++;
      headers["Accept"] = accept;
    }

    if (!strIsEmpty(token)) {
      i++;
      headers["Authorization"] = "bearer " + token;
    }

    if (!strIsEmpty(XRequestWith)) {
      i++;
      headers["X-Requested-With"] = XRequestWith;
    }

    if (!strIsEmpty(XMethodOverride)) {
      i++;
      headers["X-HTTP-Method-Override"] = XMethodOverride;
    }

    if (i == 0) return null;
    // print(headers.toString());
    return headers;
  }

  static const String SContentType_JSON = "application/json";
  static const String SContentType_Multipart = "multipart/form-data";

  /** HTTP POST 数据 */
  static Future<MsgResponse> httpPost(final String url,
      {final String data,
      String contentType = SContentType_JSON,
      String accept,
      String token,
      String XMethodOverride}) async {
    try {
      Http.Response response = await Http.post(url,
          body: data,
          headers: _makeHttpHeaders(
              contentType, accept, token, null, XMethodOverride));
      if (response.statusCode == 200) {
        return new MsgResponse(0, response.body);
      } else
        return new MsgResponse(response.statusCode, response.body);
    } catch (e) {
      return new MsgResponse(699, null, e.toString());
    }
  }

  /** HTTP GET 数据 */
  static Future<MsgResponse> httpGet(final String url,
      {String contentType = SContentType_JSON,
      String accept,
      String token,
      String XMethodOverride}) async {
    try {
      Http.Response response = await Http.get(url,
          headers: _makeHttpHeaders(
              contentType, accept, token, null, XMethodOverride));
      if (response.statusCode == 200) {
        return new MsgResponse(0, response.body);
      } else
        return new MsgResponse(response.statusCode, response.body);
    } catch (e) {
      return new MsgResponse(699, null, e.toString());
    }
  }

  /** HTTP POST 上传文件 */
  static Future<MsgResponse> httpUploadFile(
    final String url,
    final File file, {
    String accept = "*/*",
    String token,
    String field = "picture-upload",
    String file_contentType, // 默认为null，自动获取
  }) async {
    try {
      List<int> bytes = await file.readAsBytes();
      return await httpUploadFileData(url, bytes,
          accept: accept,
          token: token,
          field: field,
          file_contentType: file_contentType,
          filename: file.path);
    } catch (e) {
      return new MsgResponse(699, null, e.toString());
    }
  }

  /** HTTP POST 上传文件 */
  static Future<MsgResponse> httpUploadFileData(
    final String url,
    final List<int> filedata, {
    String accept = "*/*",
    String token,
    String field = "picture-upload",
    String file_contentType, // 默认为null，自动获取
    String filename,
  }) async {
    try {
      List<int> bytes = filedata;
      var boundary = _boundaryString();
      String contentType = 'multipart/form-data; boundary=$boundary';
      Map headers =
          _makeHttpHeaders(contentType, accept, token); //, "XMLHttpRequest");

      // 构造文件字段数据
      String data =
          '--$boundary\r\nContent-Disposition: form-data; name="$field"; ' +
              'filename="${getFileFullName(filename)}"\r\nContent-Type: ' +
              '${(file_contentType == null) ? getMediaType(getFileExt(filename).toLowerCase()): file_contentType}\r\n\r\n';
      var controller = new StreamController<List<int>>(sync: true);
      controller.add(data.codeUnits);
      controller.add(bytes);
      controller.add("\r\n--$boundary--\r\n".codeUnits);

      controller.close();
      bytes = await new Http.ByteStream(controller.stream).toBytes();
      //print("bytes: \r\n" + UTF8.decode(bytes, allowMalformed: true));

      Http.Response response =
          await Http.post(url, headers: headers, body: bytes);
      if (response.statusCode == 200) {
        return new MsgResponse(0, response.body);
      } else
        return new MsgResponse(response.statusCode, response.body);
    } catch (e) {
      return new MsgResponse(699, null, e.toString());
    }
  }

  /** 生成随机字符串 */
  static String randomStr(
      [int len = 8, List<int> chars = _BOUNDARY_CHARACTERS]) {
    var list = new List<int>.generate(
        len, (index) => chars[_random.nextInt(chars.length)],
        growable: false);
    return new String.fromCharCodes(list);
  }

  static const List<int> _BOUNDARY_CHARACTERS = const <int>[
    0x30,
    0x31,
    0x32,
    0x33,
    0x34,
    0x35,
    0x36,
    0x37,
    0x38,
    0x39,
    0x61,
    0x62,
    0x63,
    0x64,
    0x65,
    0x66,
    0x67,
    0x68,
    0x69,
    0x6A,
    0x6B,
    0x6C,
    0x6D,
    0x6E,
    0x6F,
    0x70,
    0x71,
    0x72,
    0x73,
    0x74,
    0x75,
    0x76,
    0x77,
    0x78,
    0x79,
    0x7A,
    0x41,
    0x42,
    0x43,
    0x44,
    0x45,
    0x46,
    0x47,
    0x48,
    0x49,
    0x4A,
    0x4B,
    0x4C,
    0x4D,
    0x4E,
    0x4F,
    0x50,
    0x51,
    0x52,
    0x53,
    0x54,
    0x55,
    0x56,
    0x57,
    0x58,
    0x59,
    0x5A
  ];
  static const int _BOUNDARY_LENGTH = 48;
  static final Random _random = new Random();
  static String _boundaryString() {
    var prefix = "---DartFormBoundary";
    var list = new List<int>.generate(
        _BOUNDARY_LENGTH - prefix.length,
        (index) =>
            _BOUNDARY_CHARACTERS[_random.nextInt(_BOUNDARY_CHARACTERS.length)],
        growable: false);
    return "$prefix${new String.fromCharCodes(list)}";
  }

  static MediaType getMediaType(final String fileExt) {
    switch (fileExt) {
      case ".jpg":
      case ".jpeg":
      case ".jpe":
        return new MediaType("image", "jpeg");
      case ".png":
        return new MediaType("image", "png");
      case ".bmp":
        return new MediaType("image", "bmp");
      case ".gif":
        return new MediaType("image", "gif");
      case ".json":
        return new MediaType("application", "json");
      case ".svg":
      case ".svgz":
        return new MediaType("image", "svg+xml");
      case ".mp3":
        return new MediaType("audio", "mpeg");
      case ".mp4":
        return new MediaType("video", "mp4");
      case ".htm":
      case ".html":
        return new MediaType("text", "html");
      case ".css":
        return new MediaType("text", "css");
      case ".csv":
        return new MediaType("text", "csv");
      case ".txt":
      case ".text":
      case ".conf":
      case ".def":
      case ".log":
      case ".in":
        return new MediaType("text", "plain");
    }
    return null;
  }
}

/**
 * 请求响应数据
 */
class MsgResponse {
  int code; // 状态代码，0 表示没有错误
  Object data; // 数据内容，一般为字符串
  String errmsg; // 错误消息
  MsgResponse([this.code = 0, this.data = null, this.errmsg = ""]);
}

class MyCustomRoute<T> extends MaterialPageRoute<T> {
  MyCustomRoute({WidgetBuilder builder, RouteSettings settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (settings.isInitialRoute) return child;
    return new FadeTransition(opacity: animation, child: child);
  }
}

/**
 * 页面状态
 */
class PageState {
  final Widget widget;
  final String name;
  String _file = "";
  Map data = null;
  final VoidCallback onInited;

  PageState(
    this.widget, {
    this.name,
    this.onInited,
    isInit = true,
  }) {
    initState(isInit);
  }

  void getFileName() async {
    _file = await Tools.getDocumentsPath();
    if (this.name != null) {
      _file = _file + Platform.pathSeparator + this.name + ".data";
    } else if (this.widget != null) {
      _file = _file +
          Platform.pathSeparator +
          widget.runtimeType.toString() +
          ".data";
    }
    print(_file);
  }

  void initState(bool isInit) async {
    await getFileName();
    if (isInit) await _initState();
    if (onInited != null) {
      onInited();
    }
  }

  /**
   * 保存状态
   */
  void saveState() async {
    await _saveState();
  }

  void _initState() async {
    if (data != null) data.clear();
    try {
      var filedata = await new File(_file).readAsStringSync();
      //print(filedata);
      data = jsonDecode(filedata);
    } on Exception catch (e) {
      //print(e);
      data = new Map();
    }
  }

  _saveState() async {
    if (data == null) return;
    File f = await Tools.createFile(_file);
    if (f == null) {
      print('save state field.');
      return;
    }
    var v = jsonEncode(data);
    print(v);
    if (v != "") await f.writeAsString(v);
    print('save ok. ($_file)');
  }

  Object getValue(final Object key, [Object defaultValue = null]) {
    if (data == null || key == null || !data.containsKey(key))
      return defaultValue;
    return data[key];
  }

  void putValue(final Object key, final Object value) {
    if (data == null) data = new Map();
    data[key] = value;
  }

  int getInt(final Object key, [int defaultValue = 0]) {
    return getValue(key, defaultValue);
  }

  String getString(final Object key, [String defaultValue = ""]) {
    return getValue(key, defaultValue);
  }

  double getFloat(final Object key, [double defaultValue = 0.0]) {
    return getValue(key, defaultValue);
  }

  DateTime getDateTime(final Object key, [DateTime defaultValue = null]) {
    return getValue(key, defaultValue);
  }

  bool getBool(final Object key, [bool defaultValue = false]) {
    return getValue(key, defaultValue);
  }

  remove(final Object key) {
    if (data == null || key == null || !data.containsKey(key)) return;
    data.remove(key);
  }
}

abstract class StateEx<T extends StatefulWidget> extends State<T> {
  static final Map<String, PageState> _stateMap = new Map<String, PageState>();
  static final List<StateEx> _stateList = new List<StateEx>();

  PageState get state => getStateData();

  /** 状态数据加载成功 */
  void onInited() {}

  void initStateData() {
    getStateData();
  }

  /** 发送通知 */
  sendNotify(int msgId, {String msg = null, Map data = null}) {
    for (int i = _stateList.length - 1; i >= 0; i--) {
      if (_stateList[i].mounted && _stateList[i].processNotify(this, msgId, msg, data)) return;
    }
  }

  showDialogWait() async {
    sendNotify(7000001);
  }

  hideDialogWait() async {
    sendNotify(7000002);
  }

  /** 处理通知, 返回 true 时通知不再向下传递 */
  @protected
  bool processNotify(StateEx sender, int msgId, String msg, Map data) {
    return false;
  }

  @override
  void initState() {
    _stateList.add(this);
    print("initState (${getStateKey()}): ${_stateList.length}");
    super.initState();
  }

  void dispose() {
    if (_stateList.remove(this))
      print("dispose (${getStateKey()}): ${_stateList.length}");
    super.dispose();
  }

  @protected
  String getStateKey() {
    return this.runtimeType.toString();
  }

  PageState getStateData() {
    var key = getStateKey();
    //print("key: $key");
    var v = _stateMap[getStateKey()];
    if (v == null) {
      v = new PageState(null, name: key, onInited: () {
        setState(() {
          onInited();
        });
      });
      _stateMap[key] = v;
    }
    return v;
  }
}

/************************************************
 *
 *   底部模态框 （增加更多选项）
 *
************************************************/

const Duration _kBottomSheetDuration = const Duration(milliseconds: 200);
const double _kMinFlingVelocity = 700.0;
const double _kCloseProgressThreshold = 0.5;

typedef Widget WidgetBuilderEx(BuildContext context, bool isWait);

class _ModalBottomSheetRoute<T> extends PopupRoute<T> {
  _ModalBottomSheetRoute({
    this.builder,
    this.theme,
    this.barrierLabel,
    this.maxHeight = -1.0,
    this.maxWidth = -1.0,
    this.minHeight = 0.0,
    this.clickPop = true,
    RouteSettings settings,
  }) : super(settings: settings);

  final WidgetBuilderEx builder;
  final ThemeData theme;
  final double maxHeight, minHeight;
  final double maxWidth;
  final bool clickPop;

  @override
  Duration get transitionDuration => _kBottomSheetDuration;

  @override
  bool get barrierDismissible => true;

  @override
  final String barrierLabel;

  @override
  Color get barrierColor => Colors.black54;

  AnimationController _animationController;

  @override
  AnimationController createAnimationController() {
    assert(_animationController == null);
    _animationController =
        BottomSheet.createAnimationController(navigator.overlay);
    return _animationController;
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    // By definition, the bottom sheet is aligned to the bottom of the page
    // and isn't exposed to the top padding of the MediaQuery.
    Widget bottomSheet = new MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: new _ModalBottomSheet<T>(route: this),
    );
    if (theme != null) bottomSheet = new Theme(data: theme, child: bottomSheet);
    return bottomSheet;
  }
}

class _ModalBottomSheet<T> extends StatefulWidget {
  _ModalBottomSheet({Key key, this.route}) : super(key: key);

  final _ModalBottomSheetRoute<T> route;
  bool isWait = false;

  @override
  _ModalBottomSheetState<T> createState() => new _ModalBottomSheetState<T>();
}

class _ModalBottomSheetState<T> extends StateEx<_ModalBottomSheet<T>> {
  @override
  bool processNotify(
      StateEx<StatefulWidget> sender, int msgId, String msg, Map data) {
    if (msgId == 7000001) {
      setState(() {
        widget.isWait = true;
      });
      return true;
    } else if (msgId == 7000002) {
      if (widget != null)
        setState(() {
          widget.isWait = false;
        });
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
        onTap: widget.route.clickPop ? () => Navigator.pop(context) : null,
        child: new AnimatedBuilder(
            animation: widget.route.animation,
            builder: (BuildContext context, Widget child) {
              return new ClipRect(
                  child: new CustomSingleChildLayout(
                delegate: new _ModalBottomSheetLayout(
                    widget.route.animation.value, widget.route),
                child: new BottomSheet(
                    animationController: widget.route._animationController,
                    onClosing: () => Navigator.pop(context),
                    builder: (BuildContext context) {
                      return widget.route.builder(context, widget.isWait);
                    }),
              ));
            }));
  }
}

class _ModalBottomSheetLayout extends SingleChildLayoutDelegate {
  _ModalBottomSheetLayout(this.progress, this.route);

  final _ModalBottomSheetRoute route;
  final double progress;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    final double w =
        (route.maxWidth == -1.0) ? constraints.maxWidth : route.maxWidth;
    final double h = (route.maxHeight == -1.0)
        ? constraints.maxHeight * 9.0 / 12.0
        : route.maxHeight;
    return new BoxConstraints(
      minWidth: w,
      maxWidth: w,
      minHeight: route.minHeight,
      maxHeight: h,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    return new Offset(0.0, size.height - childSize.height * progress);
  }

  @override
  bool shouldRelayout(_ModalBottomSheetLayout oldDelegate) {
    return progress != oldDelegate.progress;
  }
}

// ************************************************************************
