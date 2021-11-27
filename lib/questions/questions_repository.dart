import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ecommerce/registration/authentication/auth_cubit.dart';

import '../../../constants.dart';

class QuestionsRepository {

  final Dio dio = Dio();

  Future<Response> loadQuestions(productId,query) async {
    final response = await dio.get(BASE_URL + "/questions/",
        queryParameters: {'id':productId,'query':query,'limit':QUESTIONS_PAGE_LIMIT},
        options: Options(
            headers: {HttpHeaders.authorizationHeader: AuthCubit.token}));
    return response;
  }

  Future<Response> loadMoreQuestions({required String nextUrl}) async {
    final response = await dio.get(nextUrl,
        options: Options(headers: {HttpHeaders.authorizationHeader: AuthCubit.token}));
    return response;
  }

  Future<Response> postQuestion(productId,query) async {
    final response = await dio.post(BASE_URL + "/questions/",
        data: {'id':productId,'query':query},
        options: Options(
            headers: {HttpHeaders.authorizationHeader: AuthCubit.token}));
    return response;
  }

}