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

    bool shouldTerminate = shouldTerminateProcess();
    if (shouldTerminate) {
      notifyListeners();
      return;
    }

    allMovies = List();

    http.Response response = await http.get(Config.LIST_ALL_MOVIES,
        headers: {"Authorization": "Bearer ${authenticatedUser.token}"});

    if (response.statusCode == 200) {
      final decodedResponse = json.decode(response.body);

      if (decodedResponse != null) {
        for (var movie in decodedResponse['movies']) {
          allMovies
              .add(Movie.fromJson(movie['movie'], authenticatedUser.username));
        }
      }
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> getUserFavotiteMovies() async {
    favoriteMovies = List();

    for (var movie in allMovies) {
      if (movie.isFavorite) favoriteMovies.add(movie);
    }
    notifyListeners();
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

    http.Response response = await http.post(Config.favoriteMovie(movieId),
        headers: {"Authorization": "Bearer ${authenticatedUser.token}"});

    print(Config.favoriteMovie(movieId));
    print({"Authorization": "Bearer ${authenticatedUser.token}"}.toString());
    print(response.statusCode);
    
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

    http.Response response = await http.post(Config.unfavoriteMovie(movieId),
        headers: {"Authorization": "Bearer ${authenticatedUser.token}"});

    print(Config.unfavoriteMovie(movieId));
    print({"Authorization": "Bearer ${authenticatedUser.token}"}.toString());
    print(response.statusCode);

    if (response.statusCode != 200) {
      favoriteMovies.add(favMovie);
    }

    isLoading = false;
    notifyListeners();
  }
}
