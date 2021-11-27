import 'package:dio/dio.dart';
import 'package:ecommerce/changepassword/changepassword_repository.dart';
import 'package:ecommerce/changepassword/changepassword_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState>{
  ChangePasswordCubit() : super(ChangePasswordInitial());

  ChangePasswordRepository _changePasswordRepository = ChangePasswordRepository();

  void changePassword(oldPassword,newPassword){
  emit(ChangePasswordSubmitting());
  _changePasswordRepository.changePassword(oldPassword, newPassword).then((response) {
    emit(ChangePasswordSubmitted());
  }).catchError((value) {
    DioError error = value;
    if (error.response != null) {
      try {
        emit(ChangePasswordFailed(error.response!.data));
      } catch (e) {
        emit(ChangePasswordFailed(error.response!.data['detail']));
      }
    } else {
      if (error.type == DioErrorType.other) {
        emit(ChangePasswordFailed("Please check your internet connection!"));
      } else {
        emit(ChangePasswordFailed(error.message));
      }
    }
  });
  }

}