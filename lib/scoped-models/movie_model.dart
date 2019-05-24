import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

import './connected_movies.dart';
import '../config.dart';
import '../models/movie.dart';

mixin MovieModel on ConnectedMovies {
  Future<void> getAllMovies() async {
    isLoading = true;
    notifyListeners();

    allMovies = List();

    http.Response response = await http.get(Config.LIST_ALL_MOVIES);
    final decodedResponse = json.decode(response.body);

    if (decodedResponse != null) {
      for (var movie in decodedResponse) {
        allMovies.add(Movie.fromJson(movie));
      }
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> getUserFavotiteMovies() async {
    isLoading = true;
    notifyListeners();

    favoriteMovies = List();

    http.Response response = await http
        .get("${Config.LIST_USER_FAVORITES}:${authenticatedUser.id}/movies");

    final decodedResponse = json.decode(response.body);

    if (decodedResponse.length != 0) {
      for (var favMovie in decodedResponse.length) {
        favoriteMovies.add(Movie.fromJson(favMovie));
      }
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> setFavortieMovie(int movieId) async {
    isLoading = true;
    notifyListeners();

    Movie favMovie =
        allMovies.firstWhere((Movie movie) => movie.id == movieId);
    int index = favoriteMovies.indexWhere((Movie movie) => movie.id == movieId);

    if (index == -1) {
      favoriteMovies.add(favMovie);
      http.Response response = await http.get(
          "${Config.LIST_USER_FAVORITES}:${authenticatedUser.id}/movies/:$movieId/favorite");

      if (response.statusCode != 200) {
        favoriteMovies.removeWhere((Movie movie) => movie.id == favMovie.id);
      }
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> setUnFavortieMovie(int movieId) async {
    isLoading = true;
    notifyListeners();

    Movie favMovie =
        favoriteMovies.firstWhere((Movie movie) => movie.id == movieId);
        
    int index = favoriteMovies.indexWhere((Movie movie) => movie.id == movieId);
    
    if (index != -1) {
      favoriteMovies.removeAt(index);
      http.Response response = await http.get(
          "${Config.LIST_USER_FAVORITES}:${authenticatedUser.id}/movies/:$movieId/unfavorite");

      if (response.statusCode != 200) {
        favoriteMovies.add(favMovie);
      }
    }

    isLoading = false;
    notifyListeners();
  }
}
