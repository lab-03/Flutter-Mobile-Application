
import 'dart:convert';
import 'dart:io';
import 'package:login_bloc/src/blocs/validators.dart';
import 'package:login_bloc/src/resources/repository.dart';
import 'package:mime/mime.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'authorization_bloc.dart';

class SignupBloc extends Validators {

  Repository repository = Repository();

  final BehaviorSubject _nameController = BehaviorSubject<String>();
  final BehaviorSubject _imageController = BehaviorSubject<bool>();
  final BehaviorSubject _emailController = BehaviorSubject<String>();
  final BehaviorSubject _passwordController = BehaviorSubject<String>();
  final PublishSubject _loadingData = PublishSubject<bool>();

  Function(String) get changeName => _nameController.sink.add;
  // Function(String) get changeImage => _imageController.sink.add;
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  Stream<String> get name => _nameController.stream.transform(validateName);
  // Stream<String> get image => _imageController.stream.transform(validateImage);
  Stream<String> get email => _emailController.stream.transform(validateEmail);
  Stream<String> get password => _passwordController.stream.transform(validatePassword);
  Stream<bool> get submitValid => Rx.combineLatest3(name, email, password, (n, e, p) => true);
  Stream<bool> get loading => _loadingData.stream;

  void submit(File image) async {
    final validName = _nameController.value;
    // final validImage = _imageController.value;
    final validEmail = _emailController.value;
    final validPassword = _passwordController.value;
    print("Everything is okay>>>");
    Uri apiUrl = Uri.parse(
      'https://a-tracker.herokuapp.com/students');
    Future<Map<String, dynamic>> _uploadImage(File image) async {
      _loadingData.add(true);

      final mimeTypeData =
          lookupMimeType(image.path, headerBytes: [0xFF, 0xD8]).split('/');

      // Intilize the multipart request
      final imageUploadRequest = http.MultipartRequest('POST', apiUrl);

      // Attach the file in the request
      final file = await http.MultipartFile.fromPath(
          'student[image]', image.path,
          contentType: MediaType(mimeTypeData[0], mimeTypeData[1]));
      print("image: ${image}");
      print("file: ${file}");

      imageUploadRequest.files.add(file);
      //imageUploadRequest.fields['name'] = validName;
      imageUploadRequest.fields['student[email]'] = validEmail;
      imageUploadRequest.fields['student[password]'] = validPassword;

      try {
        final streamedResponse = await imageUploadRequest.send();
        final response = await http.Response.fromStream(streamedResponse);
        if (response.statusCode != 201) {
          print(response.statusCode);
          print("Not Correct!!");
          return null;
        }
        final Map<String, dynamic> responseData = json.decode(response.body);
        //_resetState();
        return responseData;
      } catch (e) {
        print(e);
        return null;
      }
    }
    if (image != null) {
      
      signup(validName, image.toString(), validEmail, validPassword);
      // final Map<String, dynamic> response = await _uploadImage(image);
      // print(response);
      // if (response["id"] < 0) {
      //   // _loadingData.add(false);
      //   print('hello world');
      //   signup(validName, image.toString(), validEmail, validPassword);
      // } else {
      //   print('Please Select a profile photo profile Photo');
      //   dispose();
      // }
    }      
  }

  signup(String name, String image, String email, String password) async {
    String token = await repository.signup(name, image, email, password);
    print(token);
    _loadingData.sink.add(false);
    authBloc.openSession(token);
    print('gell');
  }

  void dispose() {
    _nameController.close();
    _imageController.close();
    _emailController.close();
    _passwordController.close();
    _loadingData.close();
  }

}