import 'dart:async';

import 'package:flutter/material.dart';
import 'package:movies_app/ui/pages/auth.dart';
import 'package:movies_app/ui/pages/main_page.dart';
import 'package:movies_app/utilities/connection_checker.dart';
import 'package:scoped_model/scoped_model.dart';
import './scoped-models/main.dart';

void main() {
  ConnectionStatusSingleton connectionStatus =
      ConnectionStatusSingleton.getInstance();
  connectionStatus.initialize();

  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _mainModel = MainModel();

  bool _isAuthenticatedUser = false;
  StreamSubscription _connectionChangeStream;

  bool isOnline = true;

  @override
  void initState() {
    super.initState();
    ConnectionStatusSingleton connectionStatus =
        ConnectionStatusSingleton.getInstance();
    
    _connectionChangeStream =
        connectionStatus.connectionChange.listen((dynamic hasConnection) {
      _mainModel.toggleIsConnected(hasConnection);
    });

  //  _mainModel.autoAuth();
    _mainModel.userSubject.listen((bool isAuthenticated) {
      setState(() {
        _isAuthenticatedUser = isAuthenticated;
      });
    });
  }

  @override
  void dispose() {
    _connectionChangeStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      model: _mainModel,
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: Color(0xFF3B5998),
          accentColor: Color(0xFF8B9DC3),
        ),
        title: "Movie App",
        routes: {
          '/': (BuildContext context) {
            return ScopedModelDescendant<MainModel>(
              builder:
                  (BuildContext context, Widget child, MainModel mainModel) {
                if (mainModel.isLoginLoading)
                  return Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );

                if (_isAuthenticatedUser) return MainPage(_mainModel);

                return AuthPage(_mainModel);
              },
            );
          },
        },
      ),
    );
  }
}
