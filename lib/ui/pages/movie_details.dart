import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movies_app/models/movie.dart';

class MovieDetailScreen extends StatefulWidget {
  final Movie movie;
  MovieDetailScreen(this.movie);

  @override
  _MovieDetailScreenState createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: SafeArea(
        top: false,
        bottom: false,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 200.0,
                floating: false,
                pinned: true,
                elevation: 0.0,
                title: innerBoxIsScrolled ? Text(widget.movie.name) : Text(''),
                flexibleSpace: FlexibleSpaceBar(
                  background: CachedNetworkImage(
                    imageUrl: widget.movie.thumbnail==null?"":widget.movie.thumbnail,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ];
          },
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Wrap(
                  direction: Axis.horizontal,
                  spacing: 50.0,
                  alignment: WrapAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        widget.movie.name,
                        style: TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(margin: EdgeInsets.only(top: 8.0, bottom: 8.0)),
                if (widget.movie.year != null)
                  Text(
                    "Rlease year : ${widget.movie.year.toString()}",
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                Container(margin: EdgeInsets.only(top: 8.0, bottom: 8.0)),
                if (widget.movie.director != null)
                  Text(
                    "Director : ${widget.movie.director}",
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                Container(margin: EdgeInsets.only(top: 8.0, bottom: 8.0)),
                if (widget.movie.director != null)
                  Text(
                    "Main Start : ${widget.movie.mainStar}",
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                Container(margin: EdgeInsets.only(top: 8.0, bottom: 8.0)),
                Text(widget.movie.description),
                Container(margin: EdgeInsets.only(top: 8.0, bottom: 8.0)),
                Wrap(
                  children: <Widget>[
                    if (widget.movie.gentres.length != 0)
                      for (var genre in widget.movie.gentres)
                        Container(
                          child: Chip(
                            backgroundColor: Colors.blueAccent,
                            label: Text(
                              genre.name,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          margin: EdgeInsets.only(left: 5.0),
                        )
                  ],
                ),
                Container(margin: EdgeInsets.only(top: 8.0, bottom: 8.0)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
