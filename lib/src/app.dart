import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:login_bloc/src/blocs/authorization_bloc.dart';
import 'package:login_bloc/src/screens/main_screen.dart';
import 'package:login_bloc/src/screens/camera_screen.dart';
import './screens/login_screen.dart';
import 'screens/attend_by_fingerprint.dart';
import 'screens/questions_screen.dart';
import 'screens/scan.dart';
import 'screens/signup_screen.dart';
import 'screens/signup_screen_o.dart';

import 'package:shared_preferences/shared_preferences.dart';


class App extends StatelessWidget {
  
  Widget build(BuildContext context) {
    authBloc.restoreSession();
    
    // TODO: implement build
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => createContent(),
        '/test' : (context) => UserInfoEdit(),
        '/signup': (context) => SignupScreen(),
        '/login' : (context) => LoginScreen(),
        '/scanQr' : (context) => ScanPage(),//ScanQrScreen(),
        '/camera' : (context) => CameraScreen(),
        '/home' : (context) => MainScreen(),
        '/attend_by_fingerprint' : (context) => AttendByFingerPrint(),
        '/questions' : (context) => Questions(),

      },
      title: "Biometric Attendance & Academic Analytics",
      //home: createContent(),
      //onGenerateRoute: routes,
    );
  }
  // var prefs = await SharedPreferences.getInstance();
  createContent() {
    return StreamBuilder<bool> (
      stream: authBloc.isSessionValid,
      builder: (context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData && snapshot.data) {
          // print("response: ${authBloc.sign_in_response["data"]["email"]}");
          return MainScreen();
        }
        return LoginScreen();
      }
    );
  }

  // Route routes(RouteSettings settings) {
  //   if (settings.name == '/') { 
  //     return MaterialPageRoute( 
  //       builder: (context) {
  //         return HomeScreen();
  //       }
  //     );
  //   } else if(settings.name == '/home') {
  //     return MaterialPageRoute( 
  //     builder: (context) {
  //       return Scaffold(
  //         body: HomeScreen(),
  //       );
  //       }
  //     );
  //   } else if (settings.name == '/scanqr') {
  //     return MaterialPageRoute( 
  //     builder: (context) {
  //       return Scaffold(
  //         body: ScanQrScreen(),
  //       );
  //       }
  //     );
  //   } else if (settings.name == '/testpage') {
  //     return MaterialPageRoute(  
  //     builder: (context) {
  //       return Scaffold(
  //         body: Test(),
  //       );
  //       }
  //     );
  //   } else if (settings.name == '/signup') {
  //     return MaterialPageRoute( 
  //     builder: (context) {
  //       return Scaffold(
  //         body: SignupScreen(),
  //       );
  //       }
  //     );
  //   } else if (settings.name == '/login') {
  //     return MaterialPageRoute( 
  //     builder: (context) {
  //       return Scaffold(
  //         body: LoginScreen(),
  //       );
  //       }
  //     );
  //   }
  // }
}


 