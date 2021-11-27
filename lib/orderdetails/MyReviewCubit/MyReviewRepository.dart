import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ecommerce/models/user_model.dart';
import 'package:ecommerce/registration/authentication/auth_cubit.dart';

import '../../../constants.dart';


class MyReviewRepository {

  final Dio dio = Dio();

  Future<Response> updateReview(id,ordered_product_id,rating,review) async {
    final response = await dio.post(BASE_URL + "/reviews/",data:
    {
      'id':id,
      'ordered_product_id':ordered_product_id,
      'rating':rating,
      'review':review
    }
    ,options: Options(headers: {HttpHeaders.authorizationHeader:AuthCubit.token}));
    return response;
  }

}