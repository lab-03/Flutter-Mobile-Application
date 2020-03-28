class ValidationMixin {
  String validateEmail (String email) {
      if (!email.contains('@')) {
        return "Please enter valid s email";
      }
  }

  String validatePassword (String password) {   
    if (password.length != 8 ) {
      return "Please entere a valid password";
    }    
  }
}