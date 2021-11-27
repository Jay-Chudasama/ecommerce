import 'package:ecommerce/models/user_model.dart';

abstract class AuthState{}

class AuthInitial extends AuthState{}

class Authenticating extends AuthState{

  Authenticating();
}

class Authenticated extends AuthState{
  final String token;
  final UserModel userdata;
  Authenticated({required this.userdata,required this.token});
}

class AuthenticationFailed extends AuthState{
  String message;

  AuthenticationFailed(this.message);
}

class LoggedOut extends AuthState{}