import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ecommerce/registration/authentication/auth_cubit.dart';

import '../../../constants.dart';

class ReviewsRepository {

  final Dio dio = Dio();

  Future<Response> loadReviews(productId) async {
    final response = await dio.get(BASE_URL + "/reviews/",
        queryParameters: {'id':productId,'limit':QUESTIONS_PAGE_LIMIT},
        options: Options(
            headers: {HttpHeaders.authorizationHeader: AuthCubit.token}));
    return response;
  }

  Future<Response> loadMoreReviews({required String nextUrl}) async {
    final response = await dio.get(nextUrl,
        options: Options(headers: {HttpHeaders.authorizationHeader: AuthCubit.token}));
    return response;
  }



}