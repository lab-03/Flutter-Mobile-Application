import 'dart:async';

class Validators {

  final validateEmail = StreamTransformer<String, String>.fromHandlers(
    handleData: (email, sink) {
      RegExp exp = new RegExp(r"^[a-zA-Z0-9._%+-]+@stud\.fci-cu\.edu\.eg$");
      if (exp.hasMatch(email)) {
        sink.add(email);
      } else {
        sink.addError("Please enter valid Email !!!");
      }
    }
  );

  final validatePassword = StreamTransformer<String, String>.fromHandlers(
    handleData: (password, sink) {
      if (password.length == 8) {
        sink.add(password);
      } else {
        sink.addError("Password must be 8 charachters !!!");
      }
    }
  );
}