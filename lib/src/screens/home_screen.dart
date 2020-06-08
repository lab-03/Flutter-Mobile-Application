import 'package:flutter/material.dart';

class Test extends StatelessWidget {
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/camera');
              },
              child: Text('Attend'),
            ),
          ],
        ),
    );
  }
}