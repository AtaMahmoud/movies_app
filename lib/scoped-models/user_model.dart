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

    Map<String, dynamic> result = {'status': 0};

    http.Response response =
        await http.get("${Config.LOGIN}?username=$userName");
    final decodedResponse = json.decode(response.body);
    if (decodedResponse.length != 0) {
      authenticatedUser = User.fromJson(decodedResponse[0]);
      result['status'] = 1;
      await _saveToSharedPrefs('id', authenticatedUser.id);
      await _saveToSharedPrefs('username', authenticatedUser.username);
    }

    isLoading = false;
    notifyListeners();
    return result;
  }

  Future<Map<String, dynamic>> register(String userName) async {
    isLoading = true;
    notifyListeners();

    Map<String, dynamic> result = {'status': 0};

    final body = json.encode({
      "user": {"username": "$userName"}
    });

    http.Response response = await http.post("${Config.LOGIN}",
        body: body, headers: {'Content-Type': 'application/json'});

    final decodedResponse = json.decode(response.body);
    if (decodedResponse != null) {
      authenticatedUser = User.fromJson(decodedResponse);
      result['status'] = 1;
      await _saveToSharedPrefs('id', authenticatedUser.id);
      await _saveToSharedPrefs('username', authenticatedUser.username);
    }

    isLoading = false;
    notifyListeners();
    return result;
  }

  Future<void> autoAuth() async {
    isLoginLoading=true;
    notifyListeners();

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    String userName = sharedPreferences.getString('username');
    if (userName != null) {
      Map<String, dynamic> result = await login(userName);
      if (result['status'] == 1) _userSubject.add(true);
    }

    isLoginLoading = false;
    notifyListeners();
  }

  Future<void> _saveToSharedPrefs(String key, value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (value is int) {
      sharedPreferences.setInt(key, value);
    } else {
      sharedPreferences.setString(key, value);
    }
  }
}
