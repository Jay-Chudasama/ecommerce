
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ecommerce/registration/authentication/auth_cubit.dart';

import '../constants.dart';

class ChangePasswordRepository {

  final Dio dio = Dio();

  Future<Response> changePassword(oldPassword,newPassword) async {
    final response = await dio.post(BASE_URL + "/change_password/",data:{
      "old_password":oldPassword,
      "new_password":newPassword,
    },options: Options(headers: {HttpHeaders.authorizationHeader:AuthCubit.token}));
    return response;
  }
}