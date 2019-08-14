import 'dart:convert';
import 'dart:async';
import 'package:rxdart/subjects.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import './connected_movies.dart';
import '../config.dart';
import '../models/user.dart';

mixin UserModel on ConnectedMovies {
  PublishSubject<bool> _userSubject = PublishSubject<bool>();
  PublishSubject<bool> get userSubject {
    return _userSubject;
  }

  Future<Map<String, dynamic>> login(String userName) async {
    isLoading = true;
    notifyListeners();

    bool shouldTerminate = shouldTerminateProcess();
    if (shouldTerminate) return null;

    Map<String, dynamic> result = {'status': 0};

    http.Response response = await http.post(Config.LOGIN,
        body: json.encode({
          'user': {'username': userName}
        }),
        headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      final decodedResponse = json.decode(response.body);

      authenticatedUser = User.fromJson(decodedResponse);
      await _saveToSharedPrefs(authenticatedUser.toMap());
      result['status'] = 1;
    }

    isLoading = false;
    notifyListeners();
    return result;
  }

  Future<Map<String, dynamic>> register(String userName) async {
    isLoading = true;
    notifyListeners();

    bool shouldTerminate = shouldTerminateProcess();
    if (shouldTerminate) return null;

    Map<String, dynamic> result = {'status': 0};

    final body = json.encode({
      "user": {"username": "$userName"}
    });

    http.Response response = await http.post("${Config.REGISTER}",
        body: body, headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      final decodedResponse = json.decode(response.body);
      authenticatedUser = User.fromJson(decodedResponse);
      await _saveToSharedPrefs(authenticatedUser.toMap());
      result['status'] = 1;
    }

    isLoading = false;
    notifyListeners();
    return result;
  }

  Future<void> autoAuth() async {
    isLoginLoading = true;
    notifyListeners();

    bool shouldTerminate = shouldTerminateProcess();
    if (shouldTerminate) return;

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    if (sharedPreferences.containsKey("id")) {
      Map<String, dynamic> userMap = {
        "id": sharedPreferences.getInt("id"),
        "username": sharedPreferences.getString("username"),
        "token": sharedPreferences.getString("token"),
        "url": sharedPreferences.getString("url")
      };

      authenticatedUser = User.fromJson(userMap);

      _userSubject.add(true);
    }

    isLoginLoading = false;
    notifyListeners();
  }

  Future<void> logout() async {
    isLoginLoading = true;
    notifyListeners();

    await _logout();
    _userSubject.add(false);
    authenticatedUser = null;

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();

    isLoginLoading = false;
    notifyListeners();
  }

  Future<void> _logout() async {
    final response = await http.post(Config.LOGOUT,
        headers: {"Authorization": "Bearer ${authenticatedUser.token}"});

    print(response.body);
  }

  Future<void> _saveToSharedPrefs(Map<String, dynamic> userMap) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    for (var key in userMap.keys) {
      if (key == "id")
        await sharedPreferences.setInt(key, userMap[key]);
      else
        await sharedPreferences.setString(key, userMap[key]);
    }
  }
}
