import 'auth_provider.dart';

class Repository {
  final AuthProvider authProvider = AuthProvider();
  Future<String> login(String email, String password) 
    => authProvider.login(email: email, password: password);
    
  Future<String> signup(String name, String image, String email, String password) 
    => authProvider.signup(name: name, image: image, email: email, password: password);
}