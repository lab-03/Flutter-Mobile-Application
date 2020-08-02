import 'package:flutter/material.dart';
import 'package:login_bloc/src/blocs/login_bloc.dart';
// import '../blocs/bloc.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginScreen extends StatelessWidget {
  LoginBloc bloc = LoginBloc();

  @override
  Widget build(BuildContext context) {  
    return new Scaffold(
      backgroundColor: Colors.white,
      body: new Stack(fit: StackFit.expand, children: <Widget>[
        new Image(
          image: new AssetImage("assets/login_signup_assets/flutter.jpg"),
          fit: BoxFit.cover,
          colorBlendMode: BlendMode.darken,
          color: Colors.black87,
        ),
        new Theme(
          data: new ThemeData(
              brightness: Brightness.dark,
              inputDecorationTheme: new InputDecorationTheme(
                // hintStyle: new TextStyle(color: Colors.blue, fontSize: 20.0),
                labelStyle:
                    new TextStyle(color: Colors.tealAccent, fontSize: 25.0),
              )),
          isMaterialAppTheme: true,
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new FlutterLogo(
                // size: _iconAnimation.value * 140.0,
              ),
              new Container(
                padding: const EdgeInsets.all(40.0),
                child: new Form(
                  autovalidate: true,
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      loadingIndicator(bloc), 
                      emailField(bloc),
                      passwordField(bloc),
                      errorMessage(bloc),
                      new Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          submitButton(bloc),
                          new Padding(
                            padding: const EdgeInsets.only(right: 20.0),
                          ),
                          signupButton(context),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ]),
    );
  }
  Widget loadingIndicator(LoginBloc bloc) => StreamBuilder<bool>(

    stream: bloc.loading,
    builder: (context, snap) {
      return Container(
        child: (snap.hasData && snap.data)
        ? CircularProgressIndicator() : null,
      );
    },
  );

  Widget errorMessage(LoginBloc bloc) => StreamBuilder<bool>(

    stream: bloc.error,
    builder: (context, snap) {
      return Container(
        child: (snap.hasData && snap.data)
        ? Text("Invalid login credentials. Please try again.", 
          style: TextStyle(color: Colors.red),) 
        : null,
      );
    },
  );

  Widget emailField(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.email,
      builder: (context, snapshot) {
        return TextField(
          onChanged: bloc.changeEmail,
          autofocus: true,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: 'You@example.com',
            labelText: 'Email Address',
            fillColor: Colors.white,
            errorText: snapshot.error,
          ),
        );
      },
    );
  }
  Widget passwordField(LoginBloc bloc) {
    return StreamBuilder( 
      stream: bloc.password,
      builder: (context, snapshot) {
        return TextField(
          onChanged: bloc.changePassword,
          obscureText: true,
          decoration: InputDecoration(
            hintText: 'Password',
            labelText: 'Password',
            errorText: snapshot.error,
          ),
        );
      },
    );
  }

  Widget submitButton(LoginBloc bloc) {    
      return StreamBuilder(
      stream: bloc.submitValid,
      builder: (context, snapshot) {
        return RaisedButton(
          child: Text('Login'),
          color: Colors.blue ,
          onPressed: snapshot.hasError || !snapshot.hasData 
            ? null
            : () => bloc.submit()       
        );
      },
    );
  }
  Widget signupButton(BuildContext context) {    
    return RaisedButton(
        child: Text('Signup'),
        color: Colors.blue ,
        onPressed: () => Navigator.pushNamed(context, '/signup'),       
      );
}
}
