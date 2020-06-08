import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:login_bloc/src/blocs/signup_bloc.dart';

class SignupScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  SignupBloc bloc = SignupBloc();
  File _imageFile;
  TextEditingController _controller;




  Future<void> _pickImage(ImageSource source) async{
    File selected = await ImagePicker.pickImage(source: source);

    setState(() {
      _imageFile = selected;
    });
  }

  Future<void> _cropImage() async{
    File cropped = await ImageCropper.cropImage(
      sourcePath: _imageFile.path,
    );
    setState(() {
      _imageFile =cropped ?? _imageFile;
    });
  }

  void _clear() {
    setState(() => _imageFile = null);
  }


  Widget build(BuildContext context) {
    return SafeArea(
          child: new Scaffold(
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
                      new TextStyle(color: Colors.tealAccent, fontSize: 20.0),
                )),
            isMaterialAppTheme: true,
            child: Center(
              child: Wrap(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: new FlutterLogo(
                      // size: _iconAnimation.value * 140.0,
                    ),
                  ),
                  new Container(
                    padding: const EdgeInsets.all(40.0),
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        loadingIndicator(bloc), 
                        nameField(bloc),
                        imageField(bloc),
                        emailField(bloc),
                        passwordField(bloc),
                        new Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            submitSignupButton(bloc),
                            new Padding(
                              padding: const EdgeInsets.only(right: 20.0),
                            ),
                            loginButton(context), 
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }

   Widget loadingIndicator(SignupBloc bloc) => StreamBuilder<bool>(

    stream: bloc.loading,
    builder: (context, snap) {
      return Container(
        child: (snap.hasData && snap.data)
        ? CircularProgressIndicator() : null,
      );
    },
  );

  Widget nameField(SignupBloc bloc) { 
    return StreamBuilder( 
      stream: bloc.name,
      builder: (context, snapshot) {
        return TextField(
          onChanged: bloc.changeName,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'ex:Youssef Khaled Roshdy',
            labelText: 'Name',
            errorText: snapshot.error,
          ),
        );
      },
    );
  }

  Widget imageField(SignupBloc bloc) {
    return StreamBuilder( 
      stream: bloc.image,
      builder: (context, snapshot) {
        return TextField(
          onChanged: bloc.changeImage,
          // enabled: false,
          decoration: InputDecoration(
            labelText: "Image",
            errorText: snapshot.error,
          ),
        );
      }
    );
  }

          
  Widget emailField(SignupBloc bloc) {
    return StreamBuilder(
      stream: bloc.email,
      builder: (context, snapshot) {
        return TextField(
          onChanged: bloc.changeEmail,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: 'You@example.com',
            labelText: 'Email Address',
            errorText: snapshot.error,
          ),
        );
      },
    );
  }

  Widget passwordField(SignupBloc bloc) {
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

  Widget submitSignupButton(SignupBloc bloc) {    
      return StreamBuilder(
      stream: bloc.submitValid,
      builder: (context, snapshot) {
        return RaisedButton(
          child: Text('Signup'),
          color: Colors.blue ,
          onPressed: snapshot.hasError || !snapshot.hasData 
            ? null 
            : () => bloc.submit()        
        );
      },
    );
  }

  Widget loginButton(BuildContext context) {    
      return RaisedButton(
          child: Text('Login'),
          color: Colors.blue ,
          onPressed: () => Navigator.pushNamed(context, '/')   
        );
  }

}