
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ecommerce/registration/authentication/auth_cubit.dart';

import '../../../constants.dart';


class EditInfoRepository {

  final Dio dio = Dio();

  Future<Response> requestUpdateOtp(phone,password) async {
    final response = await dio.post(BASE_URL + "/update_phone_request_otp/",data:{
      "phone":phone,
      "password":password,
    },options: Options(headers: {HttpHeaders.authorizationHeader:AuthCubit.token}));
    return response;
  }

  Future<Response> updateInfo(email,phone,name,password) async {
    final response = await dio.post(BASE_URL + "/update_info/",data:{
      "phone":phone,
      "email":email,
      "name":name,
      "password":password,
    },options: Options(headers: {HttpHeaders.authorizationHeader:AuthCubit.token}));
    return response;
  }


}