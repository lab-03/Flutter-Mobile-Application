import 'package:flutter/material.dart';
import '../../blocs/bloc.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginPage extends StatelessWidget {

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
                      emailField(),
                      passwordField(),
                      new Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          submitButton(context),
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
  Widget emailField() {
    return StreamBuilder(
      stream: bloc.email,
      builder: (context, snapshot) {
        return TextField(
          onChanged: bloc.changeEmail,
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
  Widget passwordField() {
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

  Widget submitButton(BuildContext higherContext) {    
      return StreamBuilder(
      stream: bloc.submitLoginValid,
      builder: (context, snapshot) {
        return RaisedButton(
          child: Text('Login'),
          color: Colors.blue ,
          onPressed: snapshot.hasError || !snapshot.hasData 
            ? null 
            : () => bloc.submitLogin(higherContext),       
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
