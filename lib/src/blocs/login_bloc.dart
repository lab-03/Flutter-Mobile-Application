import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:login_bloc/src/blocs/validators.dart';
import 'package:login_bloc/src/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

import 'authorization_bloc.dart';

import 'package:firebase_messaging/firebase_messaging.dart';

class LoginBloc extends Validators {

  Repository repository = Repository();

  final BehaviorSubject _emailController = BehaviorSubject<String>();
  final BehaviorSubject _passwordController = BehaviorSubject<String>();
  final PublishSubject _loadingData = PublishSubject<bool>();
  final PublishSubject _errorController = PublishSubject<bool>();

  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  Stream<String> get email => _emailController.stream.transform(validateEmail);
  Stream<String> get password => _passwordController.stream.transform(validatePassword);
  Stream<bool> get submitValid => Rx.combineLatest2(email, password, (email, password) => true);
  Stream<bool> get loading => _loadingData.stream;
  Stream<bool> get error => _errorController.stream;


  void submit() async{
    final validEmail = _emailController.value;
    final validPassword = _passwordController.value;
    Map data = {
      'email': validEmail,
      'password': validPassword,
    };
    var jsonResponseBody = null;
    // var jsonResponseHeaders = null;
    var response = await http.post("https://a-tracker.herokuapp.com/auth/sign_in", body: data);
    if(response.statusCode == 200) {
      _loadingData.sink.add(true);
      jsonResponseBody = json.decode(response.body);
      // jsonResponseHeaders = jsonDecode(response.headers);
      if(jsonResponseBody != null) {
        print(jsonResponseBody);
        print(response.headers);
        print(response.headers["access-token"]);
        print(response.headers["client"]);
        print(response.headers["uid"]);
        
        // // Adding Device Token to users
        // final FirebaseMessaging _fcm = FirebaseMessaging();
        // String deviceToken = await _fcm.getToken();
        // Map deviceTokenData = {
        //   'device_token': {
        //     'token': deviceToken,
        //     'device_type': "web" 
        //   } 
        // };
        // var jsonResponseOfDeviceToken = null;
        // var deviceTokenResponse = await http.post("https://a-tracker.herokuapp.com//users/add_device_token", body: deviceTokenData);
        // if(deviceTokenResponse.statusCode == 200) {
        //   print("deviceRespose status: 200");
        //   jsonResponseOfDeviceToken = json.decode(deviceTokenResponse.body);
        //   if(jsonResponseOfDeviceToken != null) {
        //     print(jsonResponseOfDeviceToken);
        //   }
        // }
        
        
        login(validEmail, validPassword, response.body ,response.headers);
      }
    }
    else {
      _loadingData.sink.add(true);
      _errorController.sink.add(true);
      print(response.body);
      _loadingData.sink.add(false);
      // _emailController.sink.close();
      // _passwordController.sink.close();
    }

  }

  login(String email, String password, String response, Map<String, String> headers) async {
    String token = await repository.login(email, password);
    print(token);
    _loadingData.sink.add(false);
    authBloc.openSession(token, response, headers);
  }

  void dispose() {
    _emailController.close();
    _passwordController.close();
    _loadingData.close();
  }

}