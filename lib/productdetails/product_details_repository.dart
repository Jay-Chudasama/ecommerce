
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ecommerce/registration/authentication/auth_cubit.dart';

import '../constants.dart';

class ProductDetailsRepository {

  final Dio dio = Dio();

  Future<Response> loadProduct({required String id}) async {
    final response = await dio.get(BASE_URL + "/product/",
        queryParameters: {'id': id},options: Options(headers: {HttpHeaders.authorizationHeader:AuthCubit.token}));
    return response;
  }

}