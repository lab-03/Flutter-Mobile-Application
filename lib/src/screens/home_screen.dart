import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            RaisedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Go back!'),
            ),
            Container(margin: EdgeInsets.only(bottom: 25.0)),
            RaisedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/scanqr');
              },
              child: Text('Scan QR-Code'),
            ),

          ],
        ),
      ),
    );
  }
}