import 'package:dio/dio.dart';
import 'package:ecommerce/registration/forgotpassword/forgotpassword_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'forgotpassword_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordRepository _forgotPasswordRepository =
      ForgotPasswordRepository();

  ForgotPasswordCubit() : super(ForgotPasswordInitial());

  void resetPassword(email) {
    emit(ForgotPasswordSubmitting());
    _forgotPasswordRepository.reset_password(email: email).then((response) {
      emit(ForgotPasswordSuccess());
    }).catchError((value) {
      DioError error = value;
      if (error.response != null) {
        try {
          emit(ForgotPasswordFailed(error.response!.data));
        } catch (e) {
          emit(ForgotPasswordFailed(error.response!.data['detail']));
        }
      } else {
        if (error.type == DioErrorType.other) {
          emit(ForgotPasswordFailed("Please check your internet connection!"));
        } else {
          emit(ForgotPasswordFailed(error.message));
        }
      }
    });
  }
}
