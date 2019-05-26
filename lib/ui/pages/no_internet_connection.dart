import 'package:flutter/material.dart';

class NoInterNetConnection extends StatefulWidget {
  @override
  _NoInterNetConnectionState createState() => _NoInterNetConnectionState();
}

class _NoInterNetConnectionState extends State<NoInterNetConnection> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.perm_scan_wifi,
            size: 80,
            color: Theme.of(context).primaryColor,
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            "No Internet Connection check your connection and try again!",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}
