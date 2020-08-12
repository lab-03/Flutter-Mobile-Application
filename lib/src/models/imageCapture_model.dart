import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import '../blocs/bloc.dart';

class Test extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(brightness: Brightness.light),
      home: ImageCapture(),
    );
  }
}


class ImageCapture extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ImageCaptureState();
}

class _ImageCaptureState extends State<ImageCapture> {
  File _imageFile;


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
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            nameField(),
            imageField(),
            emailField(),
            passwordField(),
            Container(margin: EdgeInsets.only(bottom: 25.0)),
            submitSignupButton(context),
            loginButton(context),
          ],
        ),
      )
    );
  }

          
  Widget nameField() { 
    return StreamBuilder( 
      stream: bloc.name,
      builder: (context, snapshot) {
        return TextField(
          onChanged: bloc.changeName,
          decoration: InputDecoration(
            hintText: 'ex:Youssef Khaled Roshdy',
            labelText: 'Name',
            errorText: snapshot.error,
          ),
        );
      },
    );
  }

  Widget imageField() {
    return Row(
      children: <Widget>[
        Text("Browse photo:"),
        IconButton(
          icon: Icon(Icons.photo_camera),
          onPressed: () => _pickImage(ImageSource.camera),
        ),
        IconButton(
          icon: Icon(Icons.photo_album),
          onPressed: ()  => _pickImage(ImageSource.gallery),
        ),
        if (_imageFile != null) ...[
        Image.file(
          _imageFile,
          width: 60,
          height: 40,
          fit: BoxFit.contain,
        ),
        Row(
          children: <Widget>[
            FlatButton(
              child: Icon(Icons.crop),
              onPressed: _cropImage,
            )
          ],
        ),
      ]
      ],
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

  Widget submitSignupButton(BuildContext higherContext) {    
      return StreamBuilder(
      stream: bloc.submitSignupValid,
      builder: (context, snapshot) {
        return RaisedButton(
          child: Text('Signup'),
          color: Colors.blue ,
          onPressed: snapshot.hasError || !snapshot.hasData || _imageFile == null
            ? null 
            : () => bloc.submitSignup(higherContext),       
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