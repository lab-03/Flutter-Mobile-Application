import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login_bloc/src/models/imageCapture_model.dart';


class MessageHandlerFire extends StatefulWidget {
  @override
  createState() => _MessageHandlerState();
}

class _MessageHandlerState extends State<MessageHandlerFire> {
  final Firestore _db = Firestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();
  var _token = "";

  @override
  void initState() {
    super.initState();


    if(Platform.isIOS) {
      var iosSubscription = _fcm.onIosSettingsRegistered.listen((date) {
        _saveDeviceToken();
      });
      
      _fcm.requestNotificationPermissions(
        IosNotificationSettings()
      );
    } else {
      _saveDeviceToken();
    }
    




    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        final snackbar = SnackBar(
          content: Text(message['notification']['title']),
          action: SnackBarAction(
            label: 'GO',
            onPressed: () => null,
          ),
        );

        Scaffold.of(context).showSnackBar(snackbar);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text(message['notification']['title']),
              subtitle: Text(message['notification']['body']),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          ),
        );
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLanuch: $message");

      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("token: ${_token}"),
    );
  }

  _saveDeviceToken() async {
    String uid = "";

    String fcmToken = await _fcm.getToken();
    setState(() {
      _token = fcmToken;
    });
    print("Device TOken: $fcmToken");
  }
}

