import 'package:flutter/material.dart';
import 'package:login_bloc/src/blocs/authorization_bloc.dart';
import 'package:login_bloc/src/screens/main_screen.dart';
import 'package:login_bloc/src/screens/scanQR_screen.dart';
import 'package:login_bloc/src/screens/signup_screen.dart';
import 'package:login_bloc/src/screens/camera_screen.dart';
import './screens/login_screen.dart';

class App extends StatelessWidget {
  
  Widget build(BuildContext context) {
    authBloc.restoreSession();
    // TODO: implement build
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => createContent(),
        '/signup': (context) => SignupScreen(),
        '/login' : (context) => LoginScreen(),
        '/scanQr' : (context) => ScanQrScreen(),
        '/camera' : (context) => CameraScreen(),
        //'/home' : (context) => createContent(),

      },
      title: "Biometric Attendance & Academic Analytics",
      //home: createContent(),
      //onGenerateRoute: routes,
    );
  }
  createContent() {
    return StreamBuilder<bool> (
      stream: authBloc.isSessionValid,
      builder: (context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData && snapshot.data) {
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


 