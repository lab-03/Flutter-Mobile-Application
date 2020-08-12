import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
import 'package:progress_dialog/progress_dialog.dart';


class SignupScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  ProgressDialog pr;

  String _name;
  String _password;
  String _email;
  File _image;

  var name = TextEditingController();
  var email = TextEditingController();
  var password = TextEditingController();
  String img =
      'https://git.unilim.fr/assets/no_group_avatar-4a9d347a20d783caee8aaed4a37a65930cb8db965f61f3b72a2e954a0eaeb8ba.png';

  final _formKey = GlobalKey<FormState>();

  Widget build(BuildContext context) {
    //============================================= loading dialoge
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);

    //Optional
    pr.style(
      message: 'Please wait...',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: CircularProgressIndicator(),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progressTextStyle: TextStyle(
          color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
    );


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
                  imageField(),
                  new Container(
                    padding: const EdgeInsets.all(40.0),
                    margin: EdgeInsets.only(top: 5, bottom: 0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          nameField(),
                          emailField(),
                          passwordField(),
                          //=======Buttons=================================================
                          submitButton(),
                          loginButton(),
                        ],
                      ),
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

  //========================================================================== Widgets Area
  Widget imageField() {
    return Center(
      child: Stack(
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
                color: Colors.tealAccent,
              )),
          ),
        ],
      ),
    );
  }
  Widget nameField() {
    return TextFormField(
      controller: name,
      onChanged: ((String name) {
        setState(() {
          _name = name;
          print(_name);
        });
      }),
      decoration: InputDecoration(
        labelText: "Name",
        labelStyle: TextStyle(
          color: Colors.tealAccent,
        ),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10)),
      ),
      textAlign: TextAlign.center,
      validator: (value) {
        RegExp exp = new RegExp(r"^[a-zA-Z.+'-]+(?: [a-zA-Z.+'-]+){2,} ?$"); //r"^[a-zA-Z0-9._%+-]+@stud\.fci-cu\.edu\.eg$"
        if (!exp.hasMatch(value) || value.isEmpty) {  
          return 'Please enter full name';
        }
        return null;
      },
    );
  }
  
  
  
  
  
  
  Widget emailField() {
    return Container(
      margin: EdgeInsets.only(top: 25),
      child: TextFormField(
        controller: email,
        onChanged: ((String email) {
          setState(() {
            _email = email;
            print(_email);
          });
        }),
        decoration: InputDecoration(
          labelText: "Email Address",
          labelStyle: TextStyle(
            color: Colors.tealAccent,
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10)),
        ),
        textAlign: TextAlign.center,
        validator: (value) {
          RegExp exp = new RegExp(r"^[a-zA-Z0-9._%+-]+"); //r"^[a-zA-Z0-9._%+-]+@stud\.fci-cu\.edu\.eg$"
          //r"^[a-zA-Z0-9._%+-]+" 
          if (value.isEmpty) {
            return 'Please enter email address';
          }
          return null;
        },
      ),
    );

  }
  
  Widget passwordField() {
    return Container(
      margin: EdgeInsets.only(top: 25),
      child: TextFormField(
        controller: password,
        onChanged: ((String phone) {
          setState(() {
            _password = phone;
            print(_password);
          });
        }),
        decoration: InputDecoration(
          labelText: "password Number",
          labelStyle: TextStyle(
            color: Colors.tealAccent,
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10)),
        ),
        textAlign: TextAlign.center,
        keyboardType: TextInputType.phone,
        validator: (value) {
          if (value.isEmpty || value.length != 6) {
            return 'Please enter emergency password number';
          }
          return null;
        },
      ),
    );
  }
  
  Widget submitButton() {
    return Center(
      child: Container(
        width: 300,
        margin: EdgeInsets.only(top: 50),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Colors.blue),
        child: FlatButton(
          child: FittedBox(
              child: Text(
            'Sign up',
            style: TextStyle(
                color: Colors.white, fontSize: 16),
            textAlign: TextAlign.center,
          )),
          onPressed: () {
            if (_formKey.currentState.validate()) {
              _startUploading();
            }
          },
        ),
      ),
    );
  }
  
  Widget loginButton() {
    return Center(
      child: Container(
        width: 300,
        margin: EdgeInsets.only(top: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Colors.blue),
        child: FlatButton(
          child: FittedBox(
            child: Text(
            'Log in',
            style: TextStyle(
              color: Colors.white, 
              fontSize: 16
            ),
            textAlign: TextAlign.justify,
          )),
          onPressed: () => Navigator.pushNamed(context, '/'),
        ),
      ),
    );
  }
  

  
  //========================= Gellary / Camera AlerBox
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
                      'assets/images/gallery.png',
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
                      'assets/images/take_picture.png',
                      width: 50,
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

  //============================================================= API Area to upload image
  Uri apiUrl = Uri.parse(
      'https://a-tracker.herokuapp.com/students');

  Future<Map<String, dynamic>> _uploadImage(File image) async {
    setState(() {
      pr.show();
    });

    final mimeTypeData =
        lookupMimeType(image.path, headerBytes: [0xFF, 0xD8]).split('/');

    // Intilize the multipart request
    final imageUploadRequest = http.MultipartRequest('POST', apiUrl);

    // Attach the file in the request
    final file = await http.MultipartFile.fromPath(
        'student[image]', image.path,
        contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));
    // Explicitly pass the extension of the image with request body
    // Since image_picker has some bugs due which it mixes up
    // image extension with file name like this filenamejpge
    // Which creates some problem at the server side to manage
    // or verify the file extension

//    imageUploadRequest.fields['ext'] = mimeTypeData[1];

    imageUploadRequest.files.add(file);
    imageUploadRequest.fields['first_name'] = _name;
    imageUploadRequest.fields['student[email]'] = _email;
    imageUploadRequest.fields['student[password]'] = _password;

    try {
      final streamedResponse = await imageUploadRequest.send();
      final response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode != 201) {
        print(response.statusCode);
        print(response.body);
        print("Not Correct!!");
        return null;
      }
      final Map<String, dynamic> responseData = json.decode(response.body);
      _resetState();
      print(responseData);
      return responseData;
    } catch (e) {
      print(e);
      return null;
    }
  }

  void _startUploading() async {
    if (_image != null ||
        _name != '' ||
        _email != '' ||
        _password != '') {
      final Map<String, dynamic> response = await _uploadImage(_image);

      // Check if any error occured
      if (response != null) {
        pr.hide();
        messageAllert('User details updated successfully', 'Success');
      } else {
        pr.hide();
        messageAllert('Profile', 'Profile Photo');
      }
    } else {
      messageAllert('Please Select a profile photo', 'Failed');
    }
  }

  void _resetState() {
    print('working');
    setState(() {
      pr.hide();
      _name = null;
      _email = null;
      _password = null;
      _image = null;
    });
  }

  messageAllert(String msg, String ttl) {
    // Navigator.pop(context);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new CupertinoAlertDialog(
            title: Text(ttl),
            content: Text(msg),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Column(
                  children: <Widget>[
                    Text('Okay'),
                  ],
                ),
                onPressed: () {
                  if (ttl == 'Success') {
                    Navigator.pushNamed(context, '/');
                  } else {
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          );
        });
  }
}