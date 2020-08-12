import 'dart:async';
import './validators.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';

class Bloc extends Object with Validators {
  final _nameController = BehaviorSubject<String>();
  final _imageController = BehaviorSubject<String>();
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();


  Stream<String> get name => _nameController.stream.transform(validateName);
  Stream<String> get image => _imageController.stream.transform(validateImage);
  Stream<String> get email => _emailController.stream.transform(validateEmail);
  Stream<String> get password => _passwordController.stream.transform(validatePassword);
  Stream<bool> get submitLoginValid => Rx.combineLatest2(email, password, (e, p) => true);
  Stream<bool> get submitSignupValid => Rx.combineLatest4(name, image, email, password, (n, i, e, p) => true);

  Function(String) get changeName => _nameController.sink.add;
  Function(String) get changeImage => _imageController.sink.add;
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  submitLogin(context) {
    final validEmail = _emailController.value;
    final validPassword = _passwordController.value;

    print("Email is $validEmail");
    print("Password is $validPassword");
    
    Navigator.pushNamed(context, '/home');
  }
  submitSignup(context) {
    final validName = _nameController.value;
    final validEmail = _emailController.value;
    final validPassword = _passwordController.value;

    print("Name is $validName");
    print("Email is $validEmail");
    print("Password is $validPassword");
    
    Navigator.pushNamed(context, '/home');
  }

  returnToLogin(context) {
    Navigator.pushNamed(context, '/login');
  }
  dispose () {
    _nameController.close();
    _emailController.close();
    _passwordController.close();
  }

}
final bloc = new Bloc();