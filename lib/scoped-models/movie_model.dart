import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

import './connected_movies.dart';
import '../config.dart';
import '../models/movie.dart';

mixin MovieModel on ConnectedMovies {
  bool _isFavoriteMovie(String movieName) {
    int index =
        favoriteMovies.indexWhere((Movie movie) => movie.name == movieName);
    return index == -1 ? false : true;
  }

  Future<void> getAllMovies() async {
    isLoading = true;
    notifyListeners();

    bool shouldTerminate = shouldTerminateProcess();
    if (shouldTerminate) {
      notifyListeners();
      return;
    }

    allMovies = List();

    http.Response response = await http.get(Config.LIST_ALL_MOVIES);
    final decodedResponse = json.decode(response.body);

    if (decodedResponse != null) {
      for (var movie in decodedResponse) {
        allMovies.add(Movie.fromJson(movie, _isFavoriteMovie(movie['name'])));
      }
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> getUserFavotiteMovies() async {
    favoriteMovies = List();
   
  }

  void _toggleFavoriteMode(int movieId) {
    int movieIndex = allMovies.indexWhere((Movie movie) => movie.id == movieId);

    allMovies[movieIndex].isFavorite = !allMovies[movieIndex].isFavorite;
    notifyListeners();
  }

  Future<void> setFavortieMovie(int movieId) async {
    bool shouldTerminate = shouldTerminateProcess();
    if (shouldTerminate) {
      notifyListeners();
      return;
    }

    Movie favMovie = allMovies.firstWhere((Movie movie) => movie.id == movieId);

    _toggleFavoriteMode(movieId);

    favoriteMovies.add(favMovie);
    print(authenticatedUser.id.toString());
    http.Response response = await http.get(
        "${Config.LIST_USER_FAVORITES}${authenticatedUser.id}/movies/$movieId/favorite");

    if (response.statusCode != 200) {
      favoriteMovies.removeWhere((Movie movie) => movie.id == favMovie.id);
    }
  }

  Future<void> setUnFavortieMovie(int movieId) async {
    bool shouldTerminate = shouldTerminateProcess();
    if (shouldTerminate) {
      notifyListeners();
      return;
    }

    Movie favMovie =
        favoriteMovies.firstWhere((Movie movie) => movie.id == movieId);

    int index = favoriteMovies.indexWhere((Movie movie) => movie.id == movieId);

    favoriteMovies.removeAt(index);
    _toggleFavoriteMode(movieId);

    http.Response response = await http.get(
        "${Config.LIST_USER_FAVORITES}${authenticatedUser.id}/movies/$movieId/unfavorite");

    if (response.statusCode != 200) {
      favoriteMovies.add(favMovie);
    }

    isLoading = false;
    notifyListeners();
  }
}
