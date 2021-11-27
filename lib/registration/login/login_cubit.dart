import 'package:dio/dio.dart';
import 'package:ecommerce/registration/login/login_repository.dart';
import 'package:ecommerce/registration/login/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginRepository _loginRepository = LoginRepository();

  LoginCubit() : super(LoginInitial());

  void login(email_phone, password) {
    String? email, phone;
    emit(LoginSubmitting());
    if (RegExp(EMAIL_REGEX).hasMatch(email_phone)) {
      email = email_phone;
    } else {
      phone = email_phone;
    }
    _loginRepository
        .login(password: password, email: email, phone: phone)
        .then((response) {
      emit(LoginSuccess(response.data));
    }).catchError((value) {
      DioError error = value;
      if (error.response != null) {
        try{
        emit(LoginFailed(error.response!.data));
        }catch(e){
          emit(LoginFailed(error.response!.data['detail']));
        }
      } else {
        if (error.type == DioErrorType.other) {
          emit(LoginFailed("Please check your internet connection!"));
        } else {
          emit(LoginFailed(error.message));
        }
      }
    });
  }
}
