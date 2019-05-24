import 'package:flutter/material.dart';
import 'package:movies_app/models/movie.dart';

class MovieItem extends StatelessWidget {
  final Movie movie;
  Color mainColor = const Color(0xff3C3261);
  var imageUrl = 'https://image.tmdb.org/t/p/w500/';

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
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.grey,
                    image: DecorationImage(
                        image: NetworkImage(movie.thumbnail==null
                            ? imageUrl
                            : movie.thumbnail),
                        fit: BoxFit.cover),
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
