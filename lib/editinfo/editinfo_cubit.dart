import 'package:dio/dio.dart';
import 'package:ecommerce/editinfo/editinfo_repository.dart';
import 'package:ecommerce/editinfo/editinfo_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditInfoCubit extends Cubit<EditInfoState> {
  EditInfoCubit() : super(EditInfoInitial());
  EditInfoRepository _editInfoRepository = EditInfoRepository();

  void requestUpdateOtp(phone, password) {
    emit(EditInfoSubmitting());
    _editInfoRepository.requestUpdateOtp(phone, password).then((response) {
      emit(EditInfoOtpRequested());
    }).catchError((value) {
      DioError error = value;
      if (error.response != null) {
        try {
          emit(EditInfoFailed(error.response!.data));
        } catch (e) {
          emit(EditInfoFailed(error.response!.data['detail']));
        }
      } else {
        if (error.type == DioErrorType.other) {
          emit(EditInfoFailed("Please check your internet connection!"));
        } else {
          emit(EditInfoFailed(error.message));
        }
      }
    });
  }
  void updateInfo(email,phone,name, password) {
    emit(EditInfoSubmitting());
    _editInfoRepository.updateInfo(email,phone,name, password).then((response) {
      emit(EditInfoSubmitted());
    }).catchError((value) {
      DioError error = value;
      if (error.response != null) {
        try {
          emit(EditInfoFailed(error.response!.data));
        } catch (e) {
          emit(EditInfoFailed(error.response!.data['detail']));
        }
      } else {
        if (error.type == DioErrorType.other) {
          emit(EditInfoFailed("Please check your internet connection!"));
        } else {
          emit(EditInfoFailed(error.message));
        }
      }
    });
  }
}
