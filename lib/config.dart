class Config {
  static const String BASE_URL = 'http://159.65.149.190:3000/api';
  static const String LOGIN = '$BASE_URL/users/login.json';
  static const String REGISTER = '$BASE_URL/users.json';
  static const String LOGOUT = '$BASE_URL/users/logout.json';
  static const String LIST_ALL_MOVIES = '$BASE_URL/movies.json';

  static String favoriteMovie(int movieId) {
    return "$BASE_URL/movies/$movieId/favorite.json";
  }

  static String unfavoriteMovie(int movieId) {
    return "$BASE_URL/movies/$movieId/unfavorite.json";
  }
}
