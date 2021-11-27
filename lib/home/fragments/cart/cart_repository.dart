
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ecommerce/registration/authentication/auth_cubit.dart';
import 'package:ecommerce/utils.dart';

import '../../../constants.dart';


class CartRepository {

  final Dio dio = Dio();

  Future<Response> loadCart() async {
    final response = await dio.get(BASE_URL + "/cart/",options: Options(headers: {HttpHeaders.authorizationHeader:AuthCubit.token}));
    return response;
  }
  Future<Response> add(id) async {
    final response = await dio.post(BASE_URL + "/cart/",data:{
      'id':id,
    },options: Options(headers: {HttpHeaders.authorizationHeader:AuthCubit.token}));
    return response;
  }
  Future<Response> remove(id) async {
    final response = await dio.delete(BASE_URL + "/cart/",queryParameters:{
      'id':id,
    },options: Options(headers: {HttpHeaders.authorizationHeader:AuthCubit.token}));
    return response;
  }

  Future<Response> applyCoupon(code,totalAmt) async {
    final response = await dio.post(BASE_URL + "/apply_coupon/",data:{
      'code':code,
      'totalAmt':totalAmt,
    },options: Options(headers: {HttpHeaders.authorizationHeader:AuthCubit.token}));
    return response;
  }


  Future<Response> initiatePayment(CartTotals cartTotals,String?coupon_code,String payment_mode,String address_id,bool from_cart) async {
    final response = await dio.post(BASE_URL + "/initiate_payment/",data:{
      'items': cartTotals.cartItems.map((e) => {"id":e.id,"quantity":e.selectedQuantity}).toList(),
      'address_id':address_id,
      'from_cart':from_cart,
      'total_amount':cartTotals.totalAmount,
      'tx_amount':cartTotals.totalAmount - cartTotals.discountAmt,
      'coupon_code':coupon_code,
      'payment_mode':payment_mode,
    },options: Options(headers: {HttpHeaders.authorizationHeader:AuthCubit.token}));
    return response;
  }

}