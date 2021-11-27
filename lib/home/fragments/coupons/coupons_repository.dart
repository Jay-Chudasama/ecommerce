import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ecommerce/registration/authentication/auth_cubit.dart';

import '../../../constants.dart';

class CouponsRepository {
  final Dio dio = Dio();

  Future<Response> loadCoupons() async {
    final response = await dio.get(BASE_URL + "/my_coupons/",
        options: Options(
            headers: {HttpHeaders.authorizationHeader: AuthCubit.token}));
    return response;
  }
}
