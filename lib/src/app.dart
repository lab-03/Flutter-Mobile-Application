import 'package:flutter/material.dart';
import 'package:login_bloc/src/screens/home_screen.dart';
import 'package:login_bloc/src/screens/scanQR_screen.dart';
import './screens/login_screen.dart';

class App extends StatelessWidget {
  
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: 'Log Me In',
      onGenerateRoute: routes,
    );
  }

  Route routes(RouteSettings settings) {
    if (settings.name == '/') {
      return MaterialPageRoute( 
      builder: (context) {
        return Scaffold(
          body: LoginScreen(),
        );
        }
      );
    } else if(settings.name == '/home') {
      return MaterialPageRoute( 
      builder: (context) {
        return Scaffold(
          body: HomeScreen(),
        );
        }
      );
    } else if (settings.name == '/scanqr') {
      return MaterialPageRoute( 
      builder: (context) {
        return Scaffold(
          body: ScanQrScreen(),
        );
        }
      );
    }
  }
}


 