import 'package:login_bloc/src/blocs/validators.dart';
import 'package:login_bloc/src/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

import 'authorization_bloc.dart';

class SignupBloc extends Validators {

  Repository repository = Repository();

  final BehaviorSubject _nameController = BehaviorSubject<String>();
  final BehaviorSubject _imageController = BehaviorSubject<String>();
  final BehaviorSubject _emailController = BehaviorSubject<String>();
  final BehaviorSubject _passwordController = BehaviorSubject<String>();
  final PublishSubject _loadingData = PublishSubject<bool>();

  Function(String) get changeName => _nameController.sink.add;
  Function(String) get changeImage => _imageController.sink.add;
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  Stream<String> get name => _nameController.stream.transform(validateName);
  Stream<String> get image => _imageController.stream.transform(validateImage);
  Stream<String> get email => _emailController.stream.transform(validateEmail);
  Stream<String> get password => _passwordController.stream.transform(validatePassword);
  Stream<bool> get submitValid => Rx.combineLatest4(name, image, email, password, (n, i, e, p) => true);
  Stream<bool> get loading => _loadingData.stream;

  void submit() {
    final validName = _nameController.value;
    final validImage = _imageController.value;
    final validEmail = _emailController.value;
    final validPassword = _passwordController.value;
    _loadingData.sink.add(true);
    signup(validName, validImage, validEmail, validPassword);

  }

  signup(String name, String image, String email, String password) async {
    String token = await repository.signup(name, image, email, password);
    _loadingData.sink.add(false);
    authBloc.openSession(token);
  }

  void dispose() {
    _nameController.close();
    _imageController.close();
    _emailController.close();
    _passwordController.close();
    _loadingData.close();
  }

}