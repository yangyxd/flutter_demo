import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

class RandomWords extends StatefulWidget {
  final String title;
  RandomWords({this.title});

  @override
  createState() => new RandomWordsState(title: this.title);
}

class RandomWordsState extends State<RandomWords> {
  // 建议的单词对
  final _suggestions = <WordPair>[];

  // 字体大小
  final _biggerFont = const TextStyle(fontSize: 18.0);

  // 已收藏的单词
  final _saved = new Set<WordPair>();

  final String title;

  RandomWordsState({this.title});

  @override
  Widget build(BuildContext context) {
    //final wordPair = new WordPair.random();
    //return new Text(wordPair.asPascalCase);
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(title),
        actions: <Widget>[
          // 添加一个菜单按钮，点击切换到收藏列表
          new IconButton(
              icon: new Icon(Icons.check_box), onPressed: _closeSelf),
          new IconButton(icon: new Icon(Icons.list), onPressed: _pushSaved),
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  Widget _buildSuggestions() {
    return new ListView.builder(
        padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
        // 对于每个建议的单词对都会调用一次itemBuilder，然后将单词对添加到ListTile行中
        // 在偶数行，该函数会为单词对添加一个ListTile row.
        // 在奇数行，该行书湖添加一个分割线widget，来分隔相邻的词对。
        // 注意，在小屏幕上，分割线看起来可能比较吃力。
        itemBuilder: (context, i) {
          // 在每一列之前，添加一个1像素高的分隔线widget
          if (i.isOdd)
            return new Divider(
                //color: new Color(0xff2300db),
                );
          // 语法 "i ~/ 2" 表示i除以2，但返回值是整形（向下取整），比如i为：1, 2, 3, 4, 5
          // 时，结果为0, 1, 1, 2, 2， 这可以计算出ListView中减去分隔线后的实际单词对数量
          final index = i ~/ 2;
          // 如果是建议列表中最后一个单词对
          if (index >= _suggestions.length) {
            // 接着再生成10个单词对，然后添加到建议列表
            _suggestions.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_suggestions[index]);
        });
  }

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);

    return new ListTile(
        title: new Text(
          pair.asPascalCase,
          style: _biggerFont,
        ),
        trailing: new Icon(
          alreadySaved ? Icons.favorite : Icons.favorite_border,
          color: alreadySaved ? Colors.red : null,
        ),
        onTap: () {
          // 在Flutter的响应式风格的框架中，调用setState() 会为State对象触发build()方法，从而导致对UI的更新
          setState(() {
            if (alreadySaved) {
              _saved.remove(pair);
            } else {
              _saved.add(pair);
            }
          });
        });
  }

  void _closeSelf() {
    Navigator.pop(context, _saved.length.toString());
  }

  // 切换到收藏列表页面
  void _pushSaved() {
    var divided;
    var tiles;

    final MaterialPageRoute _page = new MaterialPageRoute(
      builder: (context) {
        tiles = _saved.map(
          (pair) {
            return new ListTile(
              title: new Text(
                pair.asPascalCase,
                style: _biggerFont,
              ),
//              trailing: new Icon(
//                Icons.clear,
//              ),
              onTap: () {
//                setState(() {
//                  _saved.remove(pair);
//                  Navigator.pop(context);
//                });
              },
            );
          },
        );

        // 每个ListTile之间添加1像素的分割线并在tiles中存放最终的列表项
        divided = ListTile
            .divideTiles(
              context: context,
              tiles: tiles,
            )
            .toList();

        return new Scaffold(
          appBar: new AppBar(
            title: new Text('收藏的列表项目'),
          ),
          body: new ListView(
            children: divided,
          ),
        );
      },
    );

    Navigator.of(context).push(_page);
  }
}
