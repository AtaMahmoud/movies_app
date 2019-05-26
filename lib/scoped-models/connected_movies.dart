import 'package:scoped_model/scoped_model.dart';
import '../models/user.dart';
import '../models/movie.dart';

mixin ConnectedMovies on Model {
  bool isLoading = false;
  bool isLoginLoading = false;
  bool isConnected = true;
  bool displayNoInternetConnection = false;
  User authenticatedUser;
  List<Movie> allMovies = List();
  List<Movie> favoriteMovies = List();

  bool shouldTerminateProcess() {
    if (!isConnected) {
      displayNoInternetConnection = true;
      isLoading = false;
      isLoginLoading = false;
      return true;
    }
    return false;
  }

  void toggleIsConnected(bool isConnected) {
    this.isConnected = isConnected;
    if (isConnected) displayNoInternetConnection = false;
    notifyListeners();
  }
}
