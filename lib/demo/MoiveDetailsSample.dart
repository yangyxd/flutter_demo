import 'package:flutter/material.dart';
import 'dart:math';

class Movie {
  Movie({
    this.bannerUrl,
    this.posterUrl,
    this.title,
    this.rating,
    this.starRating,
    this.categories,
    this.storyline,
    this.photoUrls,
    this.actors,
  });

  final String bannerUrl;
  final String posterUrl;
  final String title;
  final double rating;
  final int starRating;
  final List<String> categories;
  final String storyline;
  final List<String> photoUrls;
  final List<Actor> actors;
}

class Actor {
  Actor({
    this.name,
    this.avatarUrl,
  });

  final String name;
  final String avatarUrl;
}

final Movie movie = Movie(
  bannerUrl: 'assets/images/banner.png',
  posterUrl: 'assets/images/poster.png',
  title: 'The Secret Life of Pets',
  rating: 8.0,
  starRating: 4,
  categories: ['Animation', 'Comedy', 'Other'],
  storyline: 'For their fifth fully-animated feature-film '
      'collaboration, Illumination Entertainment and Universal '
      'Pictures present The Secret Life of Pets, a comedy about '
      'the lives our...',
  photoUrls: [
    'assets/images/1.png',
    'assets/images/2.png',
    'assets/images/3.png',
    'assets/images/4.png',
  ],
  actors: [
    Actor(
      name: 'Louis C.K.',
      avatarUrl: 'assets/images/louis.png',
    ),
    Actor(
      name: 'Eric Stonestreet',
      avatarUrl: 'assets/images/eric.png',
    ),
    Actor(
      name: 'Kevin Hart',
      avatarUrl: 'assets/images/kevin.png',
    ),
    Actor(
      name: 'Jenny Slate',
      avatarUrl: 'assets/images/jenny.png',
    ),
    Actor(
      name: 'Ellie Kemper',
      avatarUrl: 'assets/images/ellie.png',
    ),
  ],
);

class MoiveDetailsSample extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new MoiveDetailsSampleState();
}

class MoiveDetailsSampleState extends State<MoiveDetailsSample> {
  double opacity = 0.0;

