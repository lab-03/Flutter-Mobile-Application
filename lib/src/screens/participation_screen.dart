import 'package:flutter/material.dart';

class Participate extends StatelessWidget {
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton(
              padding: EdgeInsets.all(15.0),
              onPressed: () async {
                Navigator.pushNamed(context, '/questions');
              },
              child: Text(
                "Participate",
                style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold),
              ),
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.blue,width: 3.0),
                  borderRadius: BorderRadius.circular(20.0)),
            ),
          ],
        ),
    );
  }
  
}