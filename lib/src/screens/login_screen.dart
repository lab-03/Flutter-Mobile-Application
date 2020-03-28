import 'package:flutter/material.dart';
import '../Mixins/validate_mixin.dart';

class LoginScreen extends StatefulWidget {
  createState() {
    return LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen>  with ValidationMixin{
  final formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';

  Widget build(context) {
    return Container(
      margin: EdgeInsets.all(20.0),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            emailField(),
            passwordField(),
            Container( margin: EdgeInsets.only(bottom: 25.0),),
            submitButton(),
            ],
        ),
      ),
    );
  }

Widget emailField() {
  return TextFormField(
    keyboardType: TextInputType.emailAddress,
    decoration: InputDecoration(
      labelText: 'Email Address',
      hintText: 'you@example.com',
    ),
    validator: validateEmail,
    onSaved: (value) {
      email = value;
    },
  );
}
Widget passwordField() {
  return TextFormField(
    decoration: InputDecoration(
      labelText: 'Password',
      hintText: 'Password',
    ),
    validator: validatePassword,
    onSaved: (value) {
      password = value;
    },
  );
}
Widget submitButton() {
  return RaisedButton(
    color: Colors.blue,
    child: Text('Submit'),
    onPressed: () {
      if(formKey.currentState.validate()) {
        formKey.currentState.save();
        print("this is the best way to post my $email and my $password to an API");
      }
    },
  );
}
}
