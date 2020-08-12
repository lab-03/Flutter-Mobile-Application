import 'dart:convert';

import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthorizationBloc {

  String _tokenString = "";
  final PublishSubject _isSessionValid = PublishSubject<bool>();
  Stream<bool> get isSessionValid => _isSessionValid.stream;
  void dispose() {
    _isSessionValid.close();
  }

  void restoreSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _tokenString = prefs.get("token");
    if (_tokenString != null && _tokenString.length > 0) {
      _isSessionValid.sink.add(true);
    } else {
      _isSessionValid.sink.add(false);
    }
  }
  void openSession(String token, String response, Map<String, String> headers) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("response in session: ${response}");
    print("headers in session: ${headers}");
    await prefs.setString("token", token);

    _tokenString = token;
    await prefs.setString("signin_response", response);
    await prefs.setString("signin_headers", json.encode(headers));
    _isSessionValid.sink.add(true);

    print("tokenString ${_tokenString}22");
  }

  void closeSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("token");
    prefs.remove("signin_response");
    prefs.remove("signin_headers");
    // prefs.remove("token");
    
    prefs.clear();
    _isSessionValid.sink.add(false);
  }
}
final authBloc = AuthorizationBloc();