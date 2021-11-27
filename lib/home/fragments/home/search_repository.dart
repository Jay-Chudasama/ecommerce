import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ecommerce/registration/authentication/auth_cubit.dart';

import '../../../constants.dart';

class SearchRepository {

  final Dio dio = Dio();

  Future<Response> search(query) async {
    final response = await dio.get(BASE_URL + "/search/",
        queryParameters: {'query':query,'limit':SEARCH_PAGE_LIMIT},
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