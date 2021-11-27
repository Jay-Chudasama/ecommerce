import 'package:ecommerce/models/user_model.dart';
import 'package:ecommerce/registration/authentication/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  static String token = '';
  AuthRepository authRepository;
  final FlutterSecureStorage storage;

  AuthCubit({required this.storage, required this.authRepository})
      : super(AuthInitial());

  Future<AuthState> authenticate() async {
      AuthState newState;
    if (token.isEmpty) {
      //// Extracting token from storage

      try{
        var tokenValue = await _getToken();
        if (tokenValue == null) {
          newState = LoggedOut();
          emit(newState);

        } else {
          token = tokenValue;
          newState = await _fetchUserData();
        }
      }catch(e){
        newState = LoggedOut();
        emit(newState);
      }
    } else {
     newState = await _fetchUserData();
    }
    return newState;
  }

//  void authenticate() {
//    emit(Authenticating());
//    if (token.isEmpty) {
//      //// Extracting token from storage
//      _getToken().then((tokenValue) {
//        if (tokenValue == null) {
//          emit(LoggedOut());
//        } else {
//          token = tokenValue;
//          _fetchUserData();
//        }
//      });
//    } else {
//      _fetchUserData();
//    }
//  }
  Future<AuthState> _fetchUserData() async {
    AuthState newState;
    try{
      var response = await authRepository.getUserData(token: token);
      newState = Authenticated(
          userdata: UserModel.fromJson(response.data),
          token:
          token);
      emit(newState);
    }catch(value){
      DioError error = value as DioError;
      if (error.response != null) {
        newState = await removeToken();
      } else {
        if (error.type == DioErrorType.other) {
          newState = AuthenticationFailed("Please check your internet connection!");
          emit(newState);
        } else {
          newState =AuthenticationFailed(error.message);
          emit(newState);
        }
      }
    }

    return newState;

  }

  void updateUserData(UserModel userModel){
    emit(Authenticated(userdata: userModel, token: token));
  }

  void loggedIn(String tokenValue) {
    emit(Authenticating());
    token = tokenValue;
    _setToken(token).then((value) => _fetchUserData());
  }

  void logout(logoutAll) {
    emit(Authenticating());
    authRepository.logout(logoutAll).then((response) {
      removeToken();
    }).catchError((value) {
      DioError error = value;
      if (error.response != null) {
        removeToken();
      } else {
        if (error.type == DioErrorType.other) {
          emit(AuthenticationFailed("Please check your internet connection!"));
          removeToken(); ///delete token even offline to logout
        } else {
          emit(AuthenticationFailed(error.message));
          removeToken(); ///delete token even offline to logout
        }
      }
    });
  }

  Future<AuthState> removeToken() async{
    AuthState newState;
    token = '';
    try{
      await _deleteToken();
    }catch(e){
//      do nothing
    }
    newState =  LoggedOut();
    emit(LoggedOut());
    return newState;
  }

  Future<void> _setToken(token) async {
    await storage.write(key: "token", value: token);
  }

  Future<String?> _getToken() async {
    String? value = await storage.read(key: "token");
    return value;
  }

  Future<void> _deleteToken() async {
    await storage.delete(key: "token");
  }
}