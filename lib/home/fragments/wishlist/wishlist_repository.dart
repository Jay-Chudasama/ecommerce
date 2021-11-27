
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ecommerce/registration/authentication/auth_cubit.dart';

import '../../../constants.dart';


class WishlistRepository {

  final Dio dio = Dio();

  Future<Response> loadWishlist() async {
    final response = await dio.get(BASE_URL + "/wishlist/",options: Options(headers: {HttpHeaders.authorizationHeader:AuthCubit.token}));
    return response;
  }
  Future<Response> add(id) async {
    final response = await dio.post(BASE_URL + "/wishlist/",data:{
      'id':id,
    },options: Options(headers: {HttpHeaders.authorizationHeader:AuthCubit.token}));
    return response;
  }
  Future<Response> remove(id) async {
    final response = await dio.delete(BASE_URL + "/wishlist/",queryParameters:{
      'id':id,
    },options: Options(headers: {HttpHeaders.authorizationHeader:AuthCubit.token}));
    return response;
  }


}