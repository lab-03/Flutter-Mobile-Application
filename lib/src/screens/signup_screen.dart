import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:login_bloc/src/blocs/signup_bloc.dart';


class SignupScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  SignupBloc bloc = SignupBloc();
  File _image;

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
                        imageField(bloc),
                        nameField(bloc),
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
            : () => bloc.submit(_image)        
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

  Widget imageField(SignupBloc bloc) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              CircleAvatar(
                backgroundImage: _image == null
                    ? NetworkImage(
                        'https://git.unilim.fr/assets/no_group_avatar-4a9d347a20d783caee8aaed4a37a65930cb8db965f61f3b72a2e954a0eaeb8ba.png')
                    : FileImage(_image),
                radius: 50.0,
              ),
              InkWell(
                onTap: _onAlertPress,
                child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40.0),
                        color: Colors.black),
                    margin: EdgeInsets.only(left: 70, top: 70),
                    child: Icon(
                      Icons.photo_camera,
                      size: 25,
                      color: Colors.white,
                    )),
              ),
            ],
          ),
          Text('Half Body',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        ],
      ),
    );
  }
  
  void _onAlertPress() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new CupertinoAlertDialog(
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Column(
                  children: <Widget>[
                    Image.asset(
                      "assets/images/gallery.png",
                      width: 50,
                    ),
                    Text('Gallery'),
                  ],
                ),
                onPressed: getGalleryImage,
              ),
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Column(
                  children: <Widget>[
                    Image.asset(
                      "assets/images/take_picture.png",
                      width: 50,
                      scale: 0.5,
                    ),
                    Text('Take Photo'),
                  ],
                ),
                onPressed: getCameraImage,
              ),
            ],
          );
        });
  }

  // ================================= Image from camera
  Future getCameraImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
      Navigator.pop(context);
    });
  }

  //============================== Image from gallery
  Future getGalleryImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
      Navigator.pop(context);
    });
  }

}