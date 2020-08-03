import 'dart:async';

class Validators {
  final validateName = StreamTransformer<String, String>.fromHandlers(
    handleData: (name, sink) {
      RegExp exp = new RegExp(r"^[a-zA-Z.+'-]+(?: [a-zA-Z.+'-]+){2,} ?$"); //r"^[a-zA-Z0-9._%+-]+@stud\.fci-cu\.edu\.eg$"
      if (exp.hasMatch(name)) {
        sink.add(name);
      } else {
        sink.addError("Please enter at least 3 names !!!");
      }
    }
  );

  final validateImage = StreamTransformer<String, String>.fromHandlers(
    handleData: (image, sink) {
      // if (image == "Done") {
      //   sink.add(image);
      // } else {
      //   sink.addError("Please enter at least 3 images !!!");
      // }
      sink.add(image);
    }
  );

  final validateEmail = StreamTransformer<String, String>.fromHandlers(
    handleData: (email, sink) {
      RegExp exp = new RegExp(r"^[a-zA-Z0-9._%+-]+"); //r"^[a-zA-Z0-9._%+-]+@stud\.fci-cu\.edu\.eg$"
      //r"^[a-zA-Z0-9._%+-]+"
      if (exp.hasMatch(email)) {
        sink.add(email);
      } else {
        sink.addError("Please enter valid Email !!!");
      }
    }
  );

  final validatePassword = StreamTransformer<String, String>.fromHandlers(
    handleData: (password, sink) {
      if (password.length == 6) { // 8
        sink.add(password);
      } else {
        sink.addError("Password must be 8 charachters !!!");
      }
    }
  );
}