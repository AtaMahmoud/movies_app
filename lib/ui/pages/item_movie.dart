import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movies_app/models/movie.dart';

class MovieItem extends StatelessWidget {
  final Movie movie;
  final Color mainColor = const Color(0xff3C3261);

  MovieItem(
    this.movie,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: Container(
                margin: const EdgeInsets.all(16.0),
                child: Container(
                  width: 70.0,
                  height: 70.0,
                  child: CachedNetworkImage(
                    imageUrl: movie.thumbnail==null?"":movie.thumbnail,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    fit: BoxFit.cover,
                  ),
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.grey,
                    boxShadow: [
                      BoxShadow(
                          color: mainColor,
                          blurRadius: 5.0,
                          offset: Offset(2.0, 5.0))
                    ]),
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                child: Column(children: <Widget>[
                  Text(
                    movie.name,
                    style: TextStyle(
                        fontSize: 20.0,
                        fontFamily: 'Arvo',
                        fontWeight: FontWeight.bold,
                        color: mainColor),
                  ),
                  Padding(padding: EdgeInsets.all(2.0)),
                  Text(movie.description,
                      maxLines: 3,
                      style: TextStyle(
                        fontFamily: 'Arvo',
                        color: const Color(0xff8785A4),
                      ))
                ], crossAxisAlignment: CrossAxisAlignment.start),
              ),
            ),
            IconButton(
              icon: Icon(Icons.favorite, color: Colors.redAccent),
              onPressed: () {},
            )
          ],
        ),
        Container(
            width: 300.0,
            height: 0.5,
            color: const Color(0xD2D2E1ff),
            margin: const EdgeInsets.all(16.0))
      ],
    );
  }
}
