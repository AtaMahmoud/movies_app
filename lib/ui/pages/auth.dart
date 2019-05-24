import 'package:flutter/material.dart';
import './main_page.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:movies_app/scoped-models/main.dart';

class AuthPage extends StatefulWidget {
  final MainModel mainModel;
  AuthPage(this.mainModel);
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  String userName = "";
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildUserNameFiled() {
    return TextFormField(
      onSaved: (String username) {
        userName = username;
      },
      validator: (String value) {
        if (value.isEmpty || !RegExp(r"^[a-zA-Z0-9_]*").hasMatch(value)) {
          return 'Please only introduce numbers, letters and underscore.';
        }
      },
      maxLength: 20,
      decoration: InputDecoration(
          border: InputBorder.none,
          icon: Icon(
            Icons.person,
            color: Colors.black,
          ),
          labelText: 'User name',
          labelStyle: TextStyle(color: Colors.black)),
      style: TextStyle(color: Colors.black),
    );
  }

  Widget _buildUserNameCard() {
    return Card(
      elevation: 1.0,
      color: Colors.white70,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: _buildUserNameFiled(),
      ),
    );
  }

  Widget _buildGoButton() {
    return ScopedModelDescendant(
        builder: (BuildContext context, Widget child, MainModel mainModel) {
      return RaisedButton(
        padding: EdgeInsets.all(20.0),
          shape: CircleBorder(),
          child: mainModel.isLoading ? CircularProgressIndicator() : Text("Go"),
          onPressed: () =>
              _onSubmitButtonPressed(mainModel.login, mainModel.register));
    });
  }

  _showCreateUserDialog() async {
    return await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(
                'Do you want to create a new user with username: $userName?”'),
            actions: <Widget>[
              FlatButton(
                child: Text('Yes', style: TextStyle(color: Colors.blueAccent)),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
              FlatButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              )
            ],
          );
        });
  }

  void _navigateToMainPage() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (BuildContext context) => MainPage(widget.mainModel)));
  }

  void _showCreatingUserDialouge() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
            child: Container(
              padding: EdgeInsets.all(20.0),
              child: Row(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(
                    width: 10,
                  ),
                  Text('Creating new user...')
                ],
              ),
            ),
          );
        });
  }

  void _onSubmitButtonPressed(Function login, Function registerNewUser) async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();

    Map<String, dynamic> result = await login(userName);
    if (result['status'] == 0) {
      bool useThisUserToRegister = await _showCreateUserDialog();
      if (useThisUserToRegister) {
        
        Map<String, dynamic> registrationResult =
            await registerNewUser(userName);
       
        if (registrationResult['status'] == 0) {
          _navigateToMainPage();
        }
      }
    } else {
      _navigateToMainPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildUserNameCard(),
              SizedBox(height: 10.0),
              _buildGoButton(),
            ],
          ),
        ),
      ),
    );
  }
}
