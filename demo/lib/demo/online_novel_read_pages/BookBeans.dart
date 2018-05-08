import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;

class MyCustomRoute<T> extends MaterialPageRoute<T> {
	MyCustomRoute({ WidgetBuilder builder, RouteSettings settings }): super(builder: builder, settings: settings);

	@override
	Widget buildTransitions(BuildContext context,
			Animation<double> animation,
			Animation<double> secondaryAnimation,
			Widget child) {
		if (settings.isInitialRoute)
			return child;
		return new FadeTransition(opacity: animation, child: child);
	}
}

class Chapter{
	String bookid;
	String name;
	String chapterid;

	Chapter(this.bookid, this.name, this.chapterid);

	@override
	String toString() {
		return 'Chapter{bookid: $bookid, name: $name, chapterid: $chapterid}';
	}

	static String getChapterID(String content){
		return content.substring(content.lastIndexOf("/") + 1).replaceAll(".html", "");
	}
}

class BkDetail{
	String name = "";
	String img = "";
	String author = "";
	String state = "";
	String type = "";
	String updateDate = "";
	String newName = "";
	String newUrl = "";

	String prewtext = "";

	String readUrl;

	List<Chapter> chapters = [];

	String bookid;
}

// 小说列表项
class BklistItem {
	String img;
	String title;
	String author;
	String review;
	String url;
	String bookID;

	@override
	String toString() {
		return 'BklistItem{img: $img, title: $title, author: $author, review: $review, url: $url, bookID: $bookID}';
	}

	static List<BklistItem> parse(List<dom.Element> es) {
		List<BklistItem> datas = [];
		es.forEach((e) {
			var item = BklistItem();
			item.title = e.querySelector("p.title").text.trim();
			item.author = e.querySelector("p.author").text.trim();
			item.img = e.querySelector("img.lazy").attributes["data-original"].trim();
			item.review = e.querySelector("p.review").text.trim();
			item.url = e.querySelector("a").attributes["href"].trim();
			item.bookID = item.url.replaceAll("/", "");
			datas.add(item);
		});

		return datas;
	}
}

class SearchItem {
	String name;
	String bookid;
	String author;
	String newName;

	@override
	String toString() {
		return 'SearchItem{name: $name, bookid: $bookid, author: $author, newName: $newName}';
	}
}