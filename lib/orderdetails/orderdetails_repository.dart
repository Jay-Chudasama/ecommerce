import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ecommerce/models/user_model.dart';
import 'package:ecommerce/registration/authentication/auth_cubit.dart';

import '../../../constants.dart';


class OrderDetailsRepository {

  final Dio dio = Dio();

  Future<Response> loadOrder(id) async {
    final response = await dio.get(BASE_URL + "/order_details/",queryParameters: {'id':id},options: Options(headers: {HttpHeaders.authorizationHeader:AuthCubit.token}));
    return response;
  }
  Future<Response> cancelOrder(id,payout_details_id) async {
    final response = await dio.post(BASE_URL + "/cancel_order/",data: {'ordered_product_id':id,'payout_details_id':payout_details_id},options: Options(headers: {HttpHeaders.authorizationHeader:AuthCubit.token}));
    return response;
  }
}