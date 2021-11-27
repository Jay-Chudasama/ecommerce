import 'package:dio/dio.dart';
import 'package:ecommerce/registration/signup/signup_repository.dart';
import 'package:ecommerce/registration/signup/signup_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpCubit extends Cubit<SignUpState>{
  SignUpCubit() : super(SignUpInitial());
  final SignUpRepository _signUpRepository = SignUpRepository();


  void requestOtp(email,phone){
    emit(SignUpSubmitting());
    _signUpRepository.requestOtp(email,phone).then((response) {
      emit(SignUpSuccess());
    }).catchError((value) {
      DioError error = value;
      if (error.response != null) {
       emit(SignUpFailed(error.response!.data));
      } else {
        if (error.type == DioErrorType.other) {
          emit(SignUpFailed("Please check your internet connection!"));
        } else {
          emit(SignUpFailed(error.message));
        }
      }
    });
  }

}