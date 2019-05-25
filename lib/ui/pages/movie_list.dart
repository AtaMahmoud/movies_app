import 'package:flutter/material.dart';
import 'package:movies_app/scoped-models/main.dart';
import 'package:scoped_model/scoped_model.dart';
import 'item_movie.dart';
import 'movie_details.dart';

class MovieList extends StatefulWidget {
  final MainModel mainModel;
  MovieList(this.mainModel);
  MyMovieListState createState() => new MyMovieListState();
}

class MyMovieListState extends State<MovieList> {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Welcome ${widget.mainModel.authenticatedUser.username}",
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Arvo',
                fontWeight: FontWeight.bold)),
        elevation: 0.3,
        
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.exit_to_app,color: Colors.white,),
            label: Text('Log out',style: TextStyle(color: Colors.white),),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/');
              widget.mainModel.logout();
            },
          )
        ],
      ),
      body: ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel mainModel) {
          return mainModel.isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView.builder(
                      itemCount: widget.mainModel.allMovies.length,
                      itemBuilder: (context, i) {
                        return FlatButton(
                          padding: const EdgeInsets.all(0.0),
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return MovieDetailScreen(
                                  widget.mainModel.allMovies[i]);
                            }));
                          },
                          child: MovieItem(
                              movie: widget.mainModel.allMovies[i],
                              addToFavorite: widget.mainModel.setFavortieMovie,
                              removeFromFavorite:
                                  widget.mainModel.setFavortieMovie),
                          color: Colors.white,
                        );
                      }),
                );
        },
      ),
    );
  }
}
