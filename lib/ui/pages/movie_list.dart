import 'package:flutter/material.dart';
import 'package:movies_app/models/movie.dart';
import 'package:movies_app/scoped-models/main.dart';
import 'package:scoped_model/scoped_model.dart';
import 'item_movie.dart';
import 'movie_details.dart';
import './no_internet_connection.dart';

class MovieList extends StatefulWidget {
  final MainModel mainModel;
  final bool displayFavorite;
  MovieList(this.mainModel, [this.displayFavorite = false]);
  MyMovieListState createState() => new MyMovieListState();
}

class MyMovieListState extends State<MovieList> {
  Widget _buildNoFavoriteMovies() {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.favorite_border,
            color: Colors.redAccent,
            size: 50,
          ),
          SizedBox(
            height: 10,
          ),
          Text("You don't have any favorite movies"),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel mainModel) {
        return mainModel.isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView.builder(
                    itemCount: widget.displayFavorite
                        ? widget.mainModel.favoriteMovies.length
                        : widget.mainModel.allMovies.length,
                    itemBuilder: (context, i) {
                      List<Movie> moviesToDisplay = widget.displayFavorite
                          ? widget.mainModel.favoriteMovies
                          : widget.mainModel.allMovies;
                      return FlatButton(
                        padding: const EdgeInsets.all(0.0),
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return MovieDetailScreen(moviesToDisplay[i]);
                          }));
                        },
                        child: MovieItem(
                            movie: moviesToDisplay[i],
                            addToFavorite: widget.mainModel.setFavortieMovie,
                            removeFromFavorite:
                                widget.mainModel.setUnFavortieMovie),
                        color: Colors.white,
                      );
                    }),
              );
      },
    );
  }


 
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
              icon: Icon(
                Icons.exit_to_app,
                color: Colors.white,
              ),
              label: Text(
                'Log out',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/');
                widget.mainModel.logout();
              },
            )
          ],
        ),
        body: ScopedModelDescendant<MainModel>(
          builder: (BuildContext context, Widget child, MainModel mainModel) {
            return mainModel.displayNoInternetConnection
                ? NoInterNetConnection()
                : widget.displayFavorite
                    ? widget.mainModel.favoriteMovies.length == 0
                        ? _buildNoFavoriteMovies()
                        : _buildBody()
                    : _buildBody();
          },
        ));
  }
}
