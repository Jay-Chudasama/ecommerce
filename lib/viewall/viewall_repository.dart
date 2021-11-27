import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ecommerce/registration/authentication/auth_cubit.dart';

import '../../../constants.dart';

class ViewAllRepository {

  final Dio dio = Dio();

  Future<Response> load(id) async {
    final response = await dio.get(BASE_URL + "/view_all/",
        queryParameters: {'id':id,'limit':VIEWALL_PAGE_LIMIT},
        options: Options(
            headers: {HttpHeaders.authorizationHeader: AuthCubit.token}));
    return response;
  }

  Future<Response> moreResults({required String nextUrl}) async {
    final response = await dio.get(nextUrl,
        options: Options(headers: {HttpHeaders.authorizationHeader: AuthCubit.token}));
    return response;
  }

}