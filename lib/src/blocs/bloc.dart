import 'dart:async';
import './validators.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';

class Bloc extends Object with Validators {
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();


  Stream<String> get email => _emailController.stream.transform(validateEmail);
  Stream<String> get password => _passwordController.stream.transform(validatePassword);
  Stream<bool> get submitValid => Rx.combineLatest2(email, password, (e, p) => true);

  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  submit(context) {
    final validEmail = _emailController.value;
    final validPassword = _passwordController.value;

    print("Email is $validEmail");
    print("Password is $validPassword");

    Navigator.pushNamed(context, '/home');
  }
  dispose () {
    _emailController.close();
    _passwordController.close();
  }

}
final bloc = Bloc();