import 'package:flutter/material.dart';
import 'package:movies_app/ui/pages/auth.dart';
import 'package:scoped_model/scoped_model.dart';
import './ui/pages/main_page.dart';
import './scoped-models/main.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  final _mainModel = MainModel();

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      model: _mainModel,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Movie App",
        home: AuthPage(_mainModel),
      ),
    );
  }
}
