import 'dart:io';

import 'package:flutter/material.dart';

class AuthProvider {

 Future<String> login({
 @required String email,
 @required String password,
 }) async {
  await Future.delayed(Duration(seconds: 1));
  return "token-info";
 }

 Future<String> signup({
 @required String name,
 @required String image,
 @required String email,
 @required String password,
 }) async {
  await Future.delayed(Duration(seconds: 1));
  return "token-info";
 }
}