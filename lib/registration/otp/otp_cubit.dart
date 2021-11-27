import 'dart:async';
import 'otp_repository.dart';
import 'otp_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OtpCubit extends Cubit<OtpState> {
  OtpRepository otpRepository = OtpRepository();
  var timer;

  OtpCubit() : super(OtpInitial());

  void verifyOtp(
      {required String email,
        required String phone,
        required String name,
        required String password,
        required String otp}) {
    if (timer != null) {
      timer.cancel();
    }
    emit(OtpVerifying());
    otpRepository
        .verifyOtp(
      phone: phone,
      otp: otp,
    )
        .then((response) {
      _createAccount(email, phone, name, password);
    }).catchError((value) {
      DioError error = value;
      if (error.response != null) {
        emit(OtpVerificationFailed(error.response!.data));
      } else {
        if (error.type == DioErrorType.other) {
          emit(OtpVerificationFailed("Please check your internet connection!"));
        } else {
          emit(OtpVerificationFailed(error.message));
        }
      }
    });
  }

  void verifyUpdateOtp(
      {
        required String phone,
        required String otp}) {
    if (timer != null) {
      timer.cancel();
    }
    emit(OtpVerifying());
    otpRepository
        .verifyOtp(
      phone: phone,
      otp: otp,
    )
        .then((response) {
   emit(OtpVerified(""));
    }).catchError((value) {
      DioError error = value;
      if (error.response != null) {
        emit(OtpVerificationFailed(error.response!.data));
      } else {
        if (error.type == DioErrorType.other) {
          emit(OtpVerificationFailed("Please check your internet connection!"));
        } else {
          emit(OtpVerificationFailed(error.message));
        }
      }
    });
  }

  void _createAccount(email, phone, name, password) {
    otpRepository
        .createAccount(
            email: email, phone: phone, name: name, password: password)
        .then((response) {
      emit(OtpVerified(response.data));
    }).catchError((value) {
      DioError error = value;
      if (error.response != null) {
        emit(OtpVerificationFailed(error.response!.data));
      } else {
        if (error.type == DioErrorType.other) {
          emit(OtpVerificationFailed("Please check your internet connection!"));
        } else {
          emit(OtpVerificationFailed(error.message));
        }
      }
    });
  }

  void resendOtp({required phone}) {
    otpRepository.resendOtp(phone: phone);
  }
}