  @override
  Widget build(BuildContext context) {
    var topHeight = kToolbarHeight + MediaQuery.of(context).padding.top;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          NotificationListener(
            child: _buildBodyScrolView(),
            onNotification: ((ScrollUpdateNotification n) {
              if (n.depth == 0 && n.metrics.pixels <= 200.0) {
                setState(() {
                  opacity = min(n.metrics.pixels, 100.0) / 100.0;
                });
              }
              //(n.metrics.pixels, n.metrics.maxScrollExtent
              return true;
            }),
          ),
          Container(
            child: AppBar(
              title: Text("Moive Details"),
              backgroundColor: Colors.transparent,
              elevation: 0.0,
            ),
            color: Colors.green.withOpacity(opacity),
            height: topHeight,
          )
        ],
      ),
    );
  }

  _buildBodyScrolView() {
    return CustomScrollView(
      slivers: <Widget>[
//          SliverAppBar(
//            title: Text("Moive Details"),
//            floating: true,
//            snap: true,
//            backgroundColor: Colors.transparent,
//            elevation: 0.0,
//          ),
        SliverToBoxAdapter(
          child: Container(
            child: _buildBody(),
            height: 320.0,
          ),
        ),
        SliverToBoxAdapter(
          child: _builStoryline(),
        )
      ],
    );
  }

  _buildBody() {
    return Stack(
      children: <Widget>[
        ArcBannerImage(movie.bannerUrl, height: 200.0),
//        AppBar(
//          title: Text("Moive Details"),
//          backgroundColor: Colors.transparent,
//          elevation: 0.0,
//        ),
        _buildMovieImage(),
      ],
    );
  }

  _buildMovieImage() {
    return Positioned(
      bottom: 0.0,
      left: 12.0,
      right: 8.0,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Poster(movie.posterUrl, height: 158.0),
          SizedBox(width: 16.0),
          Expanded(child: _buildMovieInformation()),
        ],
      ),
    );
  }

  // 生成电影详情
  _buildMovieInformation() {
    var textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          movie.title,
          style: textTheme.title,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 8.0),
        _buildRatingInformation(),
        SizedBox(height: 12.0),
        Container(
          height: 32.0, //_kChipHeight,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: _buildCategoryChips(textTheme),
          ),
        ),
      ],
    );
  }

  // 生成等级详情
  _buildRatingInformation() {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    var ratingCaptionStyle = textTheme.caption.copyWith(color: Colors.black45);

    var numericRating = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          movie.rating.toString(),
          style: textTheme.title.copyWith(
            fontWeight: FontWeight.w400,
            color: theme.accentColor,
          ),
        ),
        SizedBox(height: 4.0),
        Text(
          'Ratings',
          style: ratingCaptionStyle,
        ),
      ],
    );

    var starRating = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildRatingBar(theme),
        Padding(
          padding: const EdgeInsets.only(top: 4.0, left: 4.0),
          child: Text(
            'Grade now',
            style: ratingCaptionStyle,
          ),
        ),
      ],
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        numericRating,
        SizedBox(width: 16.0),
        starRating,
      ],
    );
  }

  // 生成类别标签
  List<Widget> _buildCategoryChips(final TextTheme textTheme) {
    return movie.categories.map((category) {
      return Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Chip(
          label: Text(category),
          labelStyle: textTheme.caption,
          backgroundColor: Colors.black12,
        ),
      );
    }).toList();
  }

  // 生成评分星条
  Widget _buildRatingBar(ThemeData theme) {
    var stars = <Widget>[];
    for (var i = 1; i <= 5; i++) {
      var color = i <= movie.starRating ? theme.accentColor : Colors.black12;
      var star = Icon(
        Icons.star,
        color: color,
      );
      stars.add(star);
    }
    return Row(children: stars);
  }

  _builStoryline() {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    final List<String> photoUrls = movie.photoUrls;

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Story line
          SizedBox(height: 8.0),
          Text("Story line", style: textTheme.subhead.copyWith(fontSize: 18.0)),
          SizedBox(height: 8.0),
          Text(movie.storyline,
              style: textTheme.body1.copyWith(
                color: Colors.black45,
                fontSize: 16.0,
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('more',
                  style: textTheme.body1
                      .copyWith(fontSize: 16.0, color: theme.accentColor)),
              Icon(Icons.keyboard_arrow_down,
                  size: 18.0, color: theme.accentColor),
            ],
          ),

          SizedBox(height: 16.0),
          Text("Photos", style: textTheme.subhead.copyWith(fontSize: 18.0)),
          SizedBox(height: 8.0),
          SizedBox.fromSize(
            size: const Size.fromHeight(100.0),
            child: ListView.builder(
              itemCount: photoUrls.length,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(top: 8.0),
              itemBuilder: (BuildContext context, int index) {
                return _buildPhoto(context, photoUrls, index);
              },
            ),
          ),

          // Actors
          SizedBox(height: 16.0),
          Text("Actors", style: textTheme.subhead.copyWith(fontSize: 18.0)),
          SizedBox(height: 8.0),
          SizedBox.fromSize(
            size: const Size.fromHeight(120.0),
            child: ListView.builder(
              itemCount: movie.actors.length,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(top: 12.0),
              itemBuilder: _buildActor,
            ),
          ),
        ],
      ),
    );
  }

  // 生成照片列表
  _buildPhoto(BuildContext context, final List<String> photoUrls, int index) {
    var photo = photoUrls[index];
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4.0),
        child: Image.asset(
          photo,
          width: 160.0,
          height: 120.0,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildActor(BuildContext ctx, int index) {
    var actor = movie.actors[index];
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Column(
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(actor.avatarUrl),
            radius: 40.0,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(actor.name),
          ),
        ],
      ),
    );
  }
}

class ArcBannerImage extends StatelessWidget {
  ArcBannerImage(this.imageUrl, {this.arcH = 30.0, this.height = 230.0});
  final String imageUrl;
  final double height, arcH;

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    return ClipPath(
      clipper: ArcClipper(this),
      child: Image.asset(
        imageUrl,
        width: screenWidth,
        height: height,
        fit: BoxFit.cover,
      ),
    );
  }
}

class ArcClipper extends CustomClipper<Path> {
  final ArcBannerImage widget;
  ArcClipper(this.widget);

  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height - widget.arcH);

    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstPoint = Offset(size.width / 2, size.height);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstPoint.dx, firstPoint.dy);

    var secondControlPoint = Offset(size.width - (size.width / 4), size.height);
    var secondPoint = Offset(size.width, size.height - widget.arcH);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondPoint.dx, secondPoint.dy);

    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class Poster extends StatelessWidget {
  static const POSTER_RATIO = 0.7;

  Poster(this.posterUrl, {this.height = 100.0});

  final String posterUrl;
  final double height;

  @override
  Widget build(BuildContext context) {
    var width = POSTER_RATIO * height;

    return Material(
      borderRadius: BorderRadius.circular(4.0),
      elevation: 2.0,
      child: Image.asset(
        posterUrl,
        fit: BoxFit.cover,
        width: width,
        height: height,
      ),
    );
  }
}
