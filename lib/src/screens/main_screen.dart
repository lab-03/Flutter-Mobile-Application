import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:login_bloc/src/blocs/home_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './login_screen.dart';
import './signup_screen.dart';
import './profile_screen.dart';
import './attend_screen.dart';
import './firebase.dart';
import 'imageUpload.dart';
import 'participation_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  var _pageController = PageController();
  final FirebaseMessaging _fcm = FirebaseMessaging();
  var _pages;
  var _token = "";

  
  @override
  void initState() {
    super.initState();
    gerSharedPref();
    _pages = [Attend(/**send Headers */), ProfleScreen(/**Send Name && Photo */), Participate()];//
    
    
    // Adding Device Token to users
    if(Platform.isIOS) {
      var iosSubscription = _fcm.onIosSettingsRegistered.listen((date) {
        _getDeviceToken();
      });
      
      _fcm.requestNotificationPermissions(
        IosNotificationSettings()
      );
    } else {
      _getDeviceToken();
    }
  }

  gerSharedPref() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String res = prefs.get("signin_response");
    String headers = prefs.get("signin_headers");
    var jsonHeaders = json.decode(headers);
    var jsonRes = json.decode(res);

    print("JSONHeaders:: ${jsonHeaders["uid"]}");
    print("json: ${jsonRes["data"]}");
    print(res);
  }

  // Widget callPage(currentIndex) {
  //   switch (currentIndex) {
  //     case 0: return Attend();
  //     break;
  //     case 1: return ProfleScreen();
  //     break;
  //     case 2: return Participate();//ScanQrScreen()
  //       break;
  //     default: ProfleScreen();
  //   }
  // }
  HomeBloc bloc = HomeBloc();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: bloc.logoutUser,//Navigator.of(context).pop();
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.more_vert),
            color: Colors.black,
            onPressed: (){},
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            _pageController.animateToPage(_currentIndex, duration: Duration(milliseconds: 200), curve: Curves.linear);
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text("Home"),//
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text("Profile"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            title: Text("Participation"),
          ),
        ],
      ),
      body: PageView(
        children: _pages,
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),//callPage(_currentIndex),
    );
  }

  _getDeviceToken() async{
    final FirebaseMessaging _fcm = FirebaseMessaging();
    String deviceToken = await _fcm.getToken();
    Map nested = {
      "token": deviceToken,
      "device_type": "android" 
    };
    Map deviceTokenData = {
      "device_token": nested,
    };

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String headers = prefs.get("signin_headers");
    var jsonHeaders = json.decode(headers);
    
    print("deviceToken from home: ${deviceTokenData}");
    var data = json.encode(deviceTokenData);
    var deviceTokenResponse = await http.post("https://a-tracker.herokuapp.com/users/add_device_token",
     body: data,
      headers: {
        "Content-Type": "application/json",
        "access-token" :jsonHeaders["access-token"],
        "client": jsonHeaders["client"],
        "uid" : jsonHeaders["uid"]
      }
     );
    print("DeviceTokenRes: ${deviceTokenResponse.statusCode}");
    if(deviceTokenResponse.statusCode == 200) {
      print("deviceRespose status: 200");
      print(deviceTokenResponse.body);
    }
  }

  Widget buildImages() {
    return Padding(
      padding: EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
      child: Container(
          height: 200.0,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              image: DecorationImage(
                  image: AssetImage('assets/beach1.jpg'), fit: BoxFit.cover))),
    );
  }

  Widget buildInfoDetail() {
    return Padding(
      padding:
          EdgeInsets.only(left: 25.0, right: 25.0, top: 10.0, bottom: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Maldives - 12 Days',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                    fontSize: 15.0),
              ),
              SizedBox(height: 7.0),
              Row(
                children: <Widget>[
                  Text(
                    'Teresa Soto',
                    style: TextStyle(
                        color: Colors.grey.shade700,
                        fontFamily: 'Montserrat',
                        fontSize: 11.0),
                  ),
                  SizedBox(width: 4.0),
                  Icon(
                    Icons.timer,
                    size: 4.0,
                    color: Colors.black,
                  ),
                  SizedBox(width: 4.0),
                  Text(
                    '3 Videos',
                    style: TextStyle(
                        color: Colors.grey.shade500,
                        fontFamily: 'Montserrat',
                        fontSize: 11.0),
                  )
                ],
              )
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(width: 7.0),
              InkWell(
                onTap: () {},
                child: Container(
                  height: 20.0,
                  width: 20.0,
                  child: Image.asset('assets/navarrow.png'),
                ),
              ),
              SizedBox(width: 7.0),
              InkWell(
                onTap: () {},
                child: Container(
                  height: 20.0,
                  width: 20.0,
                  child: Image.asset('assets/chatbubble.png'),
                ),
              ),
              SizedBox(width: 7.0),
              InkWell(
                onTap: () {},
                child: Container(
                  height: 22.0,
                  width: 22.0,
                  child: Image.asset('assets/fav.png'),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
