import 'package:flutter/material.dart';
import 'package:movies_app/ui/pages/auth.dart';
import 'package:movies_app/ui/pages/main_page.dart';
import 'package:scoped_model/scoped_model.dart';
import './scoped-models/main.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _mainModel = MainModel();

  bool _isAuthenticatedUser = false;

  @override
  void initState() {
    super.initState();
    _mainModel.autoAuth();
    _mainModel.userSubject.listen((bool isAuthenticated) {
      setState(() {
        _isAuthenticatedUser = isAuthenticated;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      model: _mainModel,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
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
