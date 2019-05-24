import 'package:scoped_model/scoped_model.dart';
import '../models/user.dart';
import '../models/movie.dart';

mixin ConnectedMovies on Model {
  bool isLoading=false;
  User authenticatedUser;
  List<Movie>allMovies;
  List<Movie> favoriteMovies;
}