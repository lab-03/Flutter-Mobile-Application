import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:login_bloc/src/blocs/validators.dart';
import 'package:login_bloc/src/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

import 'authorization_bloc.dart';

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
    var jsonResponse = null;
    var response = await http.post("https://a-tracker.herokuapp.com/auth/sign_in", body: data);
    if(response.statusCode == 200) {
      _loadingData.sink.add(true);
      jsonResponse = json.decode(response.body);
      if(jsonResponse != null) {
        login(validEmail, validPassword);
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

  login(String email, String password) async {
    String token = await repository.login(email, password);
    print(token);
    _loadingData.sink.add(false);
    authBloc.openSession(token);
  }

  void dispose() {
    _emailController.close();
    _passwordController.close();
    _loadingData.close();
  }

}